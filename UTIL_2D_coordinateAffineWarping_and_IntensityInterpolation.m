%> @file UTIL_2D_coordinateAffineWarping_and_IntensityInterpolation.m
%> @brief extract a subimage from a larger image
%>
%> I have an input image from which I want to extract a subimage.  The
%> extraction is not done based on a rectangle, but on a region of interest
%> defined by standard affine parameters a, b, c, d, tx, ty as follows,
%> 
%> X = ax + by + tx
%> Y = cx + dy + ty
%>
%> (x, y), called (ref_grid_x_1xD, ref_grid_y_1xD) below, define coordinates of the contours of a rectangle centered around
%> 0.
%> (X, Y) and y define coordinates of the contours of a rectangle centered around
%> 0.
%>
%> Here, a, b, c, d are regular affine parameters.  tx and ty define the center of where the
%> affine ROI should be centered.
%>
%> w, h                     :   size of reference grid
%> W, H                     :   size of input image
%> I_HxW                    :   input reference image (large)
%> I_hxw                    :   output warped image (in most cases, smaller)
%>
%> Copyright (c) Salman Aslam
%> Date created             :   Sep 13, 2011
%> Date modified            :   Sep 14, 2011

function [X_hxw, Y_hxw, I_hxw] = UTIL_2D_coordinateAffineWarping_and_IntensityInterpolation(I_HxW, H_2x3, w, h)

%----------------------------------------------------
%PRE-PROCESSING
%----------------------------------------------------
    D                       =   w*h;                                                                %it will be multiplied by matrix A and then translated by (tx,ty)
    
%----------------------------------------------------
%PROCESSING
%----------------------------------------------------    
%coordinate warping
    %reference 0 centered grid
    [grid_x_hxw, grid_y_hxw]=   meshgrid([1:w]-w/2, [1:h]-h/2); %input grid based on w and h centered around 0    
    ref_grid_x_1xD          =   grid_x_hxw(:)';                 %vectorize grid coordinates
    ref_grid_y_1xD          =   grid_y_hxw(:)';                 %"
    
    %warp grid coordinates (not intensities!) to new grid
    [grid_X_1xD, grid_Y_1xD]=   UTIL_2D_affine_apply_transform(H_2x3, ref_grid_x_1xD, ref_grid_y_1xD);
    X_hxw                   =   reshape(grid_X_1xD, h, w);
    Y_hxw                   =   reshape(grid_Y_1xD, h, w);
    
%intensity interpolation    
    %get intensities on new grid values
    I_hxw                   =   interp2(I_HxW, X_hxw, Y_hxw);
    
    I_hxw(find(isnan(I_hxw))) = 0;
   
    
