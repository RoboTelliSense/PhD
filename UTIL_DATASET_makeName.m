%w=0 : no weighting
%w=1 : weighting

function [  txt_overall_config ...
            config_name ...
            odir] = UTIL_DATASET_makeName(PARAM.ds_3_name, bUseBPCA , bUseTSVQ, bUseRVQx1, bUseRVQx2, Np, Nw, w, ipca_Neig, bpca_Neig, rvq_maxT, rvq_S, rvq__targetSNR, tsvq_T)

    %overall configuration
        txt_overall_config              =   ['results_'   PARAM.ds_3_name '_Nw_' UTIL_GetZeroPrefixedFileNumber_4(Nw) '_w_' num2str(w) '_Np_' UTIL_GetZeroPrefixedFileNumber_4(Np)];   
    
    %algorithm specific configuration
        txt_algo_config                 =   [];
                        txt_algo_config =   [txt_algo_config '__iPCA_'  UTIL_GetZeroPrefixedFileNumber_3(ipca_Neig)];
        if  (bUseBPCA )  txt_algo_config =   [txt_algo_config '__bPCA_'  UTIL_GetZeroPrefixedFileNumber_3(bpca_Neig)];                                                                                                   end
        if  (bUseRVQx1)  txt_algo_config =   [txt_algo_config '__RVQ__'  UTIL_GetZeroPrefixedFileNumber_2(rvq_maxT) '_' UTIL_GetZeroPrefixedFileNumber_2(rvq_S) '_'  UTIL_GetZeroPrefixedFileNumber_4(rvq__targetSNR)];   end
        if  (bUseRVQx2)  txt_algo_config =   [txt_algo_config '__RVQ2_'  UTIL_GetZeroPrefixedFileNumber_2(rvq_maxT) '_' UTIL_GetZeroPrefixedFileNumber_2(rvq_S) '_'  UTIL_GetZeroPrefixedFileNumber_4(rvq__targetSNR)];   end
        if  (bUseTSVQ)  txt_algo_config =   [txt_algo_config '__TSVQ_'  UTIL_GetZeroPrefixedFileNumber_2(tsvq_T)];                                                                                                      end

    %final directory name
        config_name                =   [txt_overall_config txt_algo_config];
        odir                         =   UTIL_addSlash(config_name);
    
    %make directory
        if (~exist(odir,'dir'))
            mkdir(odir)
        end
