%Neig is how many dimensions you want to retain
%D is number of pixels, i.e. dimensions
%N is number of images

function BPCA = bPCA_3_test(tst_vec_Dx1, BPCA)

        U_DxD                       =   BPCA.trgout_U_DxD;
        M_Dx1                       =   BPCA.trgout_M_Dx1;
        Neig                        =   BPCA.Neig_1x1;
        
        [D, N]                      =   size(U_DxD); %U_DxD is DxD if N>D, otherwise it's DxN
        tst_vec_Dx1_mr              =   tst_vec_Dx1 - M_Dx1;  %mean removed

    %scalar projection on each dimension
        proj_Dx1                    =   U_DxD' * tst_vec_Dx1_mr; %the PCA descriptor is a sequence of eigenvalues
              
    %image on each dimension
        for i=1:min(N, Neig)
            recon_mr(:,i)           =   proj_Dx1(i) * U_DxD(:,i);
        end
        
    %output image and error
        recon_Dx1                   =   M_Dx1 + sum(recon_mr,2);
        err_Dx1                     =   tst_vec_Dx1 - recon_Dx1;
        
    %statistics
        snr_dB                      =   UTIL_METRICS_compute_SNRdB(tst_vec_Dx1, err_Dx1);  %for PSNR, you only give error signal
        rmse                        =   UTIL_METRICS_compute_rms_value(err_Dx1);
        
    %pass out
        BPCA.tst_recon_Dx1=   recon_Dx1;
        BPCA.tst_err_Dx1  =   err_Dx1;
        BPCA.tst_SNRdB  =   snr_dB;
        BPCA.tst_rmse =   rmse;
        BPCA.tst_XDR_Px1 = [];
        
        

%     %plot
%     if (bVisualize)
%         figure;                    
%         colormap(gray);
%         axis off;
%         set(gcf, 'Name', 'Reconstructions');
%         idx = 1;
%         imsize=size(recon);
%         for i = 1:Neig
%            TEMP1 = reshape( recon(:,i), size(mean_signal) );
%            tightsubplot( 13, idx, TEMP1 );
%            idx = idx + 1;
%         end;    
%     end