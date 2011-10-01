function [aTSVQ, trkTSVQ]   = TSVQ_config(PARAM, trkMEAN, maxQ, M)

    aTSVQ.in_1__name        =   'aTSVQ';
    aTSVQ.in_3__maxQ        =   maxQ;
    aTSVQ.in_4__M___        =   M;
    aTSVQ.config_str        =   TSVQ_config_string(maxQ, M);
   
    trkTSVQ                 =   TRK_derive_from_generic_tracker(PARAM, aTSVQ, trkMEAN); 
      
   
