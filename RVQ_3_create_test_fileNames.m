function [cfn_snr, cfn_stg, cfn_soc] = RVQ_3_create_test_fileNames(odir, f)

    str_f               =   UTIL_GetZeroPrefixedFileNumber(f);

    cfn_snr             =   [odir str_f   '_9.snr']; 
    cfn_stg             =   [odir str_f   '_10.stg'];
    cfn_soc             =   [odir str_f   '_11.soc'];    