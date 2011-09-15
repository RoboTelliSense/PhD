function Ha_2x3 = UTIL_2D_affine_Ha_2x3_from_abcdxy(abcdxy)

    a                       =   abcdxy(1);
    b                       =   abcdxy(2);
    c                       =   abcdxy(3);
    d                       =   abcdxy(4);
    tx                      =   abcdxy(5);
    ty                      =   abcdxy(6);
    
    Ha_2x3                  =   [a b tx;...  
                                 c d ty];
