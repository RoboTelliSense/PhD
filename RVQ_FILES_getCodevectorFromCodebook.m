%% This function returns a codevector from a single channel codebook.
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : July 17, 2011
% Date last modified : July 17, 2011
%%

function CV_Dx1 = RVQ_FILES_getCodevectorFromCodebook(m,p,M,CB_1c)                        

    idx                     =   UTIL_xy_to_idx(m, p, M); 
    CV_Dx1                  =	CB_1c(:,idx);