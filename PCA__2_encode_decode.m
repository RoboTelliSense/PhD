%Q is how many dimensions you want to retain
%D is number of pixels, i.e. dimensions
%N is number of images

function PCA = PCA__2_encode_decode(DM2, PCA)

%--------------------------------------------
% PRE-PROCESSING
%--------------------------------------------
    [D, N]                  =   size(DM2);                  %U_DxQ is DxD if N>D, otherwise it's DxN
   
    mu_Dx1                  =   PCA.mdl_2_mu_Dx1; 
    Q                       =   PCA.mdl_1_Q__1x1;
    U_DxQ                   =   PCA.mdl_3_U__DxQ;
    
    DM2z                    =   DM2 - repmat(mu_Dx1, 1, N);  %zero centered, i.e., mean removed
%--------------------------------------------
% PROCESSING
%--------------------------------------------      
    featr_QxN               =   U_DxQ' * DM2z;                                           %1. feature vectors (projection scalars)
    recon_DxN               =   U_DxQ  * featr_QxN + repmat(mu_Dx1, 1, N);               %2. reconstructed signal  
    error_DxN               =   DM2 - recon_DxN;                                         %3. error vector
    SNRdB_Nx1               =   UTIL_METRICS_compute_SNRdB       (DM2(:), error_DxN(:)); %4. SNRdB
    rmse__Nx1               =   UTIL_METRICS_compute_rms         (        error_DxN(:)); %5. rmse
    
%--------------------------------------------
% POST-PROCESSING
%--------------------------------------------      
    if (strcmp(PCA.in_2__data, 'trg'))
        PCA.trg_1_featr_QxN =   featr_QxN;                                                          %1. feature vectors (projection scalars)
        PCA.trg_2_recon_DxN =   recon_DxN;                                                          %2. reconstructed signal  
        PCA.trg_3_error_DxN =   error_DxN;                                                          %3. error vector
        PCA.trg_4_SNRdB_1x1 =   UTIL_METRICS_compute_SNRdB       (DM2(:), PCA.trg_3_error_DxN(:));  %4. SNRdB
        PCA.trg_5_rmse__1x1 =   UTIL_METRICS_compute_rms         (        PCA.trg_3_error_DxN(:));  %5. rmse    
    elseif (strcmp(PCA.in_2__data, 'tst'))  
        PCA.tst_1_featr_QxN =   featr_QxN;                                                          %1. feature vectors (projection scalars)
        PCA.tst_2_recon_DxN =   recon_DxN;                                                          %2. reconstructed signal  
        PCA.tst_3_error_DxN =   error_DxN;                                                          %3. error vector
        PCA.tst_4_SNRdB_1x1 =   UTIL_METRICS_compute_SNRdB       (DM2(:), PCA.tst_3_error_DxN(:));  %4. SNRdB
        PCA.tst_5_rmse__1x1 =   UTIL_METRICS_compute_rms         (        PCA.tst_3_error_DxN(:));  %5. rmse    
    end
    