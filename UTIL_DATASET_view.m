clear;
clc;
close all;

load trellis70
[H, W, F] = size(data);
%find(truepts==0)
for f=[108 109 156 344 375 376]
%for f=1:F   
    I = data(:,:,f);
    imshow(I);
    title(num2str(f));
    hold on;
    UTIL_PLOT_filledCircle( [truepts(1,1,f), truepts(2,1,f)],   3,   3000,   'g');      %yellow color
    UTIL_PLOT_filledCircle( [truepts(1,2,f), truepts(2,2,f)],   3,   3000,   'g');      %yellow color    
    %impixelinfo
    drawnow
    UTIL_dbloop
    pause
end