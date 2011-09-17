function tsrpxy = UTIL_2D_affine_tllpxy_to_tsrpxy(tllpxy) %tllpxy: lambda1, lambda2, theta, phi, tx, ty

    theta                   =   tllpxy(1);
    lambda1                 =   tllpxy(2);
    lambda2                 =   tllpxy(3);
    phi                     =   tllpxy(4);
    tx                      =   tllpxy(5);
    ty                      =   tllpxy(6);
    
    s                       =   lambda1;
    r                       =   lambda2/lambda1;
    
    tsrpxy                  =   [theta s r phi tx ty];
