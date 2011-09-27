%% This file compares PCA, aRVQx and aTSVQ by generating its own simple data.
% 
% It can be used without any outside data, except if dataset=2 is used.
%
% sw=1, sh=1 means scalar example
% 
% aRVQx.trg_1_featr_PxN: training XDRs from using gen.exe -l or my Matlab software
%
% gen.exe -l crashes on dataset 4, and so i'm not using it any more instead, i have my own matlab code for it
% I think gen.exe -l may be crashing because I have values higher than 255
% in the dataset
%
% usage example
% -------------
% A good way to check aRVQx is to use the 1:256 scalar example in the IDDM paper.  For that use the following settings:
% dataset     =   25
% aRVQx.in_3__maxQ   =   8
% aRVQx.in_4__M___      =   2
% Then aRVQx.mdl_3_CB_DxMP (the red channel of the codebooks) is 
%       m=1   m=2
%       ---   ---
% p=1  192.5  64.5
% p=2  -32    32
% p=3  -16    16
% p=4   -8     8
% p=5   -4     4
% p=6   -2     2
% p=7   -1     1
% p=8   -0.5   0.5
% The green and the blue channels are also the same.
% This behavior is correct, as confirmed by Dr Barnes.
% The first M=2 numbers in aRVQx.mdl_3_CB_DxMP are the scalar codevectors for stage 1,
% the second M=2 numbers are the scalar codevectors for stage 2, and so on.
% 
% If test point is 192, feature vectors_PxN(:,192) produced by aRVQx.rule_stop_decoding='monRMSE' will give 
% [1;9;9;9;  9;9;9;9], the 9's, i.e., P+1s, showing early termination.
% So, the reproduction value is 192 and the error is 0.5.  
% feature vectors_PxN produced by gen.exe -l or aRVQx.rule_stop_decoding='maxQ' always gives full path,
% and the answer is [1;1;2;2   2;2;2;2].  So the reproduction value is also 192, and the error is again 0.5 
% 
% If test point is 253, my software gives reproduction of 252.5, an error of 0.5: 192.5 + 32 + 16 + 8 + 4              = 252.5 
% gen.exe -l gives a reproduction of 253, an error of 0:                          192.5 + 32 + 16 + 8 + 4 + 2 - 1 -0.5 = 253
% Notice that my software did not pick a codevector of 2 since that would have increased error.  
% However, gen.exe -l continues encoding and error is decreased 
%
% If test point is 256, gen.exe -l produces [1 2 2 2 2 2 2 1], i.e. 255 instead of the possible 255.5.
% My code produces 255.5 and therefore has less error.
%          
% end: usage example
% ------------------
%
% for reference, SNRs for dataset==3 are [46.0277   17.7511  25.2638   30.7671],
% and rmse's are                         [1.0737    27.8433  11.7242    6.2219]
% in order these are PCA, aRVQx (monRMSE), aRVQx (RoE), aTSVQ
% aTSVQ values can change though since the K-means can produce different
% results each time
%
% RVQ__old uses the aRVQx testing algorithm from first draft version of my thesis
% it worked perfectly, but i've just added more functionality, basically,
% my matlab version of gen.exe -l and a more intuitive testing algorithm.
% so, the training version does some extra stuff and the testing version
% does exactly the same, but just more intuitively
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : April 20, 2011
% Date last modified : July 19, 2011.
%%

%-----------------------------
%INITIALIZATIONS
%-----------------------------
%matlab
    clear;
    clc;
    close all;
    format compact;
    
