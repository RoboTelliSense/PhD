function config_name        =   UTIL_TRK_create_config_string(PARAM)

    algo_string_IPCA        =   [];
    algo_string_BPCA        =   [];
    algo_string_RVQ         =   [];
    algo_string_TSVQ        =   [];
    
%put algorithm parameters in a string
    if  (PARAM.in_bUseIPCA )  
        algo_string_IPCA    =   ['__IPCA_'   UTIL_GetZeroPrefixedFileNumber_3(PARAM.in_pca_P)];
    end
    if  (PARAM.in_bUseBPCA )  
        algo_string_BPCA    =   ['__BPCA_'   UTIL_GetZeroPrefixedFileNumber_3(PARAM.in_pca_P)];                                                                                                   
    end
    if  (PARAM.in_bUseRVQ)   
        algo_string_RVQ     =   ['__RVQ__'   UTIL_GetZeroPrefixedFileNumber_2(PARAM.in_rvq_maxP)  '_' ...
                                             UTIL_GetZeroPrefixedFileNumber_2(PARAM.in_rvq_M)     '_' ...
                                             UTIL_GetZeroPrefixedFileNumber_4(PARAM.in_rvq_targetSNR)];   
    end
    if  (PARAM.in_bUseTSVQ)  
        algo_string_TSVQ    =   ['__TSVQ_'   UTIL_GetZeroPrefixedFileNumber_2(PARAM.in_tsvq_P)    '_' ...
                                             UTIL_GetZeroPrefixedFileNumber_2(PARAM.in_tsvq_M)];                                                                                                      
    end

    %add prefix, global options
    config_name             =   ['results_'                                             ...
                                 PARAM.ds_3_longName                                    ...
                                 algo_string_IPCA                                       ...
                                 algo_string_BPCA                                       ...
                                 algo_string_RVQ                                        ...
                                 algo_string_TSVQ] ;