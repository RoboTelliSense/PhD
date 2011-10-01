function [aTSVQ, trkaTSVQ]   = TSVQ_config(PARAM, trkMEAN, maxQ, M)

    aTSVQ.in_1__name        =   'aTSVQ';
    aTSVQ.in_3__maxQ        =   maxQ;
    aTSVQ.in_4__M___        =   M;
    aTSVQ.config_str        =   ['aTSVQ'                                '_' ...
                                 UTIL_GetZeroPrefixedFileNumber_2(maxQ) '_' ...
                                 UTIL_GetZeroPrefixedFileNumber_2(M)    '__']; 
   
    trkaTSVQ                 =   TRK_derive_from_generic_tracker(PARAM, aTSVQ, trkMEAN); 
      
   
