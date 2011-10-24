clear;
clc;
close all;

    pca__Q                  =   16;
    
    ds_code                 =   5;
    
    [PARAM.ds_2_name, PARAM.ds_3_name] =    UTIL_DATASET_getName3(ds_code);
    PARAM.tgt_sw            =   33;
    PARAM.tgt_sh            =   33;
    
    [aRVQx trkaRVQx]        =   BPCA_config(PARAM, [], pca__Q);
    
    pca                     =   textread(['results2\' trkaRVQx.config_str '.txt']);