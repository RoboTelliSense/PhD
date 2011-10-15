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
	aBPCA.in_2__data        =	'tst';
    aBPCA.mdl_1_Q___1x1      =   16;  

    %RVQ   
	aRVQx.in_1__name        =   'aRVQx';
    aRVQx.in_2__data        =   'tst';          %data type: trg or tst, default is tst
    aRVQx.in_3__maxQ        =   8;              %max number of stages  
    aRVQx.in_4__M___        =   16;              %number of codevectors/stage
    aRVQx.in_5__tSNR        =   1000;           %target SNRdB during learning (creating codebooks)   
    aRVQx.odir              =   '';
    aRVQx.in_9__trgD        =   'maxQ';         %decoding rule for training data: can't have RofE because RofE only happens after training!

    
    %TSVQ
    aTSVQ.in_1__name        =   'aTSVQ';
	aTSVQ.in_2__data        =	'tst';  
    aTSVQ.in_3__maxQ        =   4;                                          %number of stages
    aTSVQ.in_4__M___        =   2;                                          %2 is for binary aTSVQ
        
%cross validation
    numTrials                   =   10;
    percentage_tst              =   0.2;

%-----------------------------
% PRE-PROCESSING
%-----------------------------

[DM2, sw, sh]               =   DM2_create(8);
PARAM.ds_1_code             =   1;  %Dudek
PARAM.tgt_sw                =   sw;
PARAM.tgt_sh                =   sh;
[PARAM.ds_2_name, PARAM.ds_3_name] =    UTIL_DATASET_getName3(PARAM.ds_1_code);
[D,F]                       =   size(DM2);   
%-----------------------------
% 2. PROCESSING
%-----------------------------
%lst_Q                       =   [1:8];
%lst_Q                       =   [4:4:256];
lst_M                       =   4;
lst_I                       =   1:4;



qidx                        =   0;
%for  q = lst_Q
for tstI=lst_I
    for m=lst_M
    tic
    qidx                    =   qidx+1
    %aBPCA.mdl_1_Q___1x1     =   q;
    %aTSVQ.in_3__maxQ       =   q;
    aRVQx.in_4__M___        =   m;
    [aRVQx temp]            =   RVQx_config(PARAM, [], aRVQx.in_3__maxQ, m, aRVQx.in_5__tSNR, tstI, 0); %0 is lambda
    [rmse_trg(qidx), rmse_tst(qidx)]  ... 
                            =   UTIL_DATA_crossvalidation(DM2, aRVQx, numTrials, percentage_tst)
                            %=   UTIL_DATA_crossvalidation(DM2, aTSVQ, numTrials, percentage_tst)
                            %=   UTIL_DATA_crossvalidation(DM2, aBPCA, numTrials, percentage_tst)
    toc
    %
    end    
end
rmse_trg
rmse_tst

% figure;
% plot(lst_Q, rmse_trg, 'ro-')
% hold on;
% plot(lst_Q, rmse_tst, 'bd-')
% %xlabel('Q (number of PCA eigenvectors)');
% %xlabel('Q (number of TSVQ stages)');
% %xlabel('Q (number of TSVQ stages)');
% ylabel('reconstruction rms error');
% axis([0 100 0 1.5])
% %axis([1 8 0 20]) 
% grid on;
% legend('trg', 'tst');
% %UTIL_FILE_save2pdf('randn_PCA.pdf')
% UTIL_FILE_save2pdf('PCA_GaussMarkov.pdf')
