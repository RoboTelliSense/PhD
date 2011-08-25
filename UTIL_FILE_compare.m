function bSame = UTIL_file_compare(dir_out, cfn_1, cfn_2)
    
    %filenames
        cfn_cmp         =   [dir_out 'fileCompareResults.txt'];
        cfn_py          =   [dir_out 'fileCompareScript.py'];    
                            UTIL_FILE_delete(cfn_cmp);

    %write script to file
        cmd             =   ['b=filecmp.cmp(' '"' cfn_1 '"' ', ' '"' cfn_2 '"' ')'];
        fid             =   fopen(cfn_py, 'wt');
                            fprintf(fid, 'import filecmp\n');
                            fprintf(fid, '%s\n', cmd);
                            fprintf(fid, 'print b');

    %run the script
                            system(['python ' cfn_py ' >> ' cfn_cmp]);
                    
    %read results
        python_result   =   textread(cfn_cmp, '%s');
        if (strcmp(python_result, 'True'))
            bSame = 1;
        else
            bSame = 0;
        end