function Ha_2x3 = UTIL_2D_affine_xywht_to_Ha_2x3(xywht, scale)

%step 1: entry point is tsrpxy
    tsrpxy                  =   UTIL_2D_affine_xywht_to_tsrpxy(xywht, scale);
    
%step 2: abcdxy    
    abcdxy                  =   UTIL_2D_affine_tsrpxy_to_abcdxy(tsrpxy);

%step 3: Ha_2x3    
    Ha_2x3                  =   UTIL_2D_affine_abcdxy_to_Ha_2x3(abcdxy);