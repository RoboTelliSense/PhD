%% This function shows how to read XDRs from an Explorer generated .idx file
%
% Here, Nii is the number of pixels in the "inner image", i.e. the part of the image not 
% containing boundaries which can be processed.  The size of the boundary is (snippet width-1)/2 on the horizontal 
% edges and (snippet_height-1)/2 on the vertical edges.
% 
% P is the number of stages in the codebook.
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : July 20, 2011
% Date last modified : July 28, 2011
%%


cfn                         =   'referenceRVQ/reference_11_00472_640x480.idx'; %this image is 640x480 but tested pixels are 630x440
tst_XDRs_PxNii              =   RVQ_FILES_read_idx_file(cfn, 8, 2, false) %false for explorer

