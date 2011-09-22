%> @file PCA__1_train.m
%> @brief Creates PCA eigenvectors
%>
%> assumption
%> ----------
%> D > N > P
%>
%> description
%> -----------
%> N                        :   number of training vectors
%> D                        :   dimensionality of training vectors
%> P                        :   number of eigenvectors to keep
%>
%> U_DxN                    :   eigenvectors for AA^T.  If N<D which I assume will normally be the 
%>                              case, then U is DxN, otherwise, it will be DxD
%> S_NxN                    :   eigenvalues
%> V_NxN                    :   eigenvectors for A^TA 
%> DM                       :   NxD design matrix, has training vectors, i.e. input vectors are in rows
%> DM2                      :   DxN design matrix, has training vectors, i.e. input vectors are in cols
%> DM2z                     :   zero centered, i.e., mean removed
%> bPCA stands for batch PCA (i.e. the standard method) rather than incremental PCA_1_train
%> for images, another consideration is how the input vectors themselves were generated, were the pixels concatenated row wise or column wise
%>
%> Copyright (c) Salman Aslam.  All rights reserved.
%> Date created             :   around Feb 2011  
%> Date modified            :   Aug 27, 2011

function PCA = PCA__1_train(DM2, PCA)

%------------------------------------------
% PRE-PROCESSING
%------------------------------------------
    [D, N]                  =   size(DM2);
    
    mu_Dx1                  =   mean(DM2, 2);
    P                       =   PCA.mdl_1_P__1x1;
    DM2z         			=   DM2  - repmat(mu_Dx1, 1, N); %repeat N columns because there are N data points and there's one data point per column

%------------------------------------------
% PROCESSING
%------------------------------------------
%compute model 
    
    
        [U, S, V]           =   svd(DM2z, 0);       %notice, zero centered (i.e., mean removed)    
                                                    %svd(X,0) produces the "economy size" decomposition. 
                                                    %If X is DxN with D > N, then svd computes only the 
                                                    %first N columns of U and S is NxN. 
        keep                =   1:min(min(N, P),D); %keep the min of N, P, D
        
                                               
%------------------------------------------
% POST-PROCESSING
%------------------------------------------
%save model    
    PCA.mdl_2_mu_Dx1        =	mu_Dx1;                     %1. mean
    PCA.mdl_3_U__DxP        =	U(:,keep);                  %2. eigenvectors of AA^T
	PCA.mdl_4_S__PxP        =	S(keep,keep);               %4. squared eigenvalues
	PCA.mdl_5_V__PxP        =	V(keep,keep);               %5. eigenvectors of A^TA
    
%test training examples   
    PCA.in_2__mode           =   'trg';
    PCA                     =   PCA__2_test(DM2, PCA);    
    PCA.in_2__mode           =   'tst';