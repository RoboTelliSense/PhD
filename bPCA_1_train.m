%U and W have eigenvectors, S has eigenvalues
%DM2 is for PCA, otherwise my convention is NxD
%N is number of training data points
%D is dimensionality of data
%_mr means mean removed
%bPCA stands for batch PCA (i.e. the standard method) rather than incremental PCA_1_train
%DM1 is design matrix, NxD, i.e. input vectors are in rows
%DM2 is design matrix, DxN, i.e. input vectors are in columns
%for images, another consideration is how the input vectors themselves were generated, were the pixels concatenated row wise or column wise
function sBPCA = bPCA_1_train(DM2, sBPCA)

    [D, N]                      =   size                (DM2);
    
    meanSignal                  =   mean                (DM2, 2);
    DM2_mr         				=   DM2  - repmat(meanSignal, 1, N); %repeat N columns because there are N data points and there's one data point per column
    
    [U, S, V]                   =   svd                 (DM2_mr, 0);  %svd(X,0) produces the "economy size" decomposition. If X is m-by-n with m > n, then svd computes only the first n columns of U and S is n-by-n.      

    sBPCA.trgout_U_DxD  	=	U;  %normally DxD
	sBPCA.trgout_S_DxD      =	S;	%DxD
	sBPCA.trgout_V_NxN  	=	V;	%normally NxN
	sBPCA.trgout_M_Dx1      =	meanSignal;
    
    sBPCA                   =   UTIL_METRICS_compute_training_error_RVQ_style(DM2, sBPCA, 2);   %2 is the algo code
    
    
	
	
%if you have a design matrix where inputs are along rows, i.e. DM instead of DM2, you can use this	
% function [U, S, V, meanSignal] = PCA_1_train(DM)
% 
%     [N, D]                         	=   size(DM);
%     
%     meanSignal                       	=   mean(DM);
%     DM_mr                				=   DM  - repmat(meanSignal, N,1);
%     DM_mr_t     						=   DM_mr';  
%     
%     [U, S, V] = svd(DM_mr_t, 0);       