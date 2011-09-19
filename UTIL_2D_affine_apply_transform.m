function XY_2xN             =   UTIL_2D_affine_apply_transform(Ha_2x3, xy_2xN)

    [temp, N]               =   size(xy_2xN);
    
    %add a row of 1's
    xy1_3xN                 =   [   xy_2xN ; ...      
                                    ones(1,N)]; 
    %transform
    XY_2xN                  =   Ha_2x3 * xy1_3xN;   %transform to new coordinates  
    

    
