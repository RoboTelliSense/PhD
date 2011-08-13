function [cfn_I, cfn_dcbk_fm1, cfn_dcbk_f] = RVQ_3_createFileNames(dir_out, dir_I, ext_I, f)

                str_f               =   UTIL_GetZeroPrefixedFileNumber(f);
                str_fm1             =   UTIL_GetZeroPrefixedFileNumber(f-1);
                
                cfn_I               =   [dir_I   str_f  ext_I];
                cfn_dcbk_fm1        =   [dir_out str_fm1 '_4_codebook.dcbk'];  %filename for codebooks at frame f-1
                cfn_dcbk_f          =   [dir_out str_f   '_4_codebook.dcbk'];  %filename for codebooks at frame f   
                %cfn_lhood           =   [dir_out str_f   '_12.ll'];