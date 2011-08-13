%% This function computes the inner dimensions of an image, i.e., the
%% dimensions of the image to which a 2D filter can be applied.  We have to
%% do this because border pixels cannot be filtered
%
% iw: image width
% ih: image height
% sw: snippet width (filter width)
% sh: snippet height (filter height)
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : July 24, 2011
% Date last modified : July 24, 2011
%%

function dims = RVQ_UTIL_computeInnerPixels2(iw, ih, sw, sh)
 
    dims.half_w             =   (sw-1)/2;
    dims.half_h             =   (sh-1)/2;
    
    dims.left_x             =   dims.half_w + 1;       %so if sw is 11, then left_x is 6                    
    dims.right_x            =   iw - dims.half_w;      %so for image width=15, right_x = 10    
    
    dims.top_y              =   dims.half_h + 1;       
    dims.bottom_y           =   ih - dims.half_h;      
    
    dims.inner_width        =   dims.right_x  - dims.left_x + 1;
    dims.inner_height       =   dims.bottom_y - dims.top_y + 1;
    
    