clear;
clc;
close all;

load trellis70

%load davidin300_1_nose
%points_noise = points;

%load davidin300_2_righteye
%points_righteye = points;

%load davidin300_3_lefteye
%points_lefteye = points;

load trellis70_2.mat
%load car4_3.mat
[tempp1, tempp2, T] = size(data);

figure;

for f=1:T
    
    imshow(uint8(data(:,:,f)));
    
    hold on;
    %circle([points_noise(1,f) points_noise(2,f)], 5, 1000);
    %circle([points_righteye(1,f) points_righteye(2,f)], 5, 1000);
    %circle([points_lefteye(1,f) points_lefteye(2,f)], 5, 1000);
    circle([points(1,f) points(2,f)], 5, 1000);
    
    title(num2str(f));
    hold off;
    drawnow
    f
end

