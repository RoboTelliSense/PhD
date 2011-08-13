%% This function shows how to read XDRs from a Linker generated .idx file
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : July 20, 2011
% Date last modified : July 20, 2011
%%

cfn                         =   'referenceRVQ/reference_8_snippets.idx'
training_XDRs               =   RVQ_FILES_read_idx_file(cfn, 8, 2, true)
    
                    