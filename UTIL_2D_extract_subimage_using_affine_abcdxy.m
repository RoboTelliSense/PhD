%> @file UTIL_2D_extract_subimage_using_affine_abcdxy.m
%> @brief extract a subimage from a larger image
%>
%> I have an input image from which I want to extract a subimage.  The
%extraction is not done based on a rectangle, but on a region of interest
%defined by standard affine parameters a, b, c, d, tx, ty as follows,
% 
% X = ax + by + tx
% Y = cx + dy + ty
%
% (x, y), called (grid_x_1xD, grid_y_1xD) below, define coordinates of the contours of a rectangle centered around
% 0.
% (X, Y) and y define coordinates of the contours of a rectangle centered around
% 0.


% Here, a, b, c, d are
%regular affine parameters.  tx and ty define the center of where the
%affine ROI should be centered.
%>
%>
%>
%>
%> I_HxW                    :   input image (large)
%> I_hxw                    :   output image (small)
%>
%> 
%>
function I_hxw = UTIL_2D_extract_subimage_using_affine_abcdxy(I_HxW, p, w, h)

%----------------------------------------------------
%PRE-PROCESSING
%----------------------------------------------------
    D                       =   w*h;
    [grid_x_hxw, grid_y_hxw]=   meshgrid([1:w]-w/2, [1:h]-h/2); %input grid based on w and h centered around 0
                                                                %it will be multiplied by matrix A and then translated by (tx,ty)
    n                       =   size(p,2);
    
    %affine matrix
    a                       =   p(3);
    b                       =   p(4);
    c                       =   p(5);
    d                       =   p(6);
    tx                      =   p(1);
    ty                      =   p(2);
    A_2x3                   =   [a b tx;...  
                                 c d ty]


%----------------------------------------------------
%PRE-PROCESSING
%----------------------------------------------------
%warp grid using affine parameters a, b, c, d and shift by (tx, ty)
    
    %create input matrix
    grid_x_1xD              =   grid_x_hxw(:)';             %vectorize grid coordinates
    grid_y_1xD              =   grid_y_hxw(:)';             %"
    inppoints_xy1_3xD       =   [ grid_x_1xD ; ...      
                                  grid_y_1xD ; ...
                                  ones(1,D)];                          
    %output
    outpoints_xy_2xD        =   A_2x3 * inppoints_xy1_3xD;   %transform to new coordinates
    grid_X_1xD              =   outpoints_xy_2xD(1,:);       %ungroup
    grid_Y_1xD              =   outpoints_xy_2xD(2,:);
    X_hxw                   =   reshape(grid_X_1xD, h, w);
    Y_hxw                   =   reshape(grid_Y_1xD, h, w);
    
    I_hxw                   =   interp2(I_HxW, X_hxw, Y_hxw);
    
    I_hxw(find(isnan(I_hxw))) = 0;
   
    
