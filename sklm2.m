%> @file sklm2.m 
%> @brief This file computes incremental SVD (Sequential Karhunen-Loeve Transform)
%>
%> muC_Dx1 is updated trivially: (newM*muA_Dx1 + M2*muB_Dx1)/(M2+newM)
%>
%> notation
%> --------
%> wmd                      :   weighted mean diff
%>
%> old data
%> --------
%> A_DxM1                   :   old data matrix
%> Ua_DxM1                  :   old basis
%> Sa_Nx1 (N,1)             :   old singular values
%> muA_Dx1 (D,1)            :   old mean
%>
%> new data
%> --------
%> B_DxM2                   :   new data matrix
%>
%> combined data
%> -------------
%> C_DxN                    :   [A_DxM1   B_DxM2];
%> N                        :   M1 + M2;
%> 
%> parameters
%> -------------
%> ff                       :   forgetting factor (def=1.0)
%> Q                        :   maximeanm number of basis vectors to retain
%>
%> output
%> ------
%> Utilde_DxN (D,N)         :   new basis
%> Stilde_Nx1 (N,1)         :   new singular values (notice it's not a matrix)
%> muC_Dx1 (D,1)            :   new mean
%>
%> known issues
%> ------------ 
%> returns error if M2>=D
%>
%> based on
%> --------
%> A. Levy & M2. Lindenbaum 
%> "Sequential Karhunen-Loeve Basis Extraction and its Application to Image", 
%> IEEE Trans. on Image Processing Vol. 9, No. 8, August 2000.
%>
%> All changes by Salman Aslam are cosmetic, name changes, etc,
%> functionality intact.
%>
%> Copyright (c) 2005 Jongwoo Lim and David Ross.  All rights reserved.  (Changed with permission by Salman Aslam) 
%> Date created:  March 19, 2011
%> Date modified: Aug 13, 201


function PCA = sklm2(PCA)

%-----------------------------------------------
%PRE-PROCESSING
%----------------------------------------------
    muA_Dx1                 =   PCA.inc_muA_Dx1;    %old data
    Ua_DxM1                 =   PCA.inc_Ua_DxM1;    %old basis
    Sa_Nx1                  =   PCA.inc_Sa_Nx1;     %old eigenvalues
    B_DxM2                  =   PCA.inc_B_DxM2;     %new data       
    ff                      =   PCA.ff;             %forgetting factor
    Q                       =   PCA.Q;              %number of eigenvectors to keep
    
    [D,M2]                  =   size(B_DxM2);

%-----------------------------------------------
%PROCESSING
%-----------------------------------------------
            
    %step 1. compute mean of C_DxN=[A B]
    muB_Dx1                 =   mean(B_DxM2,2);                             %new data
    newM                    =   ff*M2;
    muC_Dx1                 =  (newM*muA_Dx1 + M2*muB_Dx1)/(M2+newM);       %combined data

    %step 2. augment mean removed B with wmd (weighted mean difference)
    Bz_DxM2                 =   B_DxM2 - repmat(muB_Dx1,[1,M2]);            %z: centered around zero, i.e. mean removed
    extra_col_Dx1           =   sqrt(M2*M2/(M2+M2))*(muA_Dx1 - muB_Dx1);    %extra term is weighted mean difference between means of A and B
    B_hat_DxMp1             =   [Bz_DxM2      extra_col_Dx1];     

    M2                      =   M2+newM;
    Stilde_Nx1              =   diag(Sa_Nx1);
    [Bspan_DxNpMp1_old,R_old,E_old]=   qr([ ff*Ua_DxM1*Stilde_Nx1, B_hat_DxMp1 ], 0); %> old way

    %step 3.
    Bproj_NxMp1             =   Ua_DxM1'*B_hat_DxMp1;            %> projections on U
    Bin_DxMp1               =   Ua_DxM1*Bproj_NxMp1;
    Bout_DxMp1              =   B_hat_DxMp1 - Bin_DxMp1;
    [Btilde_DxMp1, dummy]   =   qr(Bout_DxMp1, 0);
    Bspan_DxNpMp1           =   [Ua_DxM1 Btilde_DxMp1];                       %spans A (old) and B (new), NpMp1 = N+M2+1
    R                       =   [ff*diag(Sa_Nx1)                               Bproj_NxMp1; ...
                                zeros([size(B_hat_DxMp1,2) length(Sa_Nx1)])   Btilde_DxMp1'*Bout_DxMp1];

    %step 4.
    [Utilde_DxN,Stilde_Nx1,Vtilde]  ...
                            =   svd(R, 0);

    %step 5.
    Stilde_Nx1              =   diag(Stilde_Nx1);
    if nargin < 7
        cutoff              =   sum(Stilde_Nx1.^2) * 1e-6;
        keep                =   find(Stilde_Nx1.^2 >= cutoff);
    else
        keep                =   1:min(Q,length(Stilde_Nx1));
    end
    Stilde_Nx1              =   Stilde_Nx1(keep);
    Utilde_DxN              =   Bspan_DxNpMp1 * Utilde_DxN(:, keep);

%-----------------------------------------------
%POST-PROCESSING
%-----------------------------------------------
    PCA.Utilde_DxN          =   Utilde_DxN;
    PCA.Stilde_Nx1          =   Stilde_Nx1;
    PCA.muC_Dx1             =   muC_Dx1;
