% I_hxw lies on a grid 1:w in x direction and 1:h in y direction
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
    [temp, G]               =   size(fp_gt);
    
%size of grid that i want
    w                       =   33;
    h                       =   33;

%---------------------------------------------
%PROCESSING
%---------------------------------------------
%process grid and intensities
    [X_hxw, Y_hxw, I_hxw]   =   UTIL_2D_coordinateAffineWarping_and_IntensityInterpolation(I_0t1, Ha_2x3, w, h);  %I_0t1 means that image intensities go from 0 to 1, not required though
    
%process feature points (zero center  them)    
    [fp_x_1xG, fp_y_1xG]    =   UTIL_2D_affine_apply_inverse_transform(Ha_2x3, fp_gt(1,:), fp_gt(2,:));
    fp_x_1xG                =   fp_x_1xG + (w-1)/2;             %image starts from (1,1), so shift by half width and half height of output image
    fp_y_1xG                =   fp_y_1xG + (h-1)/2;             % "
%---------------------------------------------
%POST-PROCESSING
%--------------------------------------------- 
%view original figure with overlaid warped grid and feature points
    h=figure;
    imagesc(I_0t1);
   
    hold on;
      
    %plot(X_hxw(:), Y_hxw(:), 'r.')      %plot grid
    for g=1:G
        UTIL_PLOT_filledCircle([fp_gt(1,g),fp_gt(2,g),], 5, 3000, 'b'); 
    end
    
    colormap('gray');
    axis equal;
    axis tight;
    UTIL_FILE_save2pdf('out.pdf', h, 300);
    
%view warped image with overlaid feature points
    h=figure;
    imagesc(I_hxw)
    
    hold on;

    for g=1:G
        UTIL_PLOT_filledCircle( [fp_x_1xG(g), fp_y_1xG(g)],   1,   3000,   'b'); 
    end
 
    colormap('gray');
    axis equal;
    axis tight;
    UTIL_FILE_save2pdf('out.pdf', h, 300);