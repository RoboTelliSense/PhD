clear;
clc;
close all;

    xy_2xN                  =   [3 7 1 0  8  3 9 1; ...
                                 2 5 9 1 -2 -4 2 4;];
    [D, N]                  =   size(xy_2xN);

    xy1_3xN                 =   [xy_2xN; ...
                                ones(1,N)];
      

    Ha_2x3                  =   [1 2 14; ...
                                 3 4 9];
      
    XY_2xN                  =   Ha_2x3 *    xy1_3xN;

    Ha_2x3_check            =   UTIL_2D_affine_correspondences_to_Ha_2x3(xy_2xN, XY_2xN)