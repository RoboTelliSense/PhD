function [aBPCA, trkBPCA]   =    BPCA_config(PARAM, trkMEAN, pca__Q)

    aBPCA.in_1__name        =   'aBPCA';
    aBPCA.mdl_1_Q__1x1      =   pca__Q;    
    aBPCA.in____cnfg        =   BPCA_config_string(aBPCA.mdl_1_Q__1x1);
    
    trkBPCA                 =   TRK_derive_from_generic_tracker(PARAM, aBPCA, trkMEAN); 
  
