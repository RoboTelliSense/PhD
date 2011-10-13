%% This function reads values from gen.exe's chatter file. 
% 
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : April 10, 2011
% Date last modified : Oct 6, 2011
%%

function [out out2] = RVQ_FILES_read_from_genstat_file(cfn_gen_txt, val)

    out=[];
    
    
    match_stg = 'Seeding Stage #(\d+)';  %stage number
    
    %match string
    
    if      (val==1) match_str = 'Encoder:RelChg=\+\d+.\d+:eSNR=\d+.\d+:eRMSE=\s+(\d+.+\d+):sws=\d+'; %1. read eRMSE
    elseif  (val==2) match_str = 'Encoder:RelChg=\+\d+.\d+:eSNR=(\d+.\d+):eRMSE=\s+\d+.+\d+:sws=\d+'; %2. read eSNR (not tested)    
    
    elseif  (val==3) match_str = 'Decoder:RelChg=\+\d+.\d+:dSNR=\d+.\d+:dRMSE=\s+(\d+.+\d+)';        %3. read dRMSE
    elseif  (val==4) match_str = 'Decoder:RelChg=\+\d+.\d+:dSNR=(\d+.\d+):dRMSE=\s+\d+.+\d+';        %4. read dSNR 
        
    elseif  (val==5) match_str = 'dSNR=(\d+.\d+)';
    end
    
    fid = fopen(cfn_gen_txt);
    tline = '';

    idx=1;
    while ischar(tline)
        tline = fgets(fid);
        if (isstr(tline))
            if (regexp(tline, match_stg));              %get stage number
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

    [R, C]= size(out);
    idx=0;
    for r=2:R
        first = out(r-1,1);
        second = out(r,1);
        if (first ~= second)
            idx=idx+1;
            out2(idx,:) = out(r-1,:);
        end
    end
    
    idx=idx+1;
    out2(idx,:) = out(end,:)


