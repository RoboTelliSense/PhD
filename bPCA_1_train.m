%> @file bPCA_1_train.m
%> @brief Creates PCA eigenvectors
%>
%> N                        :   number of training vectors
%> D                        :   dimensionality of training vectors
%> U_DxN                    :   eigenvectors for AA^T.  If N<D which I assume will normally be the 
%>                              case, then U is DxN, otherwise, it will be DxD
%> W_NxN                    :   eigenvectors for A^TA 
%> S                        :   eigenvalues
%> DM                       :   NxD design matrix, has training vectors, i.e. input vectors are in rows
%> DM2                      :   DxN design matrix, has training vectors, i.e. input vectors are in cols
%> DM2z                     :   zero centered, i.e., mean removed
%> bPCA stands for batch PCA (i.e. the standard method) rather than incremental PCA_1_train
%> for images, another consideration is how the input vectors themselves were generated, were the pixels concatenated row wise or column wise
%>
%> Copyright (c) Salman Aslam.  All rights reserved.
%> Date created             :   around Feb 2011  
%> Date modified            :   Aug 27, 2011

function PCA = bPCA_1_train(DM2, PCA)

%------------------------------------------
% PRE-PROCESSING
%------------------------------------------
    [D, N]                  =   size(DM2);
    
    mu_Dx1                  =   mean(DM2, 2);
    DM2z         			=   DM2  - repmat(mu_Dx1, 1, N); %repeat N columns because there are N data points and there's one data point per column

%------------------------------------------
% PROCESSING
%------------------------------------------
%compute model 
    
    
        [U, S, V]               =   svd(DM2z, 0);    %notice i do not remove the mean for SVD
                                                %svd(X,0) produces the "economy size" decomposition. 
                                                %If X is DxN with D > N, then svd computes only the 
                                                %first N columns of U and S is NxN. 
%4 part model    
    PCA.mdl_mu_Dx1              =	mu_Dx1;         %4 part model: 1. mean
    PCA.mdl_U_DxN               =	U;              %4 part model: 2. eigenvectors of AA^T
	PCA.mdl_S_NxN               =	S;              %4 part model: 3. squared eigenvalues
	PCA.mdl_V_NxN               =	V;              %4 part model: 4. eigenvectors of A^TA
                                               
%------------------------------------------
% POST-PROCESSING
%------------------------------------------
%5 part training output
    PCA.trg_descriptors_NxN     =   PCA.mdl_U_DxN' * DM2z;                                          %trg1. projection scalars
    PCA.trg_recon_DxN           =   PCA.mdl_U_DxN * PCA.trg_descriptors_NxN + repmat(mu_Dx1, 1, N); %trg2. reconstructed signal  
    PCA.trg_err_DxN             =   PCA.trg_recon_DxN - DM2;                                        %trg3. error vector
    PCA.trg_4_SNRdB               =   UTIL_METRICS_compute_SNRdB       (DM2(:), PCA.trg_err_DxN(:));  %trg4. SNRdB
    PCA.trg_5_rmse                =   UTIL_METRICS_compute_rms_value   (PCA.trg_err_DxN(:));          %trg5. rmse