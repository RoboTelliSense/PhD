%% This function reads decoder SNR values from gen.exe's chatter file. 
% 
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : April 10, 2011
% Date last modified : July 20, 2011
%%

function decoder_SNR_dB = RVQ_FILES_read_dSNR_from_genstat_file(cfn_gen_txt)

    match_str = 'dSNR=(\d+.\d+)';
    %match_str = 'Decoder:RelChg=\+\d+.\d+:dSNR=(\d+.\d+):dRMSE=  \d+.+\d+';
    fid = fopen(cfn_gen_txt);
    tline = '';

    while ischar(tline)
        tline = fgets(fid);
        if (isstr(tline))
            if (regexp(tline, match_str));
                a=regexp(tline, match_str, 'tokens');
            end
        end
    end
    decoder_SNR_dB  = str2num(a{1}{1});
    fclose(fid);

 


