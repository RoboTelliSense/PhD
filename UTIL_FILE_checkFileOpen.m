%% This function throws an exception if the fileID is invalid, i.e. -1

% Copyright (C) Salman Aslam.  All rights reserved.
% Date created          : Feb 19, 2011
% Date last modified    : July 9, 2011.
%%

function UTIL_FILE_checkFileOpen(fid, cfn)

    try
        if (fid == -1)
            err = MException('ResultChk:FileNotOpen', ['salman: ' cfn ' could not be opened']);
            throw(err);
        end
        
    catch err
        disp(err.message);
        rethrow(err);
    end  
                                                