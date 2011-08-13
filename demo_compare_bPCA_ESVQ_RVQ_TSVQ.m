%% This file compares PCA, RVQ and TSVQ by generating its own simple data.
% 
% It can be used without any outside data, except if dataset=2 is used.
%
% sw=1, sh=1 means scalar example
% 
% sRVQ.trg_XDRs_PxN: training XDRs from using gen.exe -l or my Matlab software
%
% gen.exe -l crashes on dataset 4, and so i'm not using it any more instead, i have my own matlab code for it
% I think gen.exe -l may be crashing because I have values higher than 255
% in the dataset
%
% usage example
% -------------
% A good way to check RVQ is to use the 1:256 scalar example in the IDDM paper.  For that use the following settings:
% dataset     =   2
% sRVQ.maxP   =   8
% sRVQ.M      =   2
% Then sRVQ.CB_r (the red channel of the codebooks) is 
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
% The first M=2 numbers in sRVQ.CB_r are the scalar codevectors for stage 1,
% the second M=2 numbers are the scalar codevectors for stage 2, and so on.
% 
% If test point is 192, trg_XDRs_PxN(:,192) produced by sRVQ.rule_stop_decoding='monotonic_PSNR' will give 
% [1;9;9;9;  9;9;9;9], the 9's, i.e., P+1s, showing early termination.
% So, the reproduction value is 192 and the error is 0.5.  
% trg_XDRs_PxN produced by gen.exe -l or sRVQ.rule_stop_decoding='full_path' always gives full path,
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
% in order these are PCA, RVQ (monotonic_PSNR), RVQ (realm_of_experience), TSVQ
% TSVQ values can change though since the K-means can produce different
% results each time
%
% sRVQ_old uses the RVQ testing algorithm from first draft version of my thesis
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
    dataset                 =   2;                                          %change this to 1, 2, 3, 4 or 5
    
    %deterministic, simple scalar examples
    if     (dataset==1) DM2 =   [4 6 8 10 20 22 24 26];       sw=1; sh=1;   %simplest possible, i've worked this out by hand in a pdf
    elseif (dataset==2) DM2 =   1:256;                        sw=1; sh=1;   %scalar example mentioned in IDDM
    
    %deterministic, vector (image) example
    elseif (dataset==3)         load testS_DM2_small;         sw=41;sh=27;  %i created this movie in Blender3D.  it has an S written on a moving box          
        
    %random data
    elseif (dataset==4) [DM2,sw,sh] ...                                     
                            =   DATAMATRIX_create_random_DM2;               
    elseif (dataset==5) a   =   rand(1089,2);...
                        DM2 =   [a a a a];                    sw=33;sh=33;  %this is a bizarre example, i.e., has repeated data points
    end

    [D, N]                  =   size(DM2);                                  %dimensions of DM2

    
%algorithm parameters
    %bpca
    sBPCA.tstprm_Neig_1x1   =   16;                                         
    sBPCA.trg_XDRs_PxN      =   [];
    sBPCA.tst_XDR_Px1       =   [];
    
    %tsvq
    sTSVQ.P                 =   3;                                          %number of stages
    sTSVQ.M                 =   2;                                          %2 is for binary TSVQ
    sTSVQ.trg_XDRs_PxN      =   []; 
    sTSVQ.tst_XDR_Px1       =   [];
    
    %rvq    
    sRVQ_old.maxP            =   8;                                          %number of stages  
    sRVQ_old.M               =   2;                                          %number of codevectors/stage
    sRVQ_old.targetSNR       =   1000;
    sRVQ_old.sw              =   sw;                                         %snippet width
    sRVQ_old.sh              =   sh;                                         %snippet height
    sRVQ_old.dir_out         =   '';
    sRVQ_old.trg_XDRs_PxN    =   [];
    sRVQ_old.tst_XDR_Px1     =   [];

    %rvq    
    sRVQ.maxP               =   8;                                          %number of stages  
    sRVQ.M                  =   2;                                          %number of codevectors/stage
    sRVQ.targetSNR          =   1000;
    sRVQ.sw                 =   sw;                                         %snippet width
    sRVQ.sh                 =   sh;                                         %snippet height
    sRVQ.dir_out            =   '';
    sRVQ.trg_XDRs_PxN       =   [];
    sRVQ.tst_XDR_Px1        =   [];
      

%-----------------------------
% PROCESSING
%-----------------------------
%training    
    sBPCA                   =   bPCA_1_train        (DM2, sBPCA); 
    sRVQ_old                =   RVQ__training       (DM2, sRVQ_old); 
    sRVQ                    =   RVQ__training       (DM2, sRVQ);           %!caution!: in this new version, decoding rule here is changed to 'full_stage' to mimic gen.exe -l functionality   
    sTSVQ                   =   TSVQ_1_train        (DM2, sTSVQ); 
    
%test vector    
    tst_idx                 =   8;                                          %any number between 1 and N, index                                                                        %of training data that you want to test
    tst_Dx1                 =   DM2(:,tst_idx);                             %test vector
    
%PCA    
    sBPCA                   =   bPCA_3_test                 (tst_Dx1, sBPCA);

%RVQ    
    sRVQ_old                =   RVQ__testing_grayscale_old  (tst_Dx1, sRVQ_old); %this always uses the 'monotonic_PSNR' decoding rule
    %sRVQ.rule_stop_decoding =   'realm_of_experience';
    %sRVQ.rule_stop_decoding =   'monotonic_PSNR';
    sRVQ.rule_stop_decoding =   'full_stage';
    sRVQ                    =   RVQ__testing_grayscale      (tst_Dx1, sRVQ);%here, the rule is always monotonic PSNR

%TSVQ    
    sTSVQ                   =   TSVQ_3_test                 (tst_Dx1, sTSVQ);
    
%-----------------------------
%RESULTS
%-----------------------------
%view
    numDisplayRows          =   5;
    numDisplayCols          =   10;
                                DATAMATRIX_display_DM2_as_image(DM2,                sh, sw, numDisplayRows, numDisplayCols);
                                DATAMATRIX_display_DM2_as_image(sBPCA.trgout_U_DxD, sh, sw, numDisplayRows, numDisplayCols);
    
%print
	%[DM2(:,tst_idx)      sBPCA.tst_recon_Dx1     sRVQ.tst_recon_Dx1      sTSVQ.tst_recon_Dx1]
    codebook_diff           =   norm(sRVQ_old.CB_r(:) - sRVQ.CB_r(:));
    XDR_diff                =   norm(sRVQ_old.tst_XDR_Px1(:) - sRVQ.tst_XDR_Px1(:));
    
    [sBPCA.tst_SNRdB    sRVQ_old.tst_SNRdB      sRVQ.tst_SNRdB   sTSVQ.tst_SNRdB        codebook_diff]
    [sBPCA.tst_rmse     sRVQ_old.tst_rmse       sRVQ.tst_rmse    sTSVQ.tst_rmse         XDR_diff]
    
                                                
                                        
                                        
                                        
                                        % for scalar training data in this file, 1:1:256, codebooks are as follows:


