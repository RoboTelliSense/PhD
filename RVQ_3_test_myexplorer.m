%this uses my modifications of Explorer.
%the newer version is written entirely in Matlab.
function [NSR, STG] = RVQ_2_test_old(dir_out, cfn_Iraw, f, iw, ih, sw, sh, M, T, bVisualize, bVerbose)

            str_f                   =   UTIL_GetZeroPrefixedFileNumber(f);
                           

    %---------------
    %INITIALIZATIONS
    %---------------
        %filenames
            cfn_ecbk                =   [dir_out 'codebook.ecbk'];                    %file 3
            cfn_dcbk                =   [dir_out 'codebook.dcbk'];                    %file 4
            cfn_nodes               =   [dir_out 'codebook.nodes'];                   %file 5
            cfn_output_prefix       =   [dir_out str_f];
           
            
    %---------------
    %OPERATIONS
    %---------------
            if (ispc)
                system(['RVQ_2_test.exe '    cfn_Iraw ' ' cfn_ecbk ' ' cfn_dcbk ' ' cfn_nodes ' ' num2str(M) ' ' num2str(iw) ' ' num2str(ih) ' ' num2str(sw) ' '  num2str(sh) ' ' cfn_output_prefix ' '  num2str(bVerbose)] );
            elseif (isunix)
                unix(['./RVQ_2_test.linux '  cfn_Iraw ' ' cfn_ecbk ' ' cfn_dcbk ' ' cfn_nodes ' ' num2str(M) ' ' num2str(iw) ' ' num2str(ih) ' ' num2str(sw) ' '  num2str(sh) ' ' cfn_output_prefix ' '  num2str(bVerbose)] );
            end
            
    %---------------
    %RESULTS
    %---------------
                str_f               =   UTIL_GetZeroPrefixedFileNumber   (f);
                cfn_nsr             =   [dir_out str_f '_9.nsr'];
                cfn_stg             =   [dir_out str_f '_10.stg'];
                %cfn_soc             =   [dir_out str_f '_11.soc'];

                NSR                 =   RVQ_FILES_read_cor_file         (cfn_nsr, iw, ih, sw, sh);                         
                STG                 =   RVQ_FILES_read_stg_file         (cfn_stg, iw, ih, sw, sh, T); 
    
    %        [NSR, STG, SOC] = RVQ_3_readTestingFiles(dir_out, f, iw, ih, sw, sh, M, T, bVisualize);