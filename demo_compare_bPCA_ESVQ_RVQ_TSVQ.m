%% This file compares PCA, aRVQx and aTSVQ by generating its own simple data.
% 
% It can be used without any outside data, except if dataset=2 is used.
%
% sw=1, sh=1 means scalar example
% 
% aRVQx.trg_1_featr_QxN: training XDRs from using gen.exe -l or my Matlab software
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
% Then aRVQx.mdl_3_EC_DxMQ (the red channel of the codebooks) is 
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
% The first M=2 numbers in aRVQx.mdl_3_EC_DxMQ are the scalar codevectors for stage 1,
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
    
%algorithm parameters    
    %BPCA
    aBPCA.in_1__name        =   'aBPCA';
    aBPCA.in_2__data        =   'tst';
    aBPCA.mdl_1_Q___1x1      =   16;   
    
    %RVQ   
    aRVQ1.in_1__name        =   'aRVQx';
    aRVQ1.in_2__data        =   'tst';          %data type: trg or tst, default is tst
    aRVQ1.in_3__maxQ        =   8;              %max number of stages  
    aRVQ1.in_4__M___        =   16;              %number of codevectors/stage
    aRVQ1.in_5__tSNR        =   1000.0;           %target SNRdB during learning (creating codebooks)        
    aRVQ1.odir              =   '';
    aRVQ1.in_9__trgD        =   'maxQ';         %decoding rule for training data: can't have RofE because RofE only happens after training!
    aRVQ1.in_10_tstD        =   'maxQ';         %decoding rule for test data: 
    
    %TSVQ
    aTSVQ.in_1__name        =   'aTSVQ';
    aTSVQ.in_2__data        =   'tst';  
    aTSVQ.in_3__maxQ        =   4;                                          %number of stages
    aTSVQ.in_4__M___        =   4;                                          %2 is for binary aTSVQ
    
%-----------------------------
% PRE-PROCESSING
%-----------------------------

%Dudek
[DM2_trg, sw, sh]           =   DM2_create(13);
[DM2_tst, sw, sh]           =   DM2_create(13);

%Gauss Markov
%[temp, sw, sh]              =   DM2_create(10);
%DM2_trg                     =   temp(:,1:100);
%DM2_tst                     =   temp(:,101);

%Uniform and Gaussian
%DM2_trg = round(255*rand(1089,100));            sw=33;sh=33;
%DM2_tst = round(255*rand(1089,1));

%DM2_trg = rand(1,7);            sw=1;sh=1;
%DM2_trg=[0.6160    0.9475    0.0684    0.0370    0.9643    0.7116    0.1346];
%DM2_tst = rand(1,1);



[D,F]                       =   size(DM2_trg);   
cfn_gentxt                  =   [num2str(F) '_verbose.txt'];           %file 4, verbose output of gen.exe,    (F1.stat_gen.txt)

aRVQ1.in_6__sw__            =   sw;             %snippet width
aRVQ1.in_7__sh__            =   sh;             %snippet height


%-----------------------------
% 2. PROCESSING
%-----------------------------
midx                        =   0;
lst_M                       =   3;
for  m = lst_M
    
    tic
    midx                    =   midx+1;
    
    %parameters
    aRVQ1.in_4__M___        =   m;
    
    %learning    
    aRVQ1                   =   RVQ__1_learn     (DM2_trg, aRVQ1);
    aRVQ2                   =   aRVQ1;  aRVQ2.in_10_tstD = 'RofE';
    aRVQ3                   =   aRVQ1;  aRVQ3.in_10_tstD = 'nulE';
    aRVQ4                   =   aRVQ1;  aRVQ4.in_10_tstD = 'monR';
    
    %encoding
    aRVQ1                   =   RVQ__2_encode_decode(DM2_tst, aRVQ1);
    aRVQ2                   =   RVQ__2_encode_decode(DM2_tst, aRVQ2);
    aRVQ3                   =   RVQ__2_encode_decode(DM2_tst, aRVQ3);
    aRVQ4                   =   RVQ__2_encode_decode(DM2_tst, aRVQ4);
    
    str_rvq                 =   RVQx_stats_str(aRVQ1,1);
    
    %stats
    rmse_trg(midx)          =   aRVQ1.trg_5_rmse__1x1;
    rmse_tst(midx,:)        = [ aRVQ1.tst_5_rmse__1x1 ...
                                aRVQ2.tst_5_rmse__1x1 ...
                                aRVQ3.tst_5_rmse__1x1 ...
                                aRVQ4.tst_5_rmse__1x1] 

    %UTIL_FILE_copy(cfn_gentxt, [num2str(m) '_' cfn_gentxt]);
    toc
    save(['aRVQ_dudek_trg_1_to_95_m_' num2str(m)]);
end    
    
