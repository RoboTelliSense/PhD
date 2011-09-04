%> @file demo_iPCA.m 
%> @brief This file demos the use of incremental SVD (Sequential Karhunen-Loeve Transform)
%>
%> A is initial data matrix.  Its SVD is computed.
%> After this B data matrix arrives and we would like to compute the SVD of
%> C=[A B].  However, we would like to use incremental SVD so that we can use our existing computation
%> of A's SVD.
%>
%> Copyright (c) Salman Aslam.  All rights reserved.
%> Date created:  Aug 12, 2011
%> Date modified: Aug 15, 201

%---------------------------------------
%PRE-PROCESSIM1G
%---------------------------------------    
    clear;
    clc;
    close all;
    format compact;

    datasetCode             =   1;
    
    if (datasetCode==1) 
        D                   =   1089;
        M1                  =   10;
        M2                  =   5; 
        A_DxM1              =   randn(D,M1);
        B_DxM2              =   randn(D,M2);
    elseif (datasetCode==2)   
        A_DxM1              =   [1 0;
                                 0 1;
                                 0 0];
        
        B_DxM2              =   [0 0 ; 
                                 0 1; 
                                 1 0];   
        [D,M1]              =   size(A_DxM1);
        [D,M2]              =   size(B_DxM2); 
    elseif (datasetCode==3)   %must have incremental_svd.mat in current directory to use this option
        load incremental_svd  %a snapshot of data from TRK_subspace.m before it's entered into sklm
    elseif (datasetCode==4)
%         A_DxM1              =   [1 4 5 -2; ...
%                                  3 2 4 -2];
%         B_DxM2              =   [-2 -6; ...
%                                  -3 -4];
%         [D,M1]              =   size(A_DxM1);
%         [D,M2]              =   size(B_DxM2); 
                             
    end
    DM2                     =   [A_DxM1 B_DxM2];    %this is C_DxN
   
%reference SVD    
    PCA_ref.mode            =   'batch';
    PCA_ref                 =   bPCA_1_train(DM2, PCA_ref);        %reference SVD
    
%---------------------------------------
%PROCESSING
%---------------------------------------
%prior SVD (for A)
    A_pca.mode              =   'batch';
    A_pca                   =   bPCA_1_train(A_DxM1, A_pca);        %reference SVD
    
    Ua_DxM1                 =   A_pca.mdl_3_U__DxP;
    Sa_M1xM1                =   A_pca.mdl_4_S__PxP;
    muA_Dx1                 =   A_pca.mdl_2_mu_Dx1;
    
%incremental SVD (including B)     
    [Usklm_DxN, Ssklm_Nx1, muCsklm_Dx1, temp_n] ...
                            =   sklm    (B_DxM2, Ua_DxM1, diag(Sa_M1xM1),muA_Dx1, M1, 1);

%     PCA.inc_muA_Dx1         =   mean(A_DxM1,2);
%     Ua_DxM1                 =   PCA.inc_Ua_DxM1;    %old basis
%     Sa_Nx1                  =   PCA.inc_Sa_Nx1;     %old eigenvalues
%     B_DxM2                  =   PCA.inc_B_DxM2;     %new data       
%     ff                      =   PCA.ff;             %forgetting factor
%     Q                       =   PCA.Q;              %number of eigenvectors to keep
%     
%     PCA                     =   sklm2  (B_DxM2, Ua_DxM1, diag(Sa_M1xM1), mean(A_DxM1,2), M1, 1);                        
%---------------------------------------
%POST-PROCESSIM1G
%---------------------------------------    
%reference    
    
    
     err1_DxN               =   PCA_ref.mdl_3_U__DxP  - Usklm_DxN; %sklm is original code by David Ross
     norm(err1_DxN(:))
%     err2_DxN               =   U_DxN2 - U_DxN; %my code with cosmetic changes to make more readable
%     rmse1                   =   UTIL_METRICS_compute_rms_value(err1_DxN(:))
%     rmse2                   =   UTIL_METRICS_compute_rms_value(err2_DxN(:))
                                 surf(err1_DxN)
%                                 
%     err1                    =   U_DxN - U_DxN2;
%     
%     
%     h                       =   gcf;
%     UTIL_FILE_save2pdf('out.pdf', h, 300);

    