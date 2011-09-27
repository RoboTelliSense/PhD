function Iroi_shxsw = UTIL_2D_affine_extract_roi_from_image(I, sw, sh, fp_gt_roi_2xG, fp_gt_can_2xG)

%given: feature points, ground truth, from image and canonical
    fp_gt_roi_2xG               =   truepts(:,:,1); %feature points, ground truth, on the region of interest (roi)
    fp_gt_can_2xG               =   [-11.0275    0.2407   11.4563   -6.2122    0.5895    8.2183    0.6912; ...
                                      -3.9535   -4.7745   -3.6580    9.0161    8.0800    8.2949   12.8408 ];                                
    [temp1 G]                   =   size(fp_gt_roi_2xG);

%compute forward mapping, canonical to roi
    Ha_2x3                      =   UTIL_2D_affine_correspondences_to_Ha_2x3(fp_gt_can_2xG, fp_gt_roi_2xG);    
    [X_hxw, Y_hxw, Iroi_shxsw]    =   UTIL_2D_affine_extractROI(double(I), Ha_2x3, sw, sh);

    
%   fp_gt_can_nzc_2xG           =   fp_gt_can_2xG + repmat([sw/2;sh/2], 1,
%   G);
%     imagesc(Iroi_shxsw);
%     colormap('gray')
%     hold on;
%     for g=1:G
%         UTIL_PLOT_filledCircle([fp_gt_can_nzc_2xG(1,g),fp_gt_can_nzc_2xG(2,g),], 1, 3000, 'b'); 
%     end
%     axis equal
%     axis tight