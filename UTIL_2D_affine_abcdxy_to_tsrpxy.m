function tsrpxy = UTIL_2D_affine_abcdxy_to_tsrpxy(abcdxy)
    
    tllpxy                  =   UTIL_2D_affine_abcdxy_to_tllpxy(abcdxy);
    tsrpxy                  =   UTIL_2D_affine_tllpxy_to_tsrpxy(tllpxy);