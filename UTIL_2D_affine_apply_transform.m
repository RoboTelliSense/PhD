function [X_1xN, Y_1xN]     =   UTIL_2D_affine_apply_transform(Ha_2x3, x_1xN, y_1xN)

    N                       =   length(x_1xN);
    
    %put into 3xN matrix
    inppoints_xy1_3xN       =   [   x_1xN ; ...      
                                    y_1xN ; ...
                                    ones(1,N)]; 
    %transform
    outpoints_xy_2xN        =   Ha_2x3 * inppoints_xy1_3xN;   %transform to new coordinates  
    
    %pull out of matrix
    X_1xN                   =   outpoints_xy_2xN(1,:);       
    Y_1xN                   =   outpoints_xy_2xN(2,:);

    
