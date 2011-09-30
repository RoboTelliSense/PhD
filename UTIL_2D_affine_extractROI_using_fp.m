function Iroi_shxsw = UTIL_2D_affine_extractROI_using_fp(I, sw, sh, fp_gt_roi_2xG, fp_gt_can_2xG, bRandomize)

%compute forward mapping, canonical to roi
    Ha_2x3                      =   UTIL_2D_affine_correspondences_to_Ha_2x3(fp_gt_can_2xG, fp_gt_roi_2xG);    

    if (bRandomize)
        tllpxy                  =   UTIL_2D_affine_Ha_2x3_to_tllpxy(Ha_2x3);
        tllpxy                  =   tllpxy + 0.1*randn(1, length(tllpxy));
        Ha_2x3                  =   UTIL_2D_affine_tllpxy_to_Ha_2x3(tllpxy);
    end
    [X_hxw, Y_hxw, Iroi_shxsw]  =   UTIL_2D_affine_extractROI_using_Ha_2x3(double(I), Ha_2x3, sw, sh);

  