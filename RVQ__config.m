function [aRVQx, trkRVQx]   = RVQ__config(in_rvq__maxQ, in_rvq__M, in_rvq__targetSNRdB, rvq__tstI, tgt_sw, tgt_sh, trkMEAN)

    aRVQx.in_1__name        =   'aRVQx';    
    aRVQx.in_2__data        =   'tst';                      %default mode
    aRVQx.in_3__maxQ        =   in_rvq__maxQ;               %max stages
    aRVQx.in_4__M___        =   in_rvq__M;                  %number of codevectors per stage
    aRVQx.in_5__tSNR        =   in_rvq__targetSNRdB;        %targeted SNR for codebook generation
    aRVQx.in_6__sw__        =   tgt_sw;                     %snippet width
    aRVQx.in_7__sh__        =   tgt_sh;                     %snippet height
    aRVQx.in_8__odir        =   PARAM.odir;                 %output directory for files that RVQ produces
    aRVQx.in_9__trgD        =   'maxQ';                     %decode stop rule for training vectors
    aRVQx.in_10_tstD        =   RVQ__testing_rule_string(rvq__tstI);         %decode stop rule for test vectors
    aRVQx.in_11_lmbd        =   0;                          %lambda, acts like a lagrange multiplier
    aRVQx.config_str        =   RVQ__config_string(aRVQx.in_3__maxQ, aRVQx.in_4__M___, aRVQx.in_5__tSNR, aRVQx.in_10_tstD);
    
	trkRVQx                 =	trkMEAN;    
 
    trkRVQx.name            =   'trkRVQx';
    trkRVQx.cfn             =   [PARAM.ds_3_name aRVQx.config_str '.txt']; 
    trkRVQx.tim_T_sec       =   0; 
                                UTIL_FILE_delete(trkRVQx.cfn);    
    