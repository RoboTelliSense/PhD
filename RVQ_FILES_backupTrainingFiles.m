function RVQ_3_backupTrainingFiles(odir, str_f) 

    %--------------------------------
    %INTIALIZATIONS
    %--------------------------------
        %input filenames
            cfn_poscsv                  =   [odir 'positiveExamples.csv'];               %file 1
            cfn_posraw             		=   [odir 'positiveExamples.raw'];               %file 2
            cfn_ecbk           			=   [odir 'codebook.ecbk'];                      %file 3
            cfn_dcbk           			=   [odir 'codebook.dcbk'];                      %file 4
            cfn_nodes          			=   [odir 'codebook.nodes'];                     %file 5
            cfn_gentxt                  =   [odir 'gen.txt'];                            %file 6
            cfn_bndintxt                =   [odir 'bnd_in.txt'];                         %file 7
            cfn_trgsoc                  =   [odir 'positiveExamples.idx'];               %file 8
 
    %--------------------------------
    %OPERATIONS
    %--------------------------------            
            if (ispc)

                %[status,result] = system(['copy ' cfn_poscsv            ' ' odir str_f '_1_positiveExamples.csv']);      %file 1
                %[status,result] = system(['copy ' cfn_posraw            ' ' odir str_f '_positiveExamples.raw']);      %file 2
                %[status,result] = system(['copy ' cfn_ecbk              ' ' odir str_f '_3_codebook.ecbk']);             %file 3
                %[status,result] = system(['copy ' cfn_dcbk              ' ' odir str_f '_4_codebook.dcbk']);             %file 4
                %[status,result] = system(['copy ' cfn_nodes             ' ' odir str_f '_5_codebook.nodes']);            %file 5
                [status,result] = system(['copy ' cfn_gentxt            ' ' odir str_f '_RVQ_trg_verbose.txt']);                   %file 6
                %[status,result] = system(['copy ' cfn_bndintxt          ' ' odir str_f '_7_bnd_in.txt']);                %file 7
                %[status,result] = system(['copy ' cfn_trgsoc            ' ' odir str_f '_8_positiveExamples.soc']);      %file 8

            elseif (isunix)

                %[status,result] = unix(['cp ' cfn_poscsv                ' ' odir str_f '_1_positiveExamples.csv']);      %file 1
                %[status,result] = unix(['cp ' cfn_posraw                ' ' odir str_f '_positiveExamples.raw']);      %file 2
                %[status,result] = unix(['cp ' cfn_ecbk                  ' ' odir str_f '_3_codebook.ecbk']);             %file 3
                %[status,result] = unix(['cp ' cfn_dcbk                  ' ' odir str_f '_4_codebook.dcbk']);             %file 4
                %[status,result] = unix(['cp ' cfn_nodes                 ' ' odir str_f '_5_codebook.nodes']);            %file 5
                [status,result] = unix(['cp ' cfn_gentxt                ' ' odir str_f '_codebook_verbose.txt']);                   %file 6
                %[status,result] = unix(['cp ' cfn_bndintxt              ' ' odir str_f '_7_bnd_in.txt']);                %file 7
                %[status,result] = unix(['cp ' cfn_trgsoc                ' ' odir str_f '_8_positiveExamples.soc']);      %file 8
            end
            