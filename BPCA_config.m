function [aBPCA, trkaBPCA]   =    BPCA_config(PARAM, trkMEAN, pca__Q)

%ALGO
    aBPCA.in_1__name        =   'aBPCA';
    aBPCA.mdl_1_Q__1x1      =   pca__Q;    
    aBPCA.config_str        =   ['aBPCA'                                 '_'  ...
                                 UTIL_GetZeroPrefixedFileNumber_3(pca__Q) '__'];
                            
%TRACKER    
    trkaBPCA                 =   TRK_derive_from_generic_tracker(PARAM, aBPCA, trkMEAN); 
  
