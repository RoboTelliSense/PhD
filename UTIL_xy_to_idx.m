function idx = UTIL_xy_to_idx(x,y, stride)
    
    idx = int32((y-1)*stride + x); 
    