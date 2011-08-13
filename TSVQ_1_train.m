%% This file compares PCA, RVQ and TSVQ by generating its own simple data.
%
% DM: matrix with one observation (input vector) per row
% DM2: matrix one observation (input vector) per col
% CB_DxKt has non terminal as well as terminal codevectors, i.e. the whole tree
% 
% M     :   number of non-terminal codevectors
% P     :   number of stages (levels)
% Ks    :   number of stage (non-terminal) codevectors
%           In general, Ks = (M^P-1)/(M-1).
%           For binary TSVQ, M=2, so Ks = M^P-1 = K-1
% K     :   number of        terminal codevectors, K=M^P       
% Kt    :   total number of codevectors, terminal and non-terminal,
%           For binary TSVQ, this is K+(K-1)=2K-1
% 
% for example, if M=2 (binary TSVQ) and P=3, we have K=2^3=8 terminal
% codevectors, and K-1=2^3-1=7 non-terminal codevectors
%
% the idea behind TSVQ is relatively simple, however, in implementation, making a tree is difficult in matlab.  
% so, the question is: what kind of data structure am I using in Matlab?  
% The answer is that I have a cell array, CB_DxKt which has M + Ntc entries, and the numbers
% below show how the non-terminal codevectors (ntc's) and terminal
% codevectors (tc's) can be accessed in CB_DxKt.  so CB_DxKt{i} is the top level
% non-terminal codevector and is the mean of all the data.  to access the
% codebook, i.e. the terminal codevectors, access CB_DxKt{M+1} till the last entriy in CB_DxKt, i.e. CB_DxKt{M + K}
%
% level t=0 (non-terminal level)               1        (here the codevector is the mean of all data)
%                                       /           \
% level t=1 (non-terminal level)       2              3  
%                                    /   \          /   \
% level t=2 (non-terminal level)   4      5       6      7   %so there are (2^3)-1=7 ntc's
%                                 / \    / \     / \    / \
% level t=P=3 (terminal level)   8  9  10  11  12  13  14  15   %2^3=8 tc's 
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : February 24, 2011
% Date last modified : July 19, 2011.
%%

function sTSVQ = TSVQ_1_train(DM2, sTSVQ)

%------------------------------
% INITIALIZATION
%------------------------------
    M                       =   sTSVQ.M;
    P                       =   sTSVQ.P;

%------------------------------
% PRE-PROCESSING
%------------------------------
    
    [M, K]                  =   TSVQ_find_Ks_and_K(M, P);
	partitionedData{1}      =   DM2;
    CB_DxKt(:,1)            =   mean(DM2,2);  %mean along rows, output is a col vector

%------------------------------
% PROCESSING
%------------------------------
    
    for m=1:M                    %visit each stage codevector 
        [CB_DxKt(:,2*m), CB_DxKt(:, 2*m+1), partitionedData{2*m}, partitionedData{2*m+1}] ...
                            =   TSVQ_basicTrainingUnit(partitionedData{m}); %at each ntn, create 2 children nodes
    end

%------------------------------
% POST-PROCESSING
%------------------------------    
   sTSVQ.CB_DxKt            =   CB_DxKt;  %terminal and non-terminal codevectors
   sTSVQ.CB_DxK             =   CB_DxKt(:, M+1:M+K);
   sTSVQ.partitionedData    =   partitionedData;
   
   sTSVQ                    =   UTIL_METRICS_compute_training_error_RVQ_style(DM2, sTSVQ, 4);  
   sTSVQ.K                  =   K;
   