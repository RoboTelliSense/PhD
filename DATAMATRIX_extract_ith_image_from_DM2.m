%% This function assumes that each column of the input matrix (DM2) is an
%% image.  It extracts a given column and returns it as an image.
% 
% Copyright (C) Salman Aslam.  All rights reserved.
% Date created          : April 17, 2011
% Date last modified    : July 9, 2011.
%%

function I_h_x_w = DATAMATRIX_extract_ith_image_from_DM2(DM2, col, w, h)
    
    I_Dx1                   =   DM2(:,col);               %extract D-dimensional column 
    I_h_x_w                 =   reshape(I_Dx1, h, w);     %reshape as an image and return