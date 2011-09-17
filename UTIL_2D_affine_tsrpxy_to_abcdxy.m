function abcdxy = UTIL_2D_affine_tsrpxy_to_abcdxy(tsrpxy)
    
    tllpxy                  =   UTIL_2D_affine_tsrpxy_to_tllpxy(tsrpxy);
    abcdxy                  =   UTIL_2D_affine_tllpxy_to_abcdxy(tllpxy);
