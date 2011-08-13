%---------------------------------------
%PRE-PROCESSING
%---------------------------------------
    clear;
    clc;
    %close all;

    %load incremental_svd  %a snapshot of data from TRK_subspace before
    %it's entered into sklm

    %dataset1
    D                       =   1000;
    N1                      =   30;
    N2                      =   40;
    Nt                      =   N1 + N2;
    A_DxN1                  =   250*randn(D,N1);
    B_DxN2                  =   350*randn(D,N2);
    
    %dataset2
%     A_DxN1                  =   [1 0;
%                                  0 1;
%                                  0 0];
%     [D,N1]                =   size(A_DxN1);
% 
%     B_DxN2                  =   [2 0 0 ; 
%                                  0 4 0 ; 
%                                  0 0 1];
%     [D,N2]                =   size(B_DxN2); 


    [U_DxN1,S_N1xN1,W_N1xN1]=   svd   (A_DxN1, 0); 
    
    
%---------------------------------------
%PROCESSING
%---------------------------------------
    [U_DxNt_sklm, S_Ntx1_sklm, muAB_Dx1_sklm, temp_n_sklm] ...
                            =   sklm  (B_DxN2, U_DxN1, diag(S_N1xN1), mean(A_DxN1,2), N1, 1);

     [U_DxNt_sklm2, S_Ntx1_sklm2, muAB_Dx1_sklm2, temp_n_sklm2] ...
                             =   sklm2  (B_DxN2, U_DxN1, diag(S_N1xN1), mean(A_DxN1,2), N1, 1);                        
%---------------------------------------
%POST-PROCESSING
%---------------------------------------    
%reference    
    [U_DxNt S_NtxNt W_NtxNt]=   svd([A_DxN1 B_DxN2],0);
    
    err_DxNt                =   U_DxNt_sklm - U_DxNt;
    rmse                    =   UTIL_METRICS_compute_rms_value(err_DxNt(:));
                                surf(err_DxNt)
                                %whos;
                                
    err                     =   U_DxNt_sklm - U_DxNt_sklm2;
    norm(err(:))