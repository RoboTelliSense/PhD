%% This function reads values from gen.exe's chatter file. 
% 
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : April 10, 2011
% Date last modified : Oct 6, 2011
%%

function out = RVQ_FILES_read_from_genstat_file(cfn_gen_txt, val)

    out=[];
    
    
    match_stg = 'Seeding Stage #(\d+)';  %stage number
    
    %match string
    if      (val==1) match_str = 'Decoder:RelChg=\+\d+.\d+:dSNR=(\d+.\d+):dRMSE=  \d+.+\d+';  %read dSNR
    elseif  (val==2) match_str = 'Decoder:RelChg=\+\d+.\d+:dSNR=\d+.\d+:dRMSE=  (\d+.+\d+)';  %read dRMSE
    elseif  (val==3) match_str = 'Encoder:RelChg=\+\d+.\d+:eSNR=(\d+.\d+):eRMSE=  \d+.+\d+:sws=\d+'; %read eSNR (not tested) 
    elseif  (val==4) match_str = 'Encoder:RelChg=\+\d+.\d+:eSNR=\d+.\d+:eRMSE=  (\d+.+\d+):sws=\d+'; %read eRMSE
    elseif  (val==5) match_str = 'dSNR=(\d+.\d+)';
    end
    
    fid = fopen(cfn_gen_txt);
    tline = '';

    idx=1;
    while ischar(tline)
        tline = fgets(fid);
        if (isstr(tline))
            if (regexp(tline, match_stg));
                a=regexp(tline, match_stg, 'tokens');
                stg=str2num(a{1}{1});
            end            
            if (regexp(tline, match_str));
                a=regexp(tline, match_str, 'tokens');
                out(idx,1)= stg;
                out(idx,2)=str2num(a{1}{1});
                idx=idx+1;
            end
        end
    end
    fclose(fid);

 


