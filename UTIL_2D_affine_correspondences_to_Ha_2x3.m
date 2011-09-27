%XY_2xN = Ha_2x3 xy_2xN
function Ha_2x3 = UTIL_2D_affine_correspondences_to_Ha_2x3(xy_2xN, XY_2xN)

    x_1xN                   =   xy_2xN(1,:); 
    y_1xN                   =   xy_2xN(2,:);
    
    X_1xN                   =   XY_2xN(1,:); 
    Y_1xN                   =   XY_2xN(2,:);

    H                       =   [x_1xN' y_1xN' ones(size(x_1xN))'];
    
    abx_3x1                 =   UTIL_MT_least_squares(H, X_1xN');
    cdy_3x1                 =   UTIL_MT_least_squares(H, Y_1xN');
    
    a                       =   abx_3x1(1);
    b                       =   abx_3x1(2);
    tx                      =   abx_3x1(3);
    
    c                       =   cdy_3x1(1);
    d                       =   cdy_3x1(2);
    ty                      =   cdy_3x1(3);
    
    abcdxy                  =   [a b c d tx ty];
    
    Ha_2x3                  =   UTIL_2D_affine_abcdxy_to_Ha_2x3(abcdxy);
    