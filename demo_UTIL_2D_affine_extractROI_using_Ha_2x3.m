%> @file demo_UTIL_2D_affine_extractROI_using_Ha_2x3.m
%> @brief Demonstrates affine warping.
%>
% outI_shxsw lies on a grid 1:sw in x direction and 1:sh in y direction
%>
%> Copyright (c) Salman Aslam.  All rights reserved.
%> Date created             :   Sep 12, 2011
%> Date modified            :   Sep 15, 2011

clear;
clc;
close all;

%---------------------------------------------
%INITIALIZATION
%---------------------------------------------
%read image and affine parameters theta, lambda1, lambda2, phi, tx, ty
    I_ui8                   =   imread('figs/dataset_Dudek_00001.png'); %public link for this image is https://www.sugarsync.com/pf/D215561_9137984_752773
    xywht                   =   [133 127 110 130 -0.08]; %bounding box, top_leftx, top_lefty, width, height, rotation angle (radians)
                                                         %easy to specify in image processing software like IrfanView
                                                         %in images, negative angle is CCW rotation
                                                         %in cartesian, positive angle is CCW rotation
                                                         %size of grid that i want
    fp_gt_roi               =   [148.9306  187.2747  226.0674  169.6408  192.6433  218.8531  194.5372;
                                 179.0198  172.5994  174.0397  230.2172  224.5582  223.3328  243.8089]; %feature points (ground truth)
                                                         %some points that I know are on the target in important positions, like eyes, etc
                                                         %the roi means they are on the target, not canonical
    sw                      =   33;         %desired (output) snippet width (grid)
    sh                      =   33;         %desired (output) snippet height (grid)
    scale                   =   32;         %should have been 33 but keeping this way, explained in my affine warping report
    
%check all 6 conversions first
    %entry point
    tsrpxy                  =   UTIL_2D_affine_xywht_to_tsrpxy(xywht, scale); %correct: [-0.0800 3.4375  1.1818  0      188  192]  
    
    %from tsrpxy
    tllpxy                  =   UTIL_2D_affine_tsrpxy_to_tllpxy(tsrpxy);      %correct: [-0.0800 3.4375  4.0625  0      188  192]
    abcdxy                  =   UTIL_2D_affine_tsrpxy_to_abcdxy(tsrpxy);

    %from tllpxy
    tsrpxy                  =   UTIL_2D_affine_tllpxy_to_tsrpxy(tllpxy); 
    abcdxy                  =   UTIL_2D_affine_tllpxy_to_abcdxy(tllpxy);      %correct: [ 3.4265 0.3247 -0.2747 4.0495  188  192]
    
    
    %from abcdxy
    tllpxy                  =   UTIL_2D_affine_abcdxy_to_tllpxy(abcdxy);
    tsrpxy                  =   UTIL_2D_affine_abcdxy_to_tsrpxy(abcdxy);
    
%---------------------------------------------
%PRE-PROCESSING
%---------------------------------------------
    Ha_2x3                  =   UTIL_2D_affine_xywht_to_Ha_2x3(xywht, scale);
    [temp, G]               =   size(fp_gt_roi);
    
%---------------------------------------------
%PROCESSING
%---------------------------------------------
%process grid and intensities
    [X_hxw, Y_hxw, outI_shxsw]= UTIL_2D_affine_extractROI_using_Ha_2x3(double(I_ui8), Ha_2x3, sw, sh);  
    
%process feature points (zero center  them)    
    temp                    =   UTIL_2D_affine_apply_inverse_transform(Ha_2x3, [fp_gt_roi(1,:) ; fp_gt_roi(2,:)]);
    fp_gt_can_2xG           =   [temp(1,:); ...
                                 temp(2,:)];                    %feature points, ground truth, canonical box centered on (0,0)
    fp_gt_can_nzc_2xG       =   fp_gt_can_2xG + repmat([sw/2;sh/2], 1, G);
                                                                %image starts from (1,1), so shift by half width and half height of output image
                                                                % "
                                                                %can means on the canonical box, not the ROI
                                                                %nzc means not zero centered
%---------------------------------------------
%POST-PROCESSING
%--------------------------------------------- 
%step 1. input.
%normally, I would create the bounding box in say IrfanView and read
%off xywht (top left x and y coordinates, width, height, rotation angle.  
%I would also click some feature points.  here, I draw a bounding box using xywht and
%the feature points using Matlab's nice and accurate plotting capability
    figure;
    imagesc(I_ui8);
    hold on;
    [boundary_x, boundary_y]=   UTIL_2D_grid_create(sw, sh, 'boundary_zc');
    temp                    =   UTIL_2D_affine_apply_transform(Ha_2x3, [boundary_x ;boundary_y]);
    boundary_X              =   temp(1,:);
    boundary_Y              =   temp(2,:);
    plot(boundary_X, boundary_Y, '.');
    
    hold on;
    
    %plot feature points
    for g=1:G
        UTIL_PLOT_filledCircle([fp_gt_roi(1,g),fp_gt_roi(2,g),], 5, 3000, 'b'); 
    end
    
    colormap('gray');
    axis equal;
    axis tight;
    UTIL_FILE_save2pdf('inp.pdf', gcf, 300);

    
%step 2. intermediate: view warped grid covering the target of interest
    figure;
    imagesc(I_ui8);
   
    hold on;
      
    plot(X_hxw(:), Y_hxw(:), 'r.')      %plot grid
  
    colormap('gray');
    axis equal;
    axis tight;
    UTIL_FILE_save2pdf('int.pdf', gcf, 300);
    
%step 3. final output: warped image with overlaid feature points
    figure;
    imagesc(outI_shxsw)
    
    hold on;

    for g=1:G
        UTIL_PLOT_filledCircle( [fp_gt_can_nzc_2xG(1,g), fp_gt_can_nzc_2xG(2,g)],   1,   3000,   'b'); 
    end
 
    colormap('gray');
    axis equal;
    axis tight;
    UTIL_FILE_save2pdf('out.pdf', gcf, 300);