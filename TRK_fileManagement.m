function PARAM = TRK_fileManagement(PARAM, INP)

%1. create output directory
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
    PARAM.dir_out_wo_slash ...
                            =   ['results_'                                             ...
                                 INP.ds_3_longName                               ...
                                 '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(PARAM.in_Nw)   ...
                                 '_w_' num2str(PARAM.in_bWeighting)                     ...
                                 '_Np_' UTIL_GetZeroPrefixedFileNumber_4(PARAM.in_Np)   ...
                                 algo_string];
    %add slash                                                
    dir_out                 =   UTIL_addSlash(PARAM.dir_out_wo_slash);   %Windows or Linux style
    PARAM.dir_out          =   dir_out;
    
    %create output directory name    
    mkdir(PARAM.dir_out)

%2. files: ground truth for feature points
    cfn_2_GTFP              =   [dir_out 'featurePts_2_ground_truth.csv'];  UTIL_FILE_delete(cfn_2_GTFP);    

%3. files: rvq, intermediate
    cfn_posraw              =   [dir_out 'positiveExamples.raw'];           UTIL_FILE_delete(cfn_posraw);  
    cfn_poscsv              =   [dir_out 'positiveExamples.csv'];           UTIL_FILE_delete(cfn_poscsv);  
    cfn_dcbk                =   [dir_out 'codebook.dcbk'];                  UTIL_FILE_delete(cfn_dcbk);  
    cfn_gen_txt             =   [dir_out 'gen.txt'];                        UTIL_FILE_delete(cfn_gen_txt);  
    PARAM.cfn_6_numStages=   [dir_out 'rvq__tst_numStages.csv'];            UTIL_FILE_delete(PARAM.cfn_6_numStages);  
    
%4. files: target
    %1. affine ROI
    PARAM.cfn_1_aff_abcdxy_1x6=   [dir_out 'aff_abcdxy_1x6_1_ipca.csv'];      UTIL_FILE_delete(PARAM.cfn_1_aff_abcdxy_1x6);
    PARAM.cfn_1_aff_abcdxy_1x6=   [dir_out 'aff_abcdxy_1x6_1_bpca.csv'];      UTIL_FILE_delete(PARAM.cfn_1_aff_abcdxy_1x6);
    PARAM.cfn_1_aff_abcdxy_1x6=   [dir_out 'aff_abcdxy_1x6_1_rvq.csv'];       UTIL_FILE_delete(PARAM.cfn_1_aff_abcdxy_1x6);
    PARAM.cfn_1_aff_abcdxy_1x6=   [dir_out 'aff_abcdxy_1x6_1_tsvq.csv'];      UTIL_FILE_delete(PARAM.cfn_1_aff_abcdxy_1x6);
    
    %2. feature points
    PARAM.cfn_2_FP       =   [dir_out 'featurePts_2_ipca.csv'];             UTIL_FILE_delete(PARAM.cfn_2_FP);  
    PARAM.cfn_2_FP       =   [dir_out 'featurePts_2_bpca.csv'];             UTIL_FILE_delete(PARAM.cfn_2_FP);
    PARAM.cfn_2_FP       =   [dir_out 'featurePts_2_rvq.csv'];              UTIL_FILE_delete(PARAM.cfn_2_FP);  
    PARAM.cfn_2_FP       =   [dir_out 'featurePts_2_tsvq.csv'];             UTIL_FILE_delete(PARAM.cfn_2_FP);  
        
%5. files: error   
    %feature points (i.e. tracking)
    PARAM.cfn_3_trk_rmse =   [dir_out 'errFeaturePts_3_ipca.csv'];          UTIL_FILE_delete(PARAM.cfn_3_trk_rmse);      
    PARAM.cfn_3_trk_rmse =   [dir_out 'errFeaturePts_3_bpca.csv'];          UTIL_FILE_delete(PARAM.cfn_3_trk_rmse);   
    PARAM.cfn_3_trk_rmse =   [dir_out 'errFeaturePts_3_rvq.csv'];           UTIL_FILE_delete(PARAM.cfn_3_trk_rmse);      
    PARAM.cfn_3_trk_rmse =   [dir_out 'errFeaturePts_3_tsvq.csv'];          UTIL_FILE_delete(PARAM.cfn_3_trk_rmse);
    
    %training
    PARAM.cfn_4_trg_rmse =   [dir_out 'errTrg_4_ipca.csv'];                 UTIL_FILE_delete(PARAM.cfn_4_trg_rmse);
    PARAM.cfn_4_trg_rmse =   [dir_out 'errTrg_4_bpca.csv'];                 UTIL_FILE_delete(PARAM.cfn_4_trg_rmse);      
    PARAM.cfn_4_trg_rmse =   [dir_out 'errTrg_4_rvq.csv'];                  UTIL_FILE_delete(PARAM.cfn_4_trg_rmse);      
    PARAM.cfn_4_trg_rmse =   [dir_out 'errTrg_4_tsvq.csv'];                 UTIL_FILE_delete(PARAM.cfn_4_trg_rmse);          
       
    %test
    PARAM.cfn_5_tst_rmse =   [dir_out 'errTst_5_ipca.csv'];                 UTIL_FILE_delete(PARAM.cfn_5_tst_rmse);      
    PARAM.cfn_5_tst_rmse =   [dir_out 'errTst_5_bpca.csv'];                 UTIL_FILE_delete(PARAM.cfn_5_tst_rmse);      
    PARAM.cfn_5_tst_rmse =   [dir_out 'errTst_5_rvq.csv'];                  UTIL_FILE_delete(PARAM.cfn_5_tst_rmse);   
    PARAM.cfn_5_tst_rmse =   [dir_out 'errTst_5_tsvq.csv'];                 UTIL_FILE_delete(PARAM.cfn_5_tst_rmse);  