    clc;
    clear;
    close all;


    I_ui8                   =   imread('figs/dataset_Dudek_00001.png'); %public link for this image is https://www.sugarsync.com/pf/D215561_9137984_752773
    sw                      =   33;
    sh                      =   33;

%given: feature points, ground truth, from image and canonical 
    fp_gt_roi_2xG           =   [148.9306  187.2747  226.0674  169.6408  192.6433  218.8531  194.5372;%feature points, ground truth, on the region of interest (roi)
                                 179.0198  172.5994  174.0397  230.2172  224.5582  223.3328  243.8089]; %feature points (ground truth)
 
    fp_gt_can_2xG           =   [-11.0275    0.2407   11.4563   -6.2122    0.5895    8.2183    0.6912; ...
                                  -3.9535   -4.7745   -3.6580    9.0161    8.0800    8.2949   12.8408 ];                                
    [temp1 G]               =   size(fp_gt_can_2xG);
    
    Iroi_shxsw              =   UTIL_2D_affine_extractROI_using_fp(I_ui8, sw, sh, fp_gt_roi_2xG, fp_gt_can_2xG, 0);
    fp_gt_can_nzc_2xG       =   fp_gt_can_2xG + repmat([sw/2;sh/2], 1, G);
    
    imagesc(Iroi_shxsw);
    colormap('gray')
    hold on;
    for g=1:G
        UTIL_PLOT_filledCircle([fp_gt_can_nzc_2xG(1,g),fp_gt_can_nzc_2xG(2,g),], 1, 3000, 'b'); 
    end
    axis equal
    axis tight    