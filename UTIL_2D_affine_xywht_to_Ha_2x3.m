function Ha_2x3 = UTIL_2D_affine_xywht_to_Ha_2x3(xywht)

%specifying target, step 1: xywht    
    xywht(1)                =   xywht(1) + xywht(3)/2;  %x coordinate of center of bounding box
    xywht(2)                =   xywht(2) + xywht(4)/2;  %y      "      "    "    "     "     " 
    
%specifying target, step 2: tllpxy    
    tllpxy(1)               =   xywht(5);               %theta 
    tllpxy(2)               =   xywht(3)/32;            %lambda1 
    tllpxy(3)               =   xywht(4)/32;            %lambda2 (should be same as sh)     
                                                        %the divider in these 2 lines above should be the same as sw and sh respectively.  
                                                        %here slightly different as explained in report,  but basically negligible bug! 
                                                        %keeping it to remain compatible with thesis
    tllpxy(4)               =   0;                      %phi
    tllpxy(5)               =   xywht(1);               %tx
    tllpxy(6)               =   xywht(2);               %ty tllpxy at this point shoule be [-0.08 3.4375 4.0625 0 188 192];
    
%specifying target, step 3: abcdxy    
    abcdxy                  =   UTIL_2D_affine_tllpxy_to_abcdxy(tllpxy);

%specifying target, step 4: Ha_2x3    
    Ha_2x3                  =   UTIL_2D_affine_Ha_2x3_from_abcdxy(abcdxy);