function [aRVQx trkRVQx]    = RVQx_config(PARAM, trkMEAN, maxQ, M, targetSNRdB, tstI)

    tstD                    =   RVQ__testing_rule_string(tstI); %decode stop rule for test vectors

    aRVQx.in_1__name        =   'aRVQx';    
    aRVQx.in_2__data        =   'tst';                      %default mode
    aRVQx.in_3__maxQ        =   maxQ;                       %max stages
    aRVQx.in_4__M___        =   M;                          %number of codevectors per stage
    aRVQx.in_5__tSNR        =   targetSNRdB;                %targeted SNR for codebook generation
    aRVQx.in_6__sw__        =   PARAM.tgt_sw;               %snippet width
    aRVQx.in_7__sh__        =   PARAM.tgt_sh;               %snippet height
    
    aRVQx.in_9__trgD        =   'maxQ';                     %decode stop rule for training vectors
    aRVQx.in_10_tstD        =   tstD;                       %decode stop rule for test vectors
    aRVQx.in_11_lmbd        =   0;                          %lambda, acts like a lagrange multiplier
    aRVQx.config_str        =   RVQ__config_string(maxQ, M, targetSNRdB, tstD);
    aRVQx.tim_T_sec         =   0;                          %stats: total running time in sec
    
    trkRVQx                 =   TRK_derive_from_generic_tracker(PARAM, aRVQx, trkMEAN); 
   
    aRVQx.in_8__odir        =   UTIL_addSlash([PARAM.ds_3_name    aRVQx.config_str]); %output directory for files that RVQ produces                                                            
    mkdir(aRVQx.in_8__odir);
    