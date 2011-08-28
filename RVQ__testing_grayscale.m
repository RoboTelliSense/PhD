%% Reconstruct a test vector, x_Dx1, using an RVQ codebook.
%
% There are 3 rules to stop decoding:
% (a) 'full_path':              this gives same functionality as gen.exe -l
% (b) 'monotonic_PSNR':         this is what I used in the first draft of my thesis
% (c) 'realm_of_experience':    this is used by Explorer
%
% Also refer to RVQ__testing_grayscale_old.m which produces the same output as 
% this function, but is a little less intuitive.  Moreover, that function
% only has one decoding rule, 'monotonic_PSNR', whereas this function adds
% 2 more rules, 'realm_of_experience' and 'full_stage'.
%
% This version is for grayscale images.  In RVQ, I make grayscale images 3
% channel by replicating the grayscale channel to all 3 channels.  RVQ then
% processes the 3 channel image as if it were RGB.  However, the
% codevectors for the red, green and blue channels are exactly the same.
% This is why I use mdl_CBr_DxMP, the red channel of the codebook.  I could
% just as well have used mdl_CBg_DxMP or mdl_CBb_DxMP since they are all exactly the same
% as mdl_CBr_DxMP.  I go on to call this single channel codebook CB_DxMP, since it
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

function RVQ = RVQ__testing_grayscale(x_Dx1, RVQ)

%-------------------------------
%INITIALIZATION
%-------------------------------
    CB_DxMP                 =   RVQ.mdl_CBr_DxMP;   %1 channel codebook, get it from the red, green or blue channel
    P                       =   RVQ.P;      %actual number of stages in the codebook
    M                       =   RVQ.M;      %number of codevectors/stage
    sw                      =   RVQ.sw;     %snippet width
    sh                      =   RVQ.sh;     %snippet height
    D                       =   sw*sh;       %dimension of data
    partialP                =   0;
%-------------------------------
%PRE-PROCESSING
%-------------------------------    
    xhat_prev_Dx1           =   zeros(D,1);             %state variable
    PSNRdB_prev             =   0;                      %state variable
    XDR_Px1                 =   (P+1) * ones(P,1);      %i initialize with P+1, the code for early termination
    temp2_XDR_parPx1        =   [];                     %contains a partial XDR_Px1, i.e., all indeces up to p-th stage

%-------------------------------
%PROCESSING
%-------------------------------    
%go over all stages
    for p=1:P
        
       
        %part 1: pick best codevector at p-th stage (note that all temporary variables here start with temp1 since this is part 1)
        err_norm_min        =   1E15;
        for m=1:M                         
            CV_Dx1          =	RVQ_FILES_getCodevectorFromCodebook(m, p, M, CB_DxMP);      %get codevector 
            temp1_xhat_Dx1  =   xhat_prev_Dx1 + CV_Dx1;                                     %(a) reconstruction
            temp1_err_Dx1   =   x_Dx1 - temp1_xhat_Dx1;                                     %(b) residual error
            temp1_err_norm  =   norm(  temp1_err_Dx1, 2  );                                 %(c) comparison metric 

            if (temp1_err_norm < err_norm_min)
                err_norm_min=   temp1_err_norm;
                m_best      =   m;                                                          %save best codevector index
            end
        end
        CV_Dx1_best         =   RVQ_FILES_getCodevectorFromCodebook(m_best, p, M, CB_DxMP); %save best codevector for p-th stage

        
   
        %part 2: compute metrics so that we know if we should continue or not
        temp2_xhat_Dx1      =   xhat_prev_Dx1 + CV_Dx1_best;                                %(a) reconstruction
        temp2_err_Dx1       =   x_Dx1 - temp2_xhat_Dx1;                                     %(b) residual error
        temp2_PSNRdB        =   UTIL_METRICS_compute_PSNRdB (255, temp2_err_Dx1);           %(c) comparison metric
        temp2_XDR_parPx1    =   [temp2_XDR_parPx1 ; m_best];
        
        
        
        %part3: should we continue or exit?
        if      (strcmp(RVQ.rule_stop_decoding, 'realm_of_experience'))
            continue_decoding   =   RVQ_RULES_DECODE_STOPPING_realm_of_experience  (RVQ.mdl_XDRs_PxN, temp2_XDR_parPx1);
        elseif  (strcmp(RVQ.rule_stop_decoding, 'monotonic_PSNR'))
            continue_decoding   =   RVQ_RULES_DECODE_STOPPING_monotonic_PSNR       (temp2_PSNRdB, PSNRdB_prev);
        elseif  (strcmp(RVQ.rule_stop_decoding, 'full_stage'))
            continue_decoding   =   true;
        end
        
        if (continue_decoding)
            xhat_Dx1        =   temp2_xhat_Dx1;                                             %(a) reconstruction
            err_Dx1         =   temp2_err_Dx1;                                              %(b) residual error
            PSNRdB          =   temp2_PSNRdB;                                               %(c) comparison metric
            XDR_Px1(p)      =   m_best;                                                     %(d) RVQ path
            partialP        =   p;                                                          %(e) number of stages
        else
            break;
        end
        
        
        %part4: overwrite variables that define previous state
        xhat_prev_Dx1       =   xhat_Dx1;
        PSNRdB_prev         =   PSNRdB;
    end
    %end: going over stages
        
        
  
%-------------------------------
%POST-PROCESSING
%-------------------------------
    RVQ.tst_recon_Dx1       =   xhat_Dx1;                           %tst1. 
    RVQ.tst_err_Dx1        =   err_Dx1;                             %tst2. error vector
    

    RVQ.tst_partialP       =   partialP;                           %(d) metrics            
    RVQ.tst_SNRdB          =   UTIL_METRICS_compute_SNRdB       (x_Dx1,  err_Dx1);  
    RVQ.tst_rmse           =   UTIL_METRICS_compute_rms_value   (        err_Dx1);
    RVQ.tst_PSNRdB         =   UTIL_METRICS_compute_PSNRdB      (255,    err_Dx1);
    
    RVQ.tst_XDR_Px1        =   XDR_Px1;                            %(c) save RVQ path