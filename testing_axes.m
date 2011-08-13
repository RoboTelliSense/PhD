clear;
clc;
close all;

%subplot positions and dimensions
    fig_make_smaller_by_x =   0.06;    
    fig_make_smaller_by_y =   0.06;    
    fig_margin_xpos     =   0.05;
    fig_margin_ypos     =   0.0;
    fig_w               =   0.25 - fig_make_smaller_by_x; %max width is 0.25 since I have 4 images in width
    fig_h               =   0.2  - fig_make_smaller_by_y; %max height is 0.2 since I have 5 images in height

    fig_x1              =   0    + fig_margin_xpos;
    fig_x2              =   0.25 + fig_margin_xpos;
    fig_x3              =   0.5  + fig_margin_xpos;
    fig_x4              =   0.75 + fig_margin_xpos;

    fig_y1              =   0    + fig_margin_ypos;
    fig_y2              =   0.2  + fig_margin_ypos;
    fig_y3              =   0.4  + fig_margin_ypos;
    fig_y4              =   0.6  + fig_margin_ypos;
    fig_y5              =   0.8  + fig_margin_ypos;

%data
    a                   =   [1 2 3;4 5 6;7 8 9]


%plot
    UTIL_suptitle('hello hello hello hello hello hello hello', 10);

    hh=figure(1);
    subplot('Position', [fig_x1,fig_y1,fig_w,fig_h])
    imagesc(a);
    title('hello')
    %axis equal
    axis tight

    subplot('Position', [fig_x2,fig_y1,fig_w,fig_h])
    imagesc(a);
    %axis equal
    axis tight

    subplot('Position', [fig_x3,fig_y1,fig_w,fig_h])
    imagesc(a);
    %axis equal
    axis tight

    subplot('Position', [fig_x4,fig_y1,fig_w,fig_h])
    imagesc(a);
    %axis equal
    axis tight





    subplot('Position', [fig_x1,fig_y2,fig_w,fig_h])
    imagesc(a);
    %axis equal
    axis tight

    subplot('Position', [fig_x2,fig_y2,fig_w,fig_h])
    imagesc(a);
    %axis equal
    axis tight

    subplot('Position', [fig_x3,fig_y2,fig_w,fig_h])
    imagesc(a);
    %axis equal
    axis tight

    subplot('Position', [fig_x4,fig_y2,fig_w,fig_h])
    imagesc(a);
    %axis equal
    axis tight






    subplot('Position', [fig_x1,fig_y3,fig_w,fig_h])
    imagesc(a);
    %axis equal
    axis tight

    subplot('Position', [fig_x2,fig_y3,fig_w,fig_h])
    imagesc(a);
    %axis equal
    axis tight

    subplot('Position', [fig_x3,fig_y3,fig_w,fig_h])
    imagesc(a);
    %axis equal
    axis tight

    subplot('Position', [fig_x4,fig_y3,fig_w,fig_h])
    imagesc(a);
    %axis equal
    axis tight





    subplot('Position', [fig_x1,fig_y4,fig_w,fig_h])
    imagesc(a);
    axis equal
    axis tight

    subplot('Position', [fig_x2,fig_y4,fig_w,fig_h])
    imagesc(a);
    axis equal
    axis tight

    subplot('Position', [fig_x3,fig_y4,fig_w,fig_h])
    imagesc(a);
    axis equal
    axis tight

    subplot('Position', [fig_x4,fig_y4,fig_w,fig_h])
    imagesc(a);
    axis equal
    axis tight





    subplot('Position', [fig_x1,fig_y5,fig_w,fig_h])
    imagesc(a);
    UTIL_makeTitle('hello', 'r', 8);
    axis equal
    axis tight

    subplot('Position', [fig_x2,fig_y5,fig_w,fig_h])
    imagesc(a);
    axis equal
    axis tight

    subplot('Position', [fig_x3,fig_y5,fig_w,fig_h])
    imagesc(a);
    title('hello')
    axis equal
    axis tight

    subplot('Position', [fig_x4,fig_y5,fig_w,fig_h])
    imagesc(a);
    title('hello')
    axis equal
    axis tight

%save    
    
    UTIL_saveImageToFile(hh, 'test.png')



