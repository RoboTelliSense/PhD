function [x_1xN, y_1xN]     =   UTIL_2D_affine_apply_inverse_transform(H_2x3, X_1xN, Y_1xN)

    N                       =   length(x_1xN);
    T_2x1                   =   H_2x3(:,3);
    A_2x2                   =   H_2x3(1:2,1:2);
    
    %put into 3xN matrix
    inppoints_xy1_2xN       =   [   X_1xN ; ...      
                                    Y_1xN ]; 
    %transform
    temp_2xN                =   inppoints_xy1_2xN - repmat(T_2x1, 1, N);
    
    outpoints_xy_2xN        =   inv(A_2x2) * temp_2xN;   %transform to new coordinates  
    
    %pull out of matrix
    x_1xN                   =   outpoints_xy_2xN(1,:);       
    y_1xN                   =   outpoints_xy_2xN(2,:);