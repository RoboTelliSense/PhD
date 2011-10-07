function [aIPCA, trkaIPCA]   =   IPCA_config(PARAM, trkMEAN, pca__Q, first_mean_shxsw)

    aIPCA.in_1__name        =   'aIPCA';
    aIPCA.in_6__sw__        =   PARAM.tgt_sw;
    aIPCA.in_7__sh__        =   PARAM.tgt_sh;
    aIPCA.in_Np             =   0;                      %would like to understand the role of this better
    aIPCA.in_ff             =   PARAM.ds_5_ff; 
    aIPCA.pf_reseig         =   PARAM.pf_reseig;        %would like to understand the role of this better
    aIPCA.mdl_1_Q__1x1      =   pca__Q;              %number of eigenvectors to retain    
    aIPCA.mdl_2_mu_Dx1      =   first_mean_shxsw(:);
    aIPCA.mdl_3_U__DxQ      =   [];
    aIPCA.mdl_4_S_Bx1       =   [];
    aIPCA.config_str        =   ['aIPCA'                                    '_'  ...
                                 UTIL_GetZeroPrefixedFileNumber_3(pca__Q)   '__'];
    
    trkaIPCA                 =   TRK_derive_from_generic_tracker(PARAM, aIPCA, trkMEAN);
    

    
    