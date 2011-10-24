%% Reconstruct a test vector, x_Dx1, using an RVQ codebook.
%
% There are 4 rules to stop decoding (only the first 3 are implemented in this function):
% (a) 'maxP'                : use all stages regardless of whether PSNR increases or not, same functionality as gen.exe -l
% (b) 'monPSNR'             : monotonic PSNR, this is what I used in the first draft of my thesis
% (c) 'RoE'                 : realm of experience, this is used by Explorer
% (d) 'nullEnc'             : if a certain stage does not increase PSNR, skip it, i.e. null encode it
%
% Also refer to RVQ__testing_grayscale_old.m which produces the same output as 
% this function, but is a little less intuitive.  Moreover, that function
% only has one decoding rule, 'monPSNR', whereas this function adds
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

function RVQ = RVQ__testing_grayscale(DM2, RVQ)

%-------------------------------
%INITIALIZATION
%-------------------------------
    [D,N]                   =   size(DM2);
    
    M                       =   RVQ.in_4_M;             %number of codevectors/stage
    sw                      =   RVQ.in_6_sw;            %snippet width
    sh                      =   RVQ.in_7_sh;            %snippet height
    
    CB_DxMP                 =   RVQ.mdl_3_CB_DxMP;      %1 channel codebook, get it from the red, green or blue channel
    P                       =   RVQ.mdl_1_P__1x1;            %actual number of stages in the codebook

    if (strcmp(RVQ.in_2_mode, 'trg'))                   %if we're doing training snippets, use maxP
        rule_stop_decoding = 'maxP';                    %same output as gen.exe -l.  was forced to do this because gen.exe -l can crash when confronted by certain datasets, 
                                                        %such as dataset 4 created by DATAMATRIX_create_random_DM2, probably
                                                        %because the max value there is >255
    elseif (strcmp(RVQ.in_2_mode, 'tst'))
        rule_stop_decoding = RVQ.in_9_rule_stop_decoding;%otherwise use the other rule
    end
        
%-------------------------------
%PRE-PROCESSING
%-------------------------------    
    recon_prev_Dx1           =   zeros(D,1);             %state variable
    PSNRdB_prev             =   0;                      %state variable
    descr_Px1                 =   (P+1) * ones(P,1);      %i initialize with P+1, the code for early termination
    temp2_XDR_parPx1        =   [];                     %contains a partial descr_Px1, i.e., all indeces up to p-th stage

    for n=1:N
        %-------------------------------
        %PRE-PROCESSING
        %-------------------------------    
        x_Dx1                   =   DM2(:,n);
        partialP                =   0;
        
        %-------------------------------
        %POST-PROCESSING
        %-------------------------------
        %go over all stages (remember that P is actual stages in codebook, maxP is number of stages you wanted)
        for p=1:P


            %part 1: pick best codevector at p-th stage (note that all temporary variables here start with temp1 since this is part 1)
            err_norm_min        =   1E15;
            for m=1:M                         
                CV_Dx1          =	RVQ_FILES_getCodevectorFromCodebook(m, p, M, CB_DxMP);      %get codevector 
                temp1_recon_Dx1 =   recon_prev_Dx1 + CV_Dx1;                                    %(a) reconstruction
                temp1_error_Dx1   =   x_Dx1 - temp1_recon_Dx1;                                    %(b) residual error
                temp1_err_norm  =   norm(  temp1_error_Dx1, 2  );                                 %(c) comparison metric 

                if (temp1_err_norm < err_norm_min)
                    err_norm_min=   temp1_err_norm;
                    m_best      =   m;                                                          %save best codevector index
                end
            end
            CV_Dx1_best         =   RVQ_FILES_getCodevectorFromCodebook(m_best, p, M, CB_DxMP); %save best codevector for p-th stage



            %part 2: compute metrics so that we know if we should continue or not
            temp2_recon_Dx1     =   recon_prev_Dx1 + CV_Dx1_best;                                   %(a) reconstruction
            temp2_error_Dx1     =   x_Dx1 - temp2_recon_Dx1;                                        %(b) residual error
            temp2_PSNRdB        =   UTIL_METRICS_compute_PSNRdB (255, temp2_error_Dx1);             %(c) comparison metric
            temp2_XDR_parPx1    =   [temp2_XDR_parPx1 ; m_best];



            %part3: should we continue or exit?
            if     (strcmp(rule_stop_decoding, 'maxP'))
                continue_decoding   =   true;
            elseif      (strcmp(rule_stop_decoding, 'RoE'))
                continue_decoding   =   RVQ_RULES_DECODE_STOPPING_RoE  (RVQ.trg_1_descr_PxN, temp2_XDR_parPx1);
            elseif  (strcmp(rule_stop_decoding, 'monPSNR'))
                continue_decoding   =   RVQ_RULES_DECODE_STOPPING_monotonic_PSNR (temp2_PSNRdB, PSNRdB_prev);
            end

            if (continue_decoding)
                descr_Px1(p)    =   m_best;                                 %1. descriptor
                recon_Dx1       =   temp2_recon_Dx1;                        %2. reconstructed signal
                error_Dx1       =   temp2_error_Dx1;                        %3. error vector
                PSNRdB          =   temp2_PSNRdB;                           %4. PSNRdB
                partialP        =   p;                                      %(e) number of stages
            else
                break;
            end


            %part4: overwrite variables that define previous state
            recon_prev_Dx1      =   recon_Dx1;
            PSNRdB_prev         =   PSNRdB;
        end
        %end: going over stages
        
        %-------------------------------
        %POST-PROCESSING
        %-------------------------------
        %save
        if (strcmp(RVQ.in_2_mode, 'trg'))
            RVQ.trg_1_descr_PxN(:,n)=   descr_Px1;                                                
            RVQ.trg_2_recon_DxN(:,n)=   recon_Dx1;                                             
            RVQ.trg_3_error_DxN(:,n)=   error_Dx1;                                             
            RVQ.trg_6_partP_Nx1(n,1)=   partialP;                                              
        elseif (strcmp(RVQ.in_2_mode, 'tst'))
            RVQ.tst_1_descr_PxN(:,n)=   descr_Px1;                                             
            RVQ.tst_2_recon_DxN(:,n)=   recon_Dx1;                                             
            RVQ.tst_3_error_DxN(:,n)=   error_Dx1;                                             
            RVQ.tst_6_partP_Nx1(n,1)=   partialP;                                              
        end

    end        
    %end looping over input data points

    if (strcmp(RVQ.in_2_mode, 'trg'))
        RVQ.trg_4_SNRdB_1x1=   UTIL_METRICS_compute_SNRdB       (DM2(:),  RVQ.trg_3_error_DxN(:));  
        RVQ.trg_5_rmse__1x1=   UTIL_METRICS_compute_rms_value   (         RVQ.trg_3_error_DxN(:));  
    elseif (strcmp(RVQ.in_2_mode, 'tst'))
        RVQ.tst_4_SNRdB_1x1=   UTIL_METRICS_compute_SNRdB       (DM2(:),  RVQ.tst_3_error_DxN(:));  
        RVQ.tst_5_rmse__1x1=   UTIL_METRICS_compute_rms_value   (         RVQ.tst_3_error_DxN(:));  
    end