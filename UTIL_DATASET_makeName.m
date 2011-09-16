%w=0 : no weighting
%w=1 : weighting

function [  txt_overall_config ...
            dir_out_wo_slash ...
            dir_out] = UTIL_DATASET_makeName(PARAM.ds_3_longName, bUseBPCA , bUseTSVQ, bUseRVQ1, bUseRVQ2, Np, Nw, w, ipca_Neig, bpca_Neig, rvq_maxT, rvq_S, rvq_targetSNR, tsvq_T)

    %overall configuration
        txt_overall_config              =   ['results_'   PARAM.ds_3_longName '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_' num2str(w) '_Np_' UTIL_GetZeroPrefixedFileNumber_4(Np)];   
    
    %algorithm specific configuration
        txt_algo_config                 =   [];
                        txt_algo_config =   [txt_algo_config '__iPCA_'  UTIL_GetZeroPrefixedFileNumber_3(ipca_Neig)];
        if  (bUseBPCA )  txt_algo_config =   [txt_algo_config '__bPCA_'  UTIL_GetZeroPrefixedFileNumber_3(bpca_Neig)];                                                                                                   end
        if  (bUseRVQ1)  txt_algo_config =   [txt_algo_config '__RVQ__'  UTIL_GetZeroPrefixedFileNumber_2(rvq_maxT) '_' UTIL_GetZeroPrefixedFileNumber_2(rvq_S) '_'  UTIL_GetZeroPrefixedFileNumber_4(rvq_targetSNR)];   end
        if  (bUseRVQ2)  txt_algo_config =   [txt_algo_config '__RVQ2_'  UTIL_GetZeroPrefixedFileNumber_2(rvq_maxT) '_' UTIL_GetZeroPrefixedFileNumber_2(rvq_S) '_'  UTIL_GetZeroPrefixedFileNumber_4(rvq_targetSNR)];   end
        if  (bUseTSVQ)  txt_algo_config =   [txt_algo_config '__TSVQ_'  UTIL_GetZeroPrefixedFileNumber_2(tsvq_T)];                                                                                                      end

    %final directory name
        dir_out_wo_slash                =   [txt_overall_config txt_algo_config];
        dir_out                         =   UTIL_addSlash(dir_out_wo_slash);
    
    %make directory
        if (~exist(dir_out,'dir'))
            mkdir(dir_out)
        end
