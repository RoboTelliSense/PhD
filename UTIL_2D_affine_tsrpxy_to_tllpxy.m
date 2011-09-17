function tllpxy = UTIL_2D_affine_tsrpxy_to_tllpxy(tsrpxy) %tsrpxy: lambda1, lambda2, theta, phi, tx, ty

    theta                   =   tsrpxy(1);
    s                       =   tsrpxy(2);
    r                       =   tsrpxy(3);
    phi                     =   tsrpxy(4);
    tx                      =   tsrpxy(5);
    ty                      =   tsrpxy(6);
    
    lambda1                 =   s;
    lambda2                 =   r*s;
    
    tllpxy                  =   [theta lambda1 lambda2 phi tx ty];