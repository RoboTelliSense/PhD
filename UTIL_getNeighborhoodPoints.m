function [Sx, Sy] = UTIL_getNeighborhoodPoints(cx, cy, sNx, sNy) 


    left_x      =   cx - ((sNx-1)/2);
    right_x     =   cx + ((sNx-1)/2); 
    top_y       =   cy - ((sNy-1)/2);
    bottom_y    =   cy + ((sNy-1)/2);
    
    Sx = [left_x : right_x  ];
    Sy = [top_y :  bottom_y ];