%-----------------------------
% 1. PRE-PROCESSING
%-----------------------------
%algorithm parameters    
    %BPCA
    aBPCA.in_1__name        =   'aBPCA';
	aBPCA.in_2__data        =	'tst';
    aBPCA.mdl_1_Q__1x1      =   16;   
    aBPCA.in____cnfg        =   BPCA_config_string(aBPCA.mdl_1_Q__1x1);
    
    %RVQ   
	aRVQ1.in_1__name        =   'aRVQx';
    aRVQ1.in_2__data        =   'tst';          %data type: trg or tst, default is tst
    aRVQ1.in_3__maxQ        =   8;              %max number of stages  
    aRVQ1.in_4__M___        =   8;              %number of codevectors/stage
    aRVQ1.in_5__tSNR        =   1000;           %target SNRdB during learning (creating codebooks)        
    aRVQ1.in_8__odir        =   '';
    aRVQ1.in_9__trgD        =   'maxQ';         %decoding rule for training data: can't have RofE because RofE only happens after training!
    aRVQ1.in_10_tstD        =   'maxQ';         %decoding rule for test data: 
    aRVQ1.in____cnfg        =   RVQ__config_string(aRVQ1.in_3__maxQ, aRVQ1.in_4__M___, aRVQ1.in_5__tSNR, aRVQ1.in_10_tstD);
    
    %TSVQ
    aTSVQ.in_1__name        =   'aTSVQ';
	aTSVQ.in_2__data        =	'tst';  
    aTSVQ.in_3__maxQ        =   4;                                          %number of stages
    aTSVQ.in_4__M___        =   4;                                          %2 is for binary aTSVQ
    aTSVQ.in____cnfg        =   TSVQ_config_string(aTSVQ.in_3__maxQ, aTSVQ.in_4__M___);
    

%-----------------------------
% 2. PROCESSING
%-----------------------------
datasetcode=2;
for f=1:1
    tic
    f
    [DM2, sw, sh]           =   DATAMATRIX_master_create(datasetcode);
    aRVQ1.in_6__sw__        =   sw;             %snippet width
    aRVQ1.in_7__sh__        =   sh;             %snippet height
    
    
    %learning    
    %aBPCA                   =    PCA__1_learn     (DM2, aBPCA); 
    
    aRVQ1                   =    RVQ__1_learn     (DM2, aRVQ1);
    aRVQ2                   =   aRVQ1;  aRVQ2.in_10_tstD = 'RofE';
    aRVQ3                   =   aRVQ1;  aRVQ3.in_10_tstD = 'nulE';
    aRVQ4                   =   aRVQ1;  aRVQ4.in_10_tstD = 'monE';
    
    
    %aTSVQ                   =    TSVQ_1_learn     (DM2, aTSVQ); 
      
    [DM2_tst, sw, sh]       =   DATAMATRIX_master_create(datasetcode);
    %decoding
    %aBPCA                   =   PCA__2_encode(DM2_tst, aBPCA);                  
    aRVQ1                   =   RVQ__2_encode(DM2_tst, aRVQ1);
    aRVQ2                   =   RVQ__2_encode(DM2_tst, aRVQ2);
    aRVQ3                   =   RVQ__2_encode(DM2_tst, aRVQ3);
    aRVQ4                   =   RVQ__2_encode(DM2_tst, aRVQ4);
    
    %aTSVQ                   =   TSVQ_2_encode(DM2_tst, aTSVQ);

    trg_rmse(f,:)           =   aRVQ1.trg_5_rmse__1x1%[aBPCA.trg_5_rmse__1x1     aRVQx.trg_5_rmse__1x1    aTSVQ.trg_5_rmse__1x1         ]
    tst_rmse(f,:)           =   [aRVQ1.tst_5_rmse__1x1 aRVQ2.tst_5_rmse__1x1 aRVQ3.tst_5_rmse__1x1 aRVQ4.tst_5_rmse__1x1]%[aBPCA.tst_5_rmse__1x1     aRVQx.tst_5_rmse__1x1    aTSVQ.tst_5_rmse__1x1         ]
    
    toc
    temp                    =   1;
end    
    
%-----------------------------
%RESULTS
%-----------------------------
%view
    numDisplayRows          =   5;
    numDisplayCols          =   10;
                                %figure;DATAMATRIX_display_DM2_as_image(DM2,            sh, sw, numDisplayRows, numDisplayCols);title('input');
                                %figure;DATAMATRIX_display_DM2_as_image(aBPCA.mdl_3_U__DxP, sh, sw, numDisplayRows, numDisplayCols);title('aBPCA eigenvectors');
                                %figure;DATAMATRIX_display_DM2_as_image(aRVQx.mdl_3_CB_DxMP, sh, sw, aRVQx.mdl_1_Q__1x1, aRVQx.in_4__M___);title('aRVQx codebooks');
                                %figure;DATAMATRIX_display_DM2_as_image(aTSVQ.mdl_4_CB_DxK, sh, sw, aTSVQ.mdl_1_Q__1x1, aTSVQ.mdl_5_K__1x1);title('aTSVQ codebooks');
    

