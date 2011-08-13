function [x, y] = UTIL_ROI_convert_inner_to_outer_coordinates(ix, iy, w, h)
    
    x = ix + (w-1)/2;
    y = iy + (h-1)/2;