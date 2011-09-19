function Ha_2x3 = UTIL_2D_affine_xywht_to_Ha_2x3(xywht)

%step 1: entry point is tllpxy
    tllpxy                  =   UTIL_2D_affine_xywht_to_tllpxy(xywht);
    
%step 2: abcdxy    
    abcdxy                  =   UTIL_2D_affine_tllpxy_to_abcdxy(tllpxy);

%step 3: Ha_2x3    
    Ha_2x3                  =   UTIL_2D_affine_abcdxy_to_Ha_2x3(abcdxy);