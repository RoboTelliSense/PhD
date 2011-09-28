function Iroi_shxsw = UTIL_2D_affine_extractROI_using_fp(I, sw, sh, fp_gt_roi_2xG, fp_gt_can_2xG, bRandomize)

%compute forward mapping, canonical to roi
    Ha_2x3                      =   UTIL_2D_affine_correspondences_to_Ha_2x3(fp_gt_can_2xG, fp_gt_roi_2xG);    

    if (bRandomize)
    end
    [X_hxw, Y_hxw, Iroi_shxsw]  =   UTIL_2D_affine_extractROI_using_Ha_2x3(double(I), Ha_2x3, sw, sh);

  