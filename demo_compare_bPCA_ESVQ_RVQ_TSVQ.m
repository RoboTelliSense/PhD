%% This file compares PCA, aRVQ and aTSVQ by generating its own simple data.
% 
% It can be used without any outside data, except if dataset=2 is used.
%
% sw=1, sh=1 means scalar example
% 
% aRVQ.trg_1_featr_PxN: training XDRs from using gen.exe -l or my Matlab software
%
% gen.exe -l crashes on dataset 4, and so i'm not using it any more instead, i have my own matlab code for it
% I think gen.exe -l may be crashing because I have values higher than 255
% in the dataset
%
% usage example
% -------------
% A good way to check aRVQ is to use the 1:256 scalar example in the IDDM paper.  For that use the following settings:
% dataset     =   25
% aRVQ.in_3__maxP   =   8
% aRVQ.in_4__M___      =   2
% Then aRVQ.mdl_3_CB_DxMP (the red channel of the codebooks) is 
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
% The first M=2 numbers in aRVQ.mdl_3_CB_DxMP are the scalar codevectors for stage 1,
% the second M=2 numbers are the scalar codevectors for stage 2, and so on.
% 
% If test point is 192, feature vectors_PxN(:,192) produced by aRVQ.rule_stop_decoding='monRMSE' will give 
% [1;9;9;9;  9;9;9;9], the 9's, i.e., P+1s, showing early termination.
% So, the reproduction value is 192 and the error is 0.5.  
% feature vectors_PxN produced by gen.exe -l or aRVQ.rule_stop_decoding='maxP' always gives full path,
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
% in order these are PCA, aRVQ (monRMSE), aRVQ (RoE), aTSVQ
% aTSVQ values can change though since the K-means can produce different
% results each time
%
% RVQ__old uses the aRVQ testing algorithm from first draft version of my thesis
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

%data input (5 different datasets, pick one of them)
    dataset                 =   3;                                          %change this to 1, 2, 3, 4 or 5
    
    %deterministic, simple scalar examples
    if     (dataset==1) DM2 =   [4 6 8 10 20 22 24 26];       sw=1; sh=1;   %simplest possible, i've worked this out by hand in a pdf
    elseif (dataset==2) DM2 =   1:256;                        sw=1; sh=1;   %scalar example mentioned in IDDM
    
    %deterministic, vector (image) example
    elseif (dataset==3)         load testS_DM2_small;         sw=41;sh=27;  %i created this movie in Blender3D.  it has an S written on a moving box          
        
    %random data  (simple)
    elseif (dataset==4) [DM2,sw,sh] ...                                     
                            =   DATAMATRIX_create_random_DM2;       %aRVQ error is large because apparently codebooks are clamped to 255            
    %random data  (complex)
    elseif (dataset==5) a   =   rand(1089,2);...
                        DM2 =   [a a a a];                    sw=33;sh=33;  %this is a bizarre example, i.e., has repeated data points
    end

    [D, N]                  =   size(DM2);                                  %dimensions of DM2

    DM2 = DM2;
%algorithm parameters
    
    
    %bpca
    aBPCA.in_1__name         =   'aBPCA';
	aBPCA.in_2__mode         =	'tst';
    aBPCA.mdl_1_P__1x1      =   16;                                         
    
    %rvq    
    aRVQ.in_1__name          =   'aRVQ';
	aRVQ.in_2__mode          =   'tst';
    aRVQ.in_3__maxP          =   8;                                          %number of stages  
    aRVQ.in_4__M___          =   2;                                          %number of codevectors/stage
    aRVQ.in_5__tSNR          =   1000;
    aRVQ.in_6__sw__          =   sw;                                         %snippet width
    aRVQ.in_7__sh__          =   sh;                                         %snippet height
    aRVQ.in_8__odir          =   '';
    aRVQ.in_9__trgR       =   'maxP';                                     %can't have RoE because RoE only happens after training!
    aRVQ.in_10_tstR      =   'monRMSE';

    %tsvq
    aTSVQ.in_1__name         =   'aTSVQ';
	aTSVQ.in_2__mode         =	'tst';
    aTSVQ.in_3__maxP         =   4;                                          %number of stages
    aTSVQ.in_4__M___         =   2;                                          %2 is for binary aTSVQ
    
    
    
      

%-----------------------------
% PROCESSING
%-----------------------------
%training    
    aBPCA                   =    PCA__1_train     (DM2, aBPCA); 
    aRVQ                    =    RVQ__1_train     (DM2, aRVQ);           
    aTSVQ                   =    TSVQ_1_train     (DM2, aTSVQ); 
    
%testing
   
    aBPCA                   =   PCA__2_test(DM2, aBPCA);                  
    aRVQ                    =   RVQ__2_test(DM2, aRVQ);
    aTSVQ                   =   TSVQ_2_test(DM2, aTSVQ);
    
%-----------------------------
%RESULTS
%-----------------------------
%view
    numDisplayRows          =   5;
    numDisplayCols          =   10;
                                figure;DATAMATRIX_display_DM2_as_image(DM2,            sh, sw, numDisplayRows, numDisplayCols);title('input');
                                figure;DATAMATRIX_display_DM2_as_image(aBPCA.mdl_3_U__DxP, sh, sw, numDisplayRows, numDisplayCols);title('aBPCA eigenvectors');
                                figure;DATAMATRIX_display_DM2_as_image(aRVQ.mdl_3_CB_DxMP, sh, sw, aRVQ.mdl_1_P__1x1, aRVQ.in_4__M___);title('aRVQ codebooks');
                                figure;DATAMATRIX_display_DM2_as_image(aTSVQ.mdl_4_CB_DxK, sh, sw, aTSVQ.mdl_1_P__1x1, aTSVQ.mdl_5_K__1x1);title('aTSVQ codebooks');
    
    [aBPCA.trg_5_rmse__1x1     aRVQ.trg_5_rmse__1x1    aTSVQ.trg_5_rmse__1x1         ]
    [aBPCA.tst_5_rmse__1x1     aRVQ.tst_5_rmse__1x1    aTSVQ.tst_5_rmse__1x1         ]
