%Nt = N + M;
%C  = [A B];

%---------------------------------------
%PRE-PROCESSING
%---------------------------------------
    clear;
    clc;
    %close all;

    %load incremental_svd  %a snapshot of data from TRK_subspace before
    %it's entered into sklm

    %dataset1
%     D                       =   1000;
%     N                       =   40;
%     M                       =   30; 
%     
%     A_DxN                   =   250*randn(D,N);
%     B_DxM                   =   350*randn(D,M);
    
    %dataset2
    A_DxN                 =   [1 0;
                               0 1;
                               0 0];
    [D,N]                 =   size(A_DxN);

%     B_DxM                 =   [2 0 0 ; 
%                                0 4 0 ; 
%                                0 0 1];
    B_DxM                 =   [0 ; 
                               0 ; 
                               1];                           
    [D,M]                 =    size(B_DxM); 


    [U_DxN,S_NxN,W_NxN]     =   svd   (A_DxN, 0); 
    
    
%---------------------------------------
%PROCESSING
%---------------------------------------
    [U_DxNt_sklm, S_Ntx1_sklm, muC_Dx1_sklm, temp_n_sklm] ...
                            =   sklm    (B_DxM, U_DxN, diag(S_NxN), mean(A_DxN,2), N, 1);

     [U_DxNt_sklm2, S_Ntx1_sklm2, muC_Dx1_sklm2, temp_n_sklm2] ...
                             =   sklm2  (B_DxM, U_DxN, diag(S_NxN), mean(A_DxN,2), N, 1);                        
%---------------------------------------
%POST-PROCESSING
%---------------------------------------    
%reference    
    [U_DxNt S_NtxNt W_NtxNt]=   svd([A_DxN B_DxM],0);
    
    err_DxNt                =   U_DxNt_sklm - U_DxNt;
    rmse                    =   UTIL_METRICS_compute_rms_value(err_DxNt(:))
                                surf(err_DxNt)
                                %whos;
                                
    err1                    =   U_DxNt_sklm - U_DxNt_sklm2;
    norm(err1(:))

    