%-----------------------------
%INITIALIZATIONS
%-----------------------------
%matlab
%     clear;
%     clc;
%     close all;
%     format compact;
    
function UTIL_cross_validation_wrapper(ds_code)
%algorithm parameters    
    %BPCA
    aBPCA.in_1__name        =   'aBPCA';
	aBPCA.in_2__data        =	'tst';
    aBPCA.mdl_1_Q___1x1      =   16;  

    %RVQ   
	aRVQx.in_1__name        =   'aRVQx';
    aRVQx.in_2__data        =   'tst';          %data type: trg or tst, default is tst
    aRVQx.in_3__maxQ        =   8;              %max number of stages  
    aRVQx.in_5__tSNR        =   1000;           %target SNRdB during learning (creating codebooks)   
    aRVQx.odir              =   '';
    rvq__tstI               =   1;
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

[DM2, sw, sh]               =   DM2_create(ds_code);
PARAM.ds_1_code             =   ds_code;  %Dudek
if (ds_code==9)
    aRVQx.in_8__type        =   'uint8';
else
    aRVQx.in_8__type        =   'double';
end
PARAM.tgt_sw                =   sw;
PARAM.tgt_sh                =   sh;
[PARAM.ds_2_name, PARAM.ds_3_name] =    UTIL_DATASET_getName3(PARAM.ds_1_code);
[D,F]                       =   size(DM2);   
%-----------------------------
% 2. PROCESSING
%-----------------------------
    %lst_Q                  =   [1:8];      %TSVQ
    lst_Q                  =   [4:4:256];  %PCA
    %lst_M                   =   2:1:16;     %RVQ
    qidx                    =   0;

    for  q = lst_Q
    %for m=lst_M 
        qidx                =   qidx+1
        aBPCA.mdl_1_Q___1x1=   q;
        %aTSVQ.in_3__maxQ   =   q;
        %aRVQx.in_4__M___    =   m;
        %[aRVQx temp]        =   RVQx_config(PARAM, [], aRVQx.in_3__maxQ, m, aRVQx.in_5__tSNR, rvq__tstI, 0, aRVQx.in_8__type); %0 is lambda
        [rmse_trg(qidx), rmse_tst(qidx)]  ... 
                            =   UTIL_DATA_cross_validation(DM2, aBPCA,numTrials, percentage_tst)
                            %=   UTIL_DATA_cross_validation(DM2, aTSVQ, numTrials,percentage_tst)
                            %=   UTIL_DATA_cross_validation(DM2, aRVQx, numTrials, percentage_tst)
                            

    end    

    rmse_trg
    rmse_tst
    save(['pca_cross_validation_' num2str(ds_code)])

