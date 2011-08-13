%% This function computes snippet coordinates.
%
% cx: snippet center, x coordinate
% cy: snippet center, y coordinate
% sw: snippet width (filter width)
% sh: snippet height (filter height)
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : July 24, 2011
% Date last modified : July 24, 2011
%%

function dims     =   RVQ_UTIL_givenSnippetCenterFindDimensions(cx, cy, sw, sh)

    dims.half_w             =   (sw-1)/2;
    dims.half_h             =   (sh-1)/2;
    
    dims.left_x             =   cx - dims.half_w;
    dims.right_x            =   cx + dims.half_w;
    
    dims.top_y              =   cy - dims.half_h;
    dims.bottom_y           =   cy + dims.half_h;