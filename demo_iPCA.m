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
%PRE-PROCESSING
%---------------------------------------    
    clear;
    clc;
    close all;
    format compact;

%data    
    ff                      =   1;      %forgetting factor
    datasetCode             =   1;
    
    if (datasetCode==1) 
        D                   =   1089;
        M1                  =   10;
        M2                  =   10; 
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
        A_DxM1              =   [1 4 5 -2; ...
                                 3 2 4 -2];
        B_DxM2              =   [-2 -6; ...
                                 -3 -4];
        [D,M1]              =   size(A_DxM1);
        [D,M2]              =   size(B_DxM2); 
    elseif (datasetCode==5)
        A_DxM1              =   [1  3; ...
                                 3  6;
                                 4  1;];
        B_DxM2              =   [6  8; ...
                                 11 15; ...
                                 3  2];
        [D,M1]              =   size(A_DxM1);
        [D,M2]              =   size(B_DxM2); 
                             
    end    
    DM2                     =   [A_DxM1 B_DxM2];    %this is C_DxN
   
%batch PCA (reference)
    BPCA_C.mdl_1_Q__1x1     =   M1+M2;
    BPCA_C                  =   PCA__1_learn(DM2, BPCA_C);        %reference SVD
    
%---------------------------------------
%PROCESSING
%---------------------------------------
%step 1: batch SVD for A
    BPCA_A.mdl_1_Q__1x1     =   M1;
    BPCA_A                  =   PCA__1_learn(A_DxM1, BPCA_A);        %reference SVD
    
    muA_Dx1                 =   BPCA_A.mdl_2_mu_Dx1;
    Ua_DxM1                 =   BPCA_A.mdl_3_U__DxP;
    Sa_M1xM1                =   BPCA_A.mdl_4_L__PxP;
    
    
%step 2: incremental SVD for C=[A B]
    [Usklm_DxN, Ssklm_Nx1, muCsklm_Dx1, temp_n] ...
                            =   sklm    (B_DxM2, Ua_DxM1, diag(Sa_M1xM1),muA_Dx1, M1, ff);

%recon    
    IPCA_C                  =   sklm2  (BPCA_A, B_DxM2, ff);                        
%---------------------------------------
%POST-PROCESSIM1G
%---------------------------------------    
%reference    
    
    
     %err1_DxN               =   BPCA_C.mdl_3_U__DxP  - Usklm_DxN; %sklm is original code by David Ross
     %norm(err1_DxN(:))
%     err2_DxN               =   U_DxN2 - U_DxN; %my code with cosmetic changes to make more readable
%     rmse1                   =   UTIL_METRICS_compute_rms(err1_DxN(:))
%     rmse2                   =   UTIL_METRICS_compute_rms(err2_DxN(:))
%                                 surf(err1_DxN)
%                                 
%     err1                    =   U_DxN - U_DxN2;
%     
%     
%     h                       =   gcf;
%     UTIL_FILE_save2pdf('out.pdf', h, 300);

    