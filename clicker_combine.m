clear;
clc;
close all;

load trellis70;

load trellis70_1;
pts1 = points;

load trellis70_2;
pts2 = points;


%load davidin300_3_lefteye;
%pts3 = points;
[temp, N] = size(pts1);

pts1_new = reshape(pts1, 2,1,N);
pts2_new = reshape(pts2, 2,1,N);
%pts3_new = reshape(pts3, 2,1,N);
%truepts = cat(2, pts1_new, pts2_new, pts3_new);
truepts = cat(2, pts1_new, pts2_new);

clear points;
clear pts1;
clear pts2;
clear pts3;
clear pts1_new;
clear pts2_new;
clear pts3_new;
clear N;
clear temp;


save out