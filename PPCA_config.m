function [aPPCA, trkaPPCA]   =    PPCA_config(PARAM, trkMEAN, pca__Q)

%ALGO
    aPPCA.in_1__name        =   'aPPCA';
    aPPCA.mdl_1_Q__1x1      =   pca__Q;    
    aPPCA.config_str        =   ['aPPCA'                                 '_'  ...
                                 UTIL_GetZeroPrefixedFileNumber_3(pca__Q) '__'];
                            
%TRACKER    
    trkaPPCA                 =   TRK_derive_from_generic_tracker(PARAM, aPPCA, trkMEAN); 
  
