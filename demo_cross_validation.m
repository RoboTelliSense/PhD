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
    aBPCA.mdl_1_Q__1x1      =   16;  

    %RVQ   
	aRVQ1.in_1__name        =   'aRVQx';
    aRVQ1.in_2__data        =   'tst';          %data type: trg or tst, default is tst
    aRVQ1.in_3__maxQ        =   8;              %max number of stages  
    aRVQ1.in_4__M___        =   16;              %number of codevectors/stage
    aRVQ1.in_5__tSNR        =   1000;           %target SNRdB during learning (creating codebooks)        
    aRVQ1.odir              =   '';
    aRVQ1.in_9__trgD        =   'maxQ';         %decoding rule for training data: can't have RofE because RofE only happens after training!
    aRVQ1.in_10_tstD        =   'maxQ';         %decoding rule for test data: 
    
    
    aTSVQ.in_1__name        =   'aTSVQ';
	aTSVQ.in_2__data        =	'tst';  
    aTSVQ.in_3__maxQ        =   4;                                          %number of stages
    aTSVQ.in_4__M___        =   2;                                          %2 is for binary aTSVQ
        
    
%-----------------------------
% PRE-PROCESSING
%-----------------------------

[DM2, sw, sh]               =   DM2_create(6);
[D,F]                       =   size(DM2);   
numTrials                   =   10;
percentage_tst              =   0.2;
%-----------------------------
% 2. PROCESSING
%-----------------------------
qidx                        =   0;
%lst_Q                       =   [1:8];
%lst_Q                       =   [4:4:256];
lst_M                       =   4;
%for  q = lst_Q
    for m=lst_M
    tic
    qidx                    =   qidx+1;
    %aBPCA.mdl_1_Q__1x1      =   q;
    %aTSVQ.in_3__maxQ        =   q;
    aRVQ1.in_4__M___         =  m;
    [rmse_trg(qidx), rmse_tst(qidx)]  ... 
                            =   UTIL_DATA_crossvalidation(DM2, aRVQx, numTrials, percentage_tst)
                            %=   UTIL_DATA_crossvalidation(DM2, aTSVQ, numTrials, percentage_tst)
                            %=   UTIL_DATA_crossvalidation(DM2, aBPCA, numTrials, percentage_tst)
    toc
    %
end    
rmse_trg
rmse_tst

figure;
plot(lst_Q, rmse_trg, 'ro-')
hold on;
plot(lst_Q, rmse_tst, 'bd-')
xlabel('Q (number of PCA eigenvectors)');
%xlabel('Q (number of TSVQ stages)');
ylabel('reconstruction rms error');
axis([0 100 0 1.5])
%axis([1 8 0 20]) 
grid on;
legend('trg', 'tst');
%UTIL_FILE_save2pdf('randn_PCA.pdf')
UTIL_FILE_save2pdf('PCA_GaussMarkov.pdf')
