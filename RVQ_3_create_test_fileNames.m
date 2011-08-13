function [cfn_snr, cfn_stg, cfn_soc] = RVQ_3_create_test_fileNames(dir_out, f)

    str_f               =   UTIL_GetZeroPrefixedFileNumber(f);

    cfn_snr             =   [dir_out str_f   '_9.snr']; 
    cfn_stg             =   [dir_out str_f   '_10.stg'];
    cfn_soc             =   [dir_out str_f   '_11.soc'];    