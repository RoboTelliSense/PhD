function PARAM = UTIL_TRK_create_config_string(PARAM)

%put algorithm parameters in a string
    if  (PARAM.in_bUseIPCA )  
        algo_string         =   ['__iPCA_'   UTIL_GetZeroPrefixedFileNumber_3(PARAM.in_pca_P)];
    end
    if  (PARAM.in_bUseBPCA )  
        algo_string         =   ['__bPCA_'   UTIL_GetZeroPrefixedFileNumber_3(PARAM.in_pca_P)];                                                                                                   
    end
    if  (PARAM.in_bUseRVQ)   
        algo_string         =   ['__RVQ__'   UTIL_GetZeroPrefixedFileNumber_2(PARAM.in_rvq_maxP)  '_' ...
                                             UTIL_GetZeroPrefixedFileNumber_2(PARAM.in_rvq_M)     '_' ...
                                             UTIL_GetZeroPrefixedFileNumber_4(PARAM.in_rvq_targetSNR)];   
    end
    if  (PARAM.in_bUseTSVQ)  
        algo_string         =   ['__TSVQ_'   UTIL_GetZeroPrefixedFileNumber_2(PARAM.in_tsvq_P)];                                                                                                      
    end

    %add prefix, global options
    PARAM.config_name ...
                            =   ['results_'                                             ...
                                 PARAM.ds_3_longName                               ...
                                 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(PARAM.in_Nw)   ...
                                 '_w_' num2str(PARAM.in_bWeighting)                     ...
                                 '_Np_' UTIL_GetZeroPrefixedFileNumber_4(PARAM.in_Np)   ...
                                 algo_string];
%create output directory
    PARAM.PARAM.odir     =   UTIL_addSlash(PARAM.config_name; %make directory name from algo parameters (i.e., add slash)
    mkdir(PARAM.PARAM.odir)

%3. files: rvq, intermediate
    cfn_posraw              =   [PARAM.odir 'positiveExamples.raw'];             UTIL_FILE_delete(cfn_posraw);  
    cfn_poscsv              =   [PARAM.odir 'positiveExamples.csv'];             UTIL_FILE_delete(cfn_poscsv);  
    cfn_dcbk                =   [PARAM.odir 'codebook.dcbk'];                    UTIL_FILE_delete(cfn_dcbk);  
    cfn_gen_txt             =   [PARAM.odir 'gen.txt'];                          UTIL_FILE_delete(cfn_gen_txt);  
    PARAM.cfn_6_numStages   =   [PARAM.odir 'rvq__tst_numStages.csv'];           UTIL_FILE_delete(PARAM.cfn_6_numStages);  
    UTIL_FILE_delete(PARAM.cfn_5_tst_rmse);  