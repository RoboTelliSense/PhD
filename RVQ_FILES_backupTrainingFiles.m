function RVQ_3_backupTrainingFiles(dir_out, str_f) 

    %--------------------------------
    %INTIALIZATIONS
    %--------------------------------
        %input filenames
            cfn_poscsv                  =   [dir_out 'positiveExamples.csv'];               %file 1
            cfn_posraw             		=   [dir_out 'positiveExamples.raw'];               %file 2
            cfn_ecbk           			=   [dir_out 'codebook.ecbk'];                      %file 3
            cfn_dcbk           			=   [dir_out 'codebook.dcbk'];                      %file 4
            cfn_nodes          			=   [dir_out 'codebook.nodes'];                     %file 5
            cfn_gentxt                  =   [dir_out 'gen.txt'];                            %file 6
            cfn_bndintxt                =   [dir_out 'bnd_in.txt'];                         %file 7
            cfn_trgsoc                  =   [dir_out 'positiveExamples.idx'];               %file 8
 
    %--------------------------------
    %OPERATIONS
    %--------------------------------            
            if (ispc)

                %[status,result] = system(['copy ' cfn_poscsv            ' ' dir_out str_f '_1_positiveExamples.csv']);      %file 1
                %[status,result] = system(['copy ' cfn_posraw            ' ' dir_out str_f '_positiveExamples.raw']);      %file 2
                %[status,result] = system(['copy ' cfn_ecbk              ' ' dir_out str_f '_3_codebook.ecbk']);             %file 3
                %[status,result] = system(['copy ' cfn_dcbk              ' ' dir_out str_f '_4_codebook.dcbk']);             %file 4
                %[status,result] = system(['copy ' cfn_nodes             ' ' dir_out str_f '_5_codebook.nodes']);            %file 5
                [status,result] = system(['copy ' cfn_gentxt            ' ' dir_out str_f '_RVQ_trg_verbose.txt']);                   %file 6
                %[status,result] = system(['copy ' cfn_bndintxt          ' ' dir_out str_f '_7_bnd_in.txt']);                %file 7
                %[status,result] = system(['copy ' cfn_trgsoc            ' ' dir_out str_f '_8_positiveExamples.soc']);      %file 8

            elseif (isunix)

                %[status,result] = unix(['cp ' cfn_poscsv                ' ' dir_out str_f '_1_positiveExamples.csv']);      %file 1
                %[status,result] = unix(['cp ' cfn_posraw                ' ' dir_out str_f '_positiveExamples.raw']);      %file 2
                %[status,result] = unix(['cp ' cfn_ecbk                  ' ' dir_out str_f '_3_codebook.ecbk']);             %file 3
                %[status,result] = unix(['cp ' cfn_dcbk                  ' ' dir_out str_f '_4_codebook.dcbk']);             %file 4
                %[status,result] = unix(['cp ' cfn_nodes                 ' ' dir_out str_f '_5_codebook.nodes']);            %file 5
                [status,result] = unix(['cp ' cfn_gentxt                ' ' dir_out str_f '_codebook_verbose.txt']);                   %file 6
                %[status,result] = unix(['cp ' cfn_bndintxt              ' ' dir_out str_f '_7_bnd_in.txt']);                %file 7
                %[status,result] = unix(['cp ' cfn_trgsoc                ' ' dir_out str_f '_8_positiveExamples.soc']);      %file 8
            end
            