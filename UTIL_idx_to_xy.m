%Copyright (C) Salman Aslam.  All rights reserved.
%Date: July 7, 2011.
%%
%Description: 
%- This file takes an index and image width (Iw) and returns (x,y) coordinates.
%%

function [y,x] = UTIL_idx_to_xy(idx, Iw)
    
%go to C style indexing (0-based)
    idx = idx-1;

%compute x, y in C-style
    y = idivide(  int32(idx), int32(Iw), 'floor'  ); 
    x = mod(int32(idx), int32(Iw));

%back to Matlab style (1-based)
    y = y+1;
    x = x+1;
        
    
        
        