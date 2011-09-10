clear;
close all;
clc;

I = double(imread('img\test_S.pgm'));
imshow(I);
k = UTIL_2D_warp_image(I, [0 0 0 0 1 1]);
imshow(uint8(k));
