clear;
clc;
%close all;

%---------------------------------------
%PRE-PROCESSING
%---------------------------------------
    %load incremental_svd  %a snapshot of data from TRK_subspace before
    %it's entered into sklm

    D                       =   1000;
    N1                      =   30;
    N2                      =   40;
    Nt                      =   N1 + N2;
    A_DxN1                  =   [1 0;
                                 0 1;
                                 0 0];

    B_DxN2                  =   [0 ; 
                                 0 ; 
                                 1];
 
    A_DxN1                  =   250*randn(D,N1);
    B_DxN2                  =   350*randn(D,N2);

    [U_DxN1,S_N1xN1,W_N1xN1]=   svd   (A_DxN1, 0); 
    
%---------------------------------------
%PROCESSING
%---------------------------------------
    [U_DxNt_sklm, S_Ntx1_sklm, muAB_Dx1_sklm, temp_n] ...
                            =   sklm  (B_DxN2, U_DxN1, diag(S_N1xN1), mean(A_DxN1,2), 1, 1);
 
%---------------------------------------
%POST-PROCESSING
%---------------------------------------    
    [U_DxNt S_NtxNt W_NtxNt]=   svd([A_DxN1 B_DxN2],0);
    err_DxNt                =   U_DxNt_sklm - U_DxNt;
    rmse                    =   UTIL_METRICS_compute_rms_value(err_DxNt(:))
                                surf(err_DxNt)
                                %whos;