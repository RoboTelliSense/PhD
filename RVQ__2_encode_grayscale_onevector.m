%% Reconstruct a test vector, x_Dx1, using an RVQ codebook.
%
% There are 4 rules to stop decoding (only the first 3 are implemented in this function):
% (a) 'maxQ'                : use all stages regardless of whether PSNR increases or not, same functionality as gen.exe -l
% (b) 'monRMSE'             : monotonic PSNR, this is what I used in the first draft of my thesis
% (c) 'RoE'                 : realm of experience, this is used by Explorer
% (d) 'nullEnc'             : if a certain stage does not increase PSNR, skip it, i.e. null encode it
%
% Also refer to RVQ__2_encode_old.m which produces the same output as 
% this function, but is a little less intuitive.  Moreover, that function
% only has one decoding rule, 'monRMSE', whereas this function adds
% 2 more rules, 'RoE' and 'full_stage'.
%
% This version is for grayscale images.  In RVQ, I make grayscale images 3
% channel by replicating the grayscale channel to all 3 channels.  RVQ then
% processes the 3 channel image as if it were RGB.  However, the
% codevectors for the red, green and blue channels are exactly the same.
% This is why I use mdl_3_CB_DxMP, the red channel of the codebook.  I could
% just as well have used mdl_CBg_DxMP or mdl_CBb_DxMP since they are all exactly the same
% as mdl_3_CB_DxMP.  I go on to call this single channel codebook CB_DxMP, since it
% has D rows and MP codevectors.  The D-dimensional MP codevectors are
% stacked column wise next to each other.
%
% In CB_DxMP, 1st col is the (p,m)=(1,1) codevector, second col is the
% (p,m)=(1,2) codevector, and so on.  So, MxP codevectors in column format
% are placed side by side one after the other. 
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Date created       : April 17, 2011.
% Date last modified : July 30, 2011.
%%
function RVQ = RVQ__2_encode_grayscale_onevector(x_Dx1, RVQ, n)

%-------------------------------
%INITIALIZATION
%-------------------------------
    D                       =   length(x_Dx1);
    
    maxQ                    =   RVQ.in_3__maxQ;
    M                       =   RVQ.in_4__M___;          %number of codevectors/stage
    sw                      =   RVQ.in_6__sw__;          %snippet width
    sh                      =   RVQ.in_7__sh__;          %snippet height
    
    CB_DxMP                 =   RVQ.mdl_3_CB_DxMP;      %1 channel codebook, get it from the red, green or blue channel
    P                       =   RVQ.mdl_1_Q__1x1;       %actual number of stages in the codebook
    
    %rule_stop_decoding
    if (strcmp(RVQ.in_2__data, 'trg'))                  %if we're doing training snippets, use maxQ
        rule_stop_decoding = RVQ.in_9__trgD;            %if 'maxQ', then same output as gen.exe -l.  was forced to do this because gen.exe -l can crash when confronted by certain datasets, 
                                                        %such as dataset 4 created by DM2_create_random, probably
                                                        %because the max value there is >255,actually crashes when when this is not true
                                                        %discussed with Dr Barnes as well.  This version in matlab is very stable
                                                        
    elseif (strcmp(RVQ.in_2__data, 'tst'))
        rule_stop_decoding = RVQ.in_10_tstD;                          %otherwise use the other rule
    end
%-------------------------------
%1. PRE-PROCESSING
%------------------------------- 
%previous
    recon_prev_Dx1          =   zeros(D,1);                                 %state variable
    rmse_prev               =   UTIL_METRICS_compute_rms (x_Dx1) ;          %assume that entire input is error, since we haven't decoded it yet
    
