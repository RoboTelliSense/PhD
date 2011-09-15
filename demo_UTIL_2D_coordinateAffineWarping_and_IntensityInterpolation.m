clear;
clc;
close all;

%---------------------------------------------
%PRE-PROCESSING
%---------------------------------------------
%read image and affine parameters theta, lambda1, lambda2, phi, tx, ty
    load UTIL_2D_coordinateAffineWarping_and_IntensityInterpolation
    abcdxy                  =   UTIL_2D_affine_tllpxy_to_abcdxy(tllpxy);
    Ha_2x3                  =   UTIL_2D_affine_Ha_2x3_from_abcdxy(abcdxy);
    
    fp_gt                   =   [148.9306  187.2747  226.0674  169.6408  192.6433  218.8531  194.5372;
                                 179.0198  172.5994  174.0397  230.2172  224.5582  223.3328  243.8089]; %feature points (ground truth)
  
%size of grid that i want
    w                       =   33;
    h                       =   33;

%---------------------------------------------
%PROCESSING
%---------------------------------------------
%process grid and intensities
    [X_hxw, Y_hxw, I_hxw]   =   UTIL_2D_coordinateAffineWarping_and_IntensityInterpolation(I_0t1, Ha_2x3, w, h);  %I_0t1 means that image intensities go from 0 to 1, not required though
    
%process feature points    
    [fp_x, fp_y]            =   UTIL_2D_affine_apply_inverse_transform(Ha_2x3, fp_gt(1,:), fp_gt(2,:));
%---------------------------------------------
%POST-PROCESSING
%--------------------------------------------- 
%view original figure with overlaid warped grid and feature points
    figure;
    imagesc(I_0t1);
    colormap('gray');
    axis equal;
    axis tight;

    hold on;
      
    plot(X_hxw(:), Y_hxw(:), 'r.')      %plot grid
    plot(fp_gt(1,:),fp_gt(2,:), 'x');   %plot feature points

   
%view warped image and feature points
    figure;
    imagesc(I_hxw)
    colormap('gray');
    axis equal;
    axis tight;
    
    hold on;

    plot(fp_x+(w-1)/2,fp_y+(h-1)/2, 'x');
    