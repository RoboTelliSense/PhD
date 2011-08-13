function [ix, iy] = UTIL_ROI_convert_outer_to_inner_coordinates(x, y, w, h)
    
    ix = x - (w-1)/2;
    iy = y - (h-1)/2;