%output variables    
    featr_Px1               =   zeros(maxQ,1);                              %1.i initialize with 0, my code for early termination (Dr Barnes' code was P+1)
    recon_Dx1               =   recon_prev_Dx1;                             %2.
    error_Dx1               =   x_Dx1;                                      %3.
                                                                            %4. SNR which I don't compute here since I'm only using rmse
    rmse                    =   rmse_prev;                                  %5.
    
    temp2_XDR_parPx1        =   [];                     %contains a partial featr_Px1, i.e., all indeces up to p-th stage
    partialP                =   0;

%-------------------------------
%2. PROCESSING
%-------------------------------
    %go over all stages (remember that P is actual stages in codebook, maxQ is number of stages you wanted)
    for p=1:P

        %part 1: pick best codevector at p-th stage (note that all temporary variables here start with temp1 since this is part 1)
        max_rmse            =   UTIL_METRICS_compute_rms (x_Dx1);                           %max possible error for this signal
        for m=1:M                         
            CV_Dx1          =	RVQ_FILES_getCodevectorFromCodebook(m, p, M, CB_DxMP);      %get codevector 
            temp1_recon_Dx1 =   recon_prev_Dx1 + CV_Dx1;                                    %(a) reconstruction
            temp1_error_Dx1 =   x_Dx1 - temp1_recon_Dx1;                                    %(b) residual error
            temp1_rmse      =   UTIL_METRICS_compute_rms(  temp1_error_Dx1);                %(c) comparison metric 

            if (temp1_rmse < max_rmse)
                max_rmse    =   temp1_rmse;
                m_best      =   m;                                                          %save best codevector index
            end
        end
        CV_Dx1_best         =   RVQ_FILES_getCodevectorFromCodebook(m_best, p, M, CB_DxMP); %save best codevector for p-th stage



        %part 2: compute metrics so that we know if we should continue or not
        temp2_recon_Dx1     =   recon_prev_Dx1 + CV_Dx1_best;                                   %(a) reconstruction
        temp2_error_Dx1     =   x_Dx1 - temp2_recon_Dx1;                                        %(b) residual error
        temp2_rmse          =   UTIL_METRICS_compute_rms (temp2_error_Dx1);                     %(c) comparison metric
        temp2_XDR_parPx1    =   [temp2_XDR_parPx1 ; m_best];



        %part3: should we continue or exit?
        if      (strcmp(rule_stop_decoding, 'maxQ'))    %max stages
            continue_decoding   =   true;
        elseif  (strcmp(rule_stop_decoding, 'RofE'))    %realm of experience
            continue_decoding   =   RVQ_RULES_DECODE_STOPPING_realm_of_experience  (RVQ.trg_1_featr_PxN, temp2_XDR_parPx1);
        elseif  (strcmp(rule_stop_decoding, 'nulE'))    %null encoding
            continue_decoding   =   RVQ_RULES_DECODE_STOPPING_monotonic_rmse        (temp2_rmse, rmse_prev);
        elseif  (strcmp(rule_stop_decoding, 'monR'))    %monotonically decreasing rmse
            continue_decoding   =   RVQ_RULES_DECODE_STOPPING_monotonic_rmse        (temp2_rmse, rmse_prev);
        end

        if (continue_decoding ==true)
            featr_Px1(p)    =   m_best;                                 %1. feature vector
            recon_Dx1       =   temp2_recon_Dx1;                        %2. reconstructed signal
            error_Dx1       =   temp2_error_Dx1;                        %3. error vector
            rmse            =   temp2_rmse;                             %4. rmse
            partialP        =   p;                                      %(e) number of stages
        elseif (continue_decoding ==false && strcmp(rule_stop_decoding, 'nulE')==1)
            %do not update anything
        elseif (continue_decoding==false && strcmp(rule_stop_decoding, 'nulE')==0)
            break;
        end


        %part4: overwrite variables that define previous state
        recon_prev_Dx1      =   recon_Dx1;
        rmse_prev           =   rmse;
    end
    %end: going over stages

%-------------------------------
%3. POST-PROCESSING
%-------------------------------
%save stats: 1, 2, 3
    if (strcmp(RVQ.in_2__data, 'trg'))         
        RVQ.trg_1_featr_PxN(:,n)=   featr_Px1;                              %1.                                               
        RVQ.trg_2_recon_DxN(:,n)=   recon_Dx1;                              %2.               
        RVQ.trg_3_error_DxN(:,n)=   error_Dx1;                              %3.               
        
        RVQ.trg_6_partP_1x1(1,n)=   partialP;     
        
    elseif (strcmp(RVQ.in_2__data, 'tst'))        
        RVQ.tst_1_featr_PxN(:,n)=   featr_Px1;                              %1.             
        RVQ.tst_2_recon_DxN(:,n)=   recon_Dx1;                              %2.               
        RVQ.tst_3_error_DxN(:,n)=   error_Dx1;                              %3.        
        
        RVQ.tst_6_partP_1xN(1,n)=   partialP;                                              
    end