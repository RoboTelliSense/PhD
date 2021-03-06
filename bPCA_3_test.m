%P is how many dimensions you want to retain
%D is number of pixels, i.e. dimensions
%N is number of images

function PCA = bPCA_3_test(DM2, PCA)

%--------------------------------------------
% PRE-PROCESSING
%--------------------------------------------
    [D, N]                  =   size(DM2);                  %U_DxP is DxD if N>D, otherwise it's DxN
   
    mu_Dx1                  =   PCA.mdl_2_mu_Dx1; 
    P                       =   PCA.mdl_1_P__1x1;
    U_DxP                   =   PCA.mdl_3_U__DxP;
    
    DM2z                    =   DM2 - repmat(mu_Dx1, 1, N);  %zero centered, i.e., mean removed
%--------------------------------------------
% PROCESSING
%--------------------------------------------      
    descr_PxN               =   U_DxP' * DM2z;                                           %1. descriptors (projection scalars)
    recon_DxN               =   U_DxP  * descr_PxN + repmat(mu_Dx1, 1, N);               %2. reconstructed signal  
    error_DxN               =   DM2 - recon_DxN;                                         %3. error vector
    SNRdB_Nx1               =   UTIL_METRICS_compute_SNRdB       (DM2(:), error_DxN(:)); %4. SNRdB
    rmse__Nx1               =   UTIL_METRICS_compute_rms_value   (        error_DxN(:)); %5. rmse
%--------------------------------------------
% POST-PROCESSING
%--------------------------------------------      
    if (strcmp(PCA.in_2_mode, 'trg'))
        PCA.trg_1_descr_PxN =   descr_PxN;                                                          %1. descriptors (projection scalars)
        PCA.trg_2_recon_DxN =   recon_DxN;                                                          %2. reconstructed signal  
        PCA.trg_3_error_DxN =   error_DxN;                                                          %3. error vector
        PCA.trg_4_SNRdB_1x1 =   UTIL_METRICS_compute_SNRdB       (DM2(:), PCA.trg_3_error_DxN(:));  %4. SNRdB
        PCA.trg_5_rmse__1x1 =   UTIL_METRICS_compute_rms_value   (        PCA.trg_3_error_DxN(:));  %5. rmse    
    elseif (strcmp(PCA.in_2_mode, 'tst'))  
        PCA.tst_1_descr_PxN =   descr_PxN;                                                          %1. descriptors (projection scalars)
        PCA.tst_2_recon_DxN =   recon_DxN;                                                          %2. reconstructed signal  
        PCA.tst_3_error_DxN =   error_DxN;                                                          %3. error vector
        PCA.tst_4_SNRdB_1x1 =   UTIL_METRICS_compute_SNRdB       (DM2(:), PCA.tst_3_error_DxN(:));  %4. SNRdB
        PCA.tst_5_rmse__1x1 =   UTIL_METRICS_compute_rms_value   (        PCA.tst_3_error_DxN(:));  %5. rmse    
    end
    