function [aRVQx trkaRVQx]    = RVQx_config(PARAM, trkMEAN, maxQ, M, tSNR, tstI, lmbd, dataType)

    tstD                    =   RVQ__testing_rule_string(tstI); %decode stop rule for test vectors

    aRVQx.in_1__name        =   'aRVQx';    
    aRVQx.in_2__data        =   'tst';                      %default mode
    aRVQx.in_3__maxQ        =   maxQ;                       %max stages
    aRVQx.in_4__M___        =   M;                          %number of codevectors per stage
    aRVQx.in_5__tSNR        =   tSNR;                       %targeted SNR for codebook generation
    aRVQx.in_6__sw__        =   PARAM.tgt_sw;               %snippet width
    aRVQx.in_7__sh__        =   PARAM.tgt_sh;               %snippet height
    aRVQx.in_8__type        =   dataType;                   %RVQ data type, 'uint8', 'double'
    aRVQx.in_9__trgD        =   'maxQ';                     %decode stop rule for training vectors
    aRVQx.in_10_tstD        =   tstD;                       %decode stop rule for test vectors
    aRVQx.in_11_lmbd        =   lmbd;                       %lambda, acts like a lagrange multiplier
    aRVQx.tim_T_sec         =   0;                          %stats: total running time in sec
    aRVQx.config_str        =   ['aRVQ'                                         '_' ...
                                  UTIL_GetZeroPrefixedFileNumber_2(maxQ)        '_' ...
                                  UTIL_GetZeroPrefixedFileNumber_2(M)           '_' ...
                                  UTIL_GetZeroPrefixedFileNumber_4(tSNR)        '_' ...
                                  num2str(lmbd)                                 '_' ...
                                  tstD                                          '__'];  
    aRVQx.odir              =   UTIL_addSlash([PARAM.ds_3_name    aRVQx.config_str]); %output directory for files that RVQ produces                                                            
    mkdir(aRVQx.odir);
    
    trkaRVQx                 =   TRK_derive_from_generic_tracker(PARAM, aRVQx, trkMEAN); 
    
    