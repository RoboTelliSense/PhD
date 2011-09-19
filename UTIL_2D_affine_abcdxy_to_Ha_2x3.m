function Ha_2x3 = UTIL_2D_affine_abcdxy_to_Ha_2x3(abcdxy)

    a                       =   abcdxy(1);
    b                       =   abcdxy(2);
    c                       =   abcdxy(3);
    d                       =   abcdxy(4);
    tx                      =   abcdxy(5);
    ty                      =   abcdxy(6);
    
    Ha_2x3                  =   [a b tx;...  
                                 c d ty];
