function abcdxy     =   UTIL_2D_affine_Ha_2x3_to_abcdxy(Ha_2x3)
    
    a                       =   Ha_2x3(1,1);
    b                       =   Ha_2x3(1,2);
    tx                      =   Ha_2x3(1,3);
    
    c                       =   Ha_2x3(2,1);
    d                       =   Ha_2x3(2,2);
    ty                      =   Ha_2x3(2,3);
    
    abcdxy                  =   [a b c d tx ty];
    
    