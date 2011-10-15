%% Encode a test vector, x_Dx1, using an RVQ codebook.
%
% There are 4 rules to stop encoding
% (a) 'maxQ'                : use all stages regardless of whether PSNR increases or not, same functionality as gen.exe -l
% (b) 'RofE'                : realm of experience, this is used by Explorer
% (c) 'nullEnc'             : if a certain stage does not decrease rmse, skip it, i.e. null encode it
% (d) 'monR'                : monotonically decreasing rmse, this is what I used in the first draft of my thesis
% Also refer to RVQ__2_encode_decode_old.m which produces the same output as 
% this function, but is a little less intuitive.  Moreover, that function
% only has one decoding rule, 'monR', whereas this function has all rules
%
% This version is for grayscale images.  In RVQ, I make grayscale images 3
% channel by replicating the grayscale channel to all 3 channels.  RVQ then
% processes the 3 channel image as if it were RGB.  However, the
% codevectors for the red, green and blue channels are exactly the same.
% This is why I use mdl_3_EC_DxMQ, the red channel of the codebook.  I could
% just as well have used mdl_CBg_DxMP or mdl_CBb_DxMP since they are all exactly the same
% as mdl_3_EC_DxMQ.  I go on to call this single channel codebook EC_DxMQ, since it
% has D rows and MP codevectors.  The D-dimensional MP codevectors are
% stacked column wise next to each other.
%
% In EC_DxMQ, 1st col is the (q,m)=(1,1) codevector, second col is the
% (q,m)=(1,2) codevector, and so on.  So, MxP codevectors in column format
% are placed side by side one after the other. 
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Date created       : April 17, 2011.
% Date last modified : Nov 12, 2011.
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
    
    EC_DxMQ                 =   RVQ.mdl_3_EC_DxMQ;      %1 channel codebook, get it from the red, green or blue channel
    Q                       =   RVQ.mdl_1_Q___1x1;       %actual number of stages in the codebook
    
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
    rmse_prev               =   1E15 ;                                      %assume that entire input is error, since we haven't decoded it yet
    
%output variables    
    featr_Qx1               =   -9999*ones(maxQ,1);                              %1.i initialize with 0, my code for early termination (Dr Barnes' code was Q+1)
    rmses_Qx1               =   -9999*ones(maxQ,1);
    qidx__Qx1               =   -9999*ones(maxQ,1);
    
    recon_Dx1               =   recon_prev_Dx1;                             %2.
    error_Dx1               =   x_Dx1;                                      %3.
                                                                            %4. SNR which I don't compute here since I'm only using rmse
    rmse                    =   rmse_prev;                                  %5.
    
    temp2_XDR_parQx1        =   [];                     %contains a partial featr_Qx1, i.e., all indeces up to q-th stage
    stopQ                   =   0;

%-------------------------------
%2. PROCESSING
%-------------------------------
    %go over all stages (remember that Q is actual stages in codebook, maxQ
    %is number of stages you wanted)
    qnum=0;
    for q=1:Q

        %part 1: pick best codevector at q-th stage (note that all temporary variables here start with temp1 since this is part 1)
        max_rmse            =   1E15;                                                       %max possible error for this signal
        for m=1:M                         
            CV_Dx1          = RVQ_FILES_getCodevectorFromCodebook(m, q, M, EC_DxMQ);      %get codevector 
            temp1_recon_Dx1 =   recon_prev_Dx1 + CV_Dx1;                                    %(a) reconstruction
            temp1_error_Dx1 =   x_Dx1 - temp1_recon_Dx1;                                    %(b) residual error
            temp1_rmse      =   UTIL_METRICS_compute_rms(  temp1_error_Dx1);                %(c) comparison metric 

            if (temp1_rmse < max_rmse)
                max_rmse    =   temp1_rmse;
                m_best      =   m;                                                          %save best codevector index
            end
        end
        CV_Dx1_best         =   RVQ_FILES_getCodevectorFromCodebook(m_best, q, M, EC_DxMQ); %save best codevector for q-th stage



        %part 2: compute metrics so that we know if we should continue or not
        temp2_recon_Dx1     =   recon_prev_Dx1 + CV_Dx1_best;                                   %(a) reconstruction
        temp2_error_Dx1     =   x_Dx1 - temp2_recon_Dx1;                                        %(b) residual error
        temp2_rmse          =   UTIL_METRICS_compute_rms (temp2_error_Dx1);                     %(c) comparison metric
        temp2_XDR_parQx1    =   [temp2_XDR_parQx1 ; m_best];



        %part3: should we continue or exit?
        if      (strcmp(rule_stop_decoding, 'maxQ'))    %max stages
            this_stage_acceptable   =   true;
        elseif  (strcmp(rule_stop_decoding, 'RofE'))    %realm of experience
            this_stage_acceptable   =   RVQ_RULES_DECODE_STOPPING_realm_of_experience  (RVQ.trg_1_featr_QxN, temp2_XDR_parQx1);
        elseif  (strcmp(rule_stop_decoding, 'nulE'))    %null encoding
            this_stage_acceptable   =   RVQ_RULES_DECODE_STOPPING_monotonic_rmse        (temp2_rmse, rmse_prev);
        elseif  (strcmp(rule_stop_decoding, 'monR'))    %monotonically decreasing rmse
            this_stage_acceptable   =   RVQ_RULES_DECODE_STOPPING_monotonic_rmse        (temp2_rmse, rmse_prev);
        end

        if (this_stage_acceptable ==true)
            qnum            =   qnum + 1;
            
            featr_Qx1(q)    =   m_best;                                 %1. feature vector
            rmses_Qx1(q)    =   temp2_rmse;
            qidx__Qx1(q)    =   q;
    
            recon_Dx1       =   temp2_recon_Dx1;                        %2. reconstructed signal
            error_Dx1       =   temp2_error_Dx1;                        %3. error vector
            rmse            =   temp2_rmse;                             %4. rmse
            stopQ           =   qnum;                                   %(e) number of stages
            
            
        elseif (this_stage_acceptable ==false && strcmp(rule_stop_decoding, 'nulE')==1)
            %do not update anything
        elseif (this_stage_acceptable==false && strcmp(rule_stop_decoding, 'nulE')==0)
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
        RVQ.trg_1_featr_QxN(:,n)    =   featr_Qx1;                          %1.                                               
        RVQ.trg_2_recon_DxN(:,n)    =   recon_Dx1;                          %2. will come from decoder codebook              
        RVQ.trg_3_error_DxN(:,n)    =   error_Dx1;                          %3.   "   "     "     "       "
         
        RVQ.trg_6_encdQ_1xN(1,n)    =   stopQ;                              %6. num of stages in feature vector
        RVQ.trg_7_qidx__QxN(:,n)    =   qidx__Qx1;                          %7. stage index at every stage
        RVQ.trg_8_ermse_QxN(:,n)    =   rmses_Qx1;                          %8. encoder rmse at every stage

        
    elseif (strcmp(RVQ.in_2__data, 'tst'))        
        RVQ.tst_1_featr_QxN(:,n)    =   featr_Qx1;                          %1.             
       
        RVQ.tst_6_encdQ_1xN(1,n)    =   stopQ;                              %6.
        RVQ.tst_7_qidx__QxN(:,n)    =   qidx__Qx1;                          %7. 
    end