%--------------------------------------------------------
% POST-PROCESSING
%--------------------------------------------------------
%eRMSE and dRMSE
    [eRMSE_allvals eRMSE]   =   RVQ_FILES_read_from_genstat_file(cfn_gentxt, 1); %1 is for eRMSE
    [dRMSE_allvals dRMSE]   =   RVQ_FILES_read_from_genstat_file(cfn_gentxt, 3); %3 is for dRMSE
                                plot(eRMSE(:,1), eRMSE(:,2), 'ro-');%set(gca, 'XTickLabel', num2cell(num2str(eRMSE_allvals(:,1))));
                                hold on;
                                plot(dRMSE(:,1), dRMSE(:,2), 'c^-');

%my data   
    Q=aRVQ1.mdl_1_Q___1x1;
    for i=1:Q
        out(i) = UTIL_METRICS_compute_rms(aRVQ1.trg_8_ermse_QxN(i,:))
        out1(i) = UTIL_METRICS_compute_rms(aRVQ1.tst_8_drmse_QxN(i,:))
        out2(i) = UTIL_METRICS_compute_rms(aRVQ2.tst_8_drmse_QxN(i,:))
        out3(i) = UTIL_METRICS_compute_rms(aRVQ3.tst_8_drmse_QxN(i,:))
        out4(i) = UTIL_METRICS_compute_rms(aRVQ4.tst_8_drmse_QxN(i,:))
    end
    %plot(1:Q,                     out , 'g+-');
    %plot(1:Q,                     out1 , 'bd-');
    %plot(1:Q,                     aRVQ2.tst_8_drmse_QxN(1:Q) , 'bd-');
    %plot(1:Q, UTIL_RVQ_repeat_SNR(aRVQ3.tst_8_drmse_QxN(1:Q)), 'm*-');
    %plot(1:Q, UTIL_RVQ_repeat_SNR(aRVQ4.tst_8_drmse_QxN(1:Q)), 'ks-');
    axis([1 Q 0 1.5])
    grid on;
    
    %axis([1 8 0 1.5])
    %axis([1 8 0 20])
    xlabel('q (stage index)');
    ylabel('reconstruction rms error');
    set(gca, 'XTick', 1:Q)
    legend('trg (eRMSE)', 'trg (dRMSE)');%'trg (eRMSE, matlab)'
    %legend('trg (eRMSE)', 'trg (dRMSE)', 'tst, maxQ', 'tst, RofE', 'tst, nulE', 'tst, monR');
    %UTIL_FILE_save2pdf('RVQ_8x4_Dudek_trg_1_to_100_tst_101.pdf', gcf, 300);
    UTIL_FILE_save2pdf('RVQ_3x2_1_to_7_22_34.pdf', gcf, 300);




%-----------------------------
%RESULTS
%-----------------------------
    % mu_tst                      =   mean(rmse_tst);
    % rmse_tst_with_mean          =   [rmse_tst;mu_tst]

%view
%    numDisplayRows          =   10;
%    numDisplayCols          =   10;
                                %figure;DM2_show(DM2_trg,            sh, sw, numDisplayRows, numDisplayCols, 0);
                                %figure;DM2_show(aBPCA.mdl_3_U__DxQ, sh, sw, numDisplayRows, numDisplayCols, 1);title('aBPCA eigenvectors');
                                %figure;DM2_show(aRVQ1.mdl_3_EC_DxMQ, sh, sw, aRVQ1.mdl_1_Q___1x1, aRVQ1.in_4__M___, 1);%title('aRVQx codebooks');
                                %figure;DM2_show(aTSVQ.mdl_4_CB_DxK, sh, sw, aTSVQ.mdl_1_Q___1x1, aTSVQ.mdl_5_K__1x1, 1);title('aTSVQ codebooks');
    
%training
%     figure;
%     hold on
%     grid on; 
%     plot(lst_M, rmse_trg, 'ro-')
%     xlabel('number of code-vectors per stage, m');
%     UTIL_FILE_save2pdf('aRVQ_dudek_trg_1_to_95.pdf', gcf, 300);   
    
%testing                                
%     figure;
%     hold on
%     grid on; 
%     plot(lst_M, rmse_tst(:,1), 'g+-');   
%     plot(lst_M, rmse_tst(:,2), 'bd-');  
%     plot(lst_M, rmse_tst(:,3), 'm*-');  
%     plot(lst_M, rmse_tst(:,4), 'ks-');      
%     legend('tst, maxQ', 'tst, RofE', 'tst, nulE', 'tst, monR', 'Location', 'Best'); %
%     xlabel('number of code-vectors per stage, m');
%     UTIL_FILE_save2pdf('aRVQ_dudek_trg_1_to_95_tst_96_to_100.pdf', gcf, 300);
% 
%         
% 
%  
%      rowLabels = {'m=2', 'm=3', 'm=4', 'm=5', 'm=6', 'm=7', 'm=8', 'm=9', 'm=10', 'm=11', 'm=12', 'm=13', 'm=14', 'm=15', 'm=16', 'mean'};
%      colLabels = {'maxQ', 'RofE', 'nulE', 'monR'};
%      UTIL_matrix2latex(rmse_tst_with_mean, 'aRVQ_dudek_trg_1_to_95_tst_96_to_100.tex', 'rowLabels', rowLabels, 'columnLabels', colLabels, 'alignment', 'c', 'format', '%-6.4f');
% 
%     
    

