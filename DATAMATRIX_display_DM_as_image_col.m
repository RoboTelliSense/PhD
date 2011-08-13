%% Takes a DM2 matrix and displays it as an image.
%
% Assumption is that the data is grayscale.
% 
% Here, the design matrix has observations in each row, that's standard
% however, each observation is an image which was vectorized by stacking
% columns onto each other, not row onto each other
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Date created          : April 5, 2011
% Date last modified    : July 9, 2011.
%%

function DATAMATRIX_display_DM_as_image_col(DM, h, w, numCols) %h and w are snippet height and width
    
    [N, D]                  =   size(DM);  %N: number of training observations, D: dimensionality of data
    
    for n = 1:N
        row_vec             =   DM(n,:);
        img                 =   reshape(row_vec, h, w);
                                UTIL_PLOT_tightsubplot(numCols, n, img)
    end
    
