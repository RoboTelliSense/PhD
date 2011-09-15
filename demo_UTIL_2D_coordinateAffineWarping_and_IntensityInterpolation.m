%clear;
clc;
close all;

%---------------------------------------------
%PRE-PROCESSING
%---------------------------------------------
%read image and affine parameters theta, lambda1, lambda2, phi, tx, ty
    load UTIL_2D_coordinateAffineWarping_and_IntensityInterpolation
    abcdxy                  =   UTIL_2D_affine_tllpxy_to_abcdxy(tllpxy);
    H_2x3                   =   UTIL_2D_affine_A_2x3_from_abcdxy(abcdxy);
    
    fp_gt                   =   [148.9306  187.2747  226.0674  169.6408  192.6433  218.8531  194.5372;
                                 179.0198  172.5994  174.0397  230.2172  224.5582  223.3328  243.8089]; %feature points (ground truth)
  
%size of grid that i want
    w                       =   33;
    h                       =   33;

%---------------------------------------------
%PROCESSING
%---------------------------------------------
    [X_hxw, Y_hxw, I_hxw]   =   UTIL_2D_coordinateAffineWarping_and_IntensityInterpolation(I_0t1, H_2x3, w, h);  %I_0t1 means that image intensities go from 0 to 1, not required though
    [ss,tt]                 =   UTIL_2D_affine_apply_inverse_transform(H_2x3, fp_gt(1,:), fp_gt(2,:));
%---------------------------------------------
%POST-PROCESSING
%--------------------------------------------- 
%view original figure with overlaid warped grid
    figure;
    imagesc(I_0t1);
    colormap('gray');
    axis equal;
    axis tight;

    hold on;
    
    %plot(X_hxw(:), Y_hxw(:), 'r.')
    plot(fp_gt(1,:),fp_gt(2,:), 'x');

    
    
%view warped image
    figure;
    imagesc(I_hxw)
    colormap('gray');
    axis equal;
    axis tight;
    
    hold on;
   a=[  -11.0275    0.2407   11.4563   -6.2122    0.5896    8.2183    0.6912
   -3.9534   -4.7745   -3.6580    9.0161    8.0800    8.2949   12.8408];
plot(a(1,:)+16,a(2,:)+16, 'x');
    