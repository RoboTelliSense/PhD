%% Takes a DM2 matrix and displays it as an image.
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Date created          : April 17, 2011
% Date last modified    : July 9, 2011.
%%

function DATAMATRIX_display_DM2_as_image(DM2, h, w, numRows, numCols, bScale)
    
    [D, N]              	=   size(DM2);  %N: number of training observations, D: dimensionality of data
    
    for n = 1:N
        col_vec         	=   DM2(:,n);
        img             	=   reshape(col_vec, h, w);
								UTIL_PLOT_tightsubplot(numRows, numCols, n, img, bScale);
    end
    