% Copyright (c) Salman Aslam.  All rights reserved.
% Date created              :   Sep 21, 2011
% Date modified             :   Sep 21, 2011


function MEAN = MEAN_2_test(DM2, MEAN)

%--------------------------------------------
% 1. PRE-PROCESSING
%-------------------------------------------- 
    [D, N]                  =   size(DM2);                      
    DM2z                    =   DM2 - repmat(mu_Dx1, 1, N);     %zero centered, i.e., mean removed
    
%--------------------------------------------
% 2. PROCESSING
%--------------------------------------------     
    recon_DxN               =   repmat(mu_Dx1, 1, N)    
    error_DxN               =   DM2z;
    
    
%--------------------------------------------
% 3. POST-PROCESSING
%--------------------------------------------     

        MEAN.trg_1_featr_PxN=   [];                                                                 %1. feature vectors (projection scalars)
        MEAN.trg_2_recon_DxN=   recon_DxN;                                                          %2. reconstructed signal  
        MEAN.trg_3_error_DxN=   error_DxN;                                                          %3. error vector
        MEAN.trg_4_SNRdB_1x1=   UTIL_METRICS_compute_SNRdB      (DM2(:), MEAN.trg_3_error_DxN(:));  %4. SNRdB
        MEAN.trg_5_rmse__1x1=   UTIL_METRICS_compute_rms        (        MEAN.trg_3_error_DxN(:));  %5. rmse    

        MEAN.tst_1_featr_PxN=   [];                                                                 %1. feature vectors (projection scalars)
        MEAN.tst_2_recon_DxN=   recon_DxN;                                                          %2. reconstructed signal  
        MEAN.tst_3_error_DxN=   error_DxN;                                                          %3. error vector
        MEAN.tst_4_SNRdB_1x1=   UTIL_METRICS_compute_SNRdB      (DM2(:), MEAN.tst_3_error_DxN(:));  %4. SNRdB
        MEAN.tst_5_rmse__1x1=   UTIL_METRICS_compute_rms        (        MEAN.tst_3_error_DxN(:));  %5. rmse    