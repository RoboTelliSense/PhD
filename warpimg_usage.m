clear;
close all;
clc;

I = double(imread('img\test_S.pgm'));
imshow(I);
k = warpimg(I, [0 0 0 0 1 1]);
imshow(uint8(k));
