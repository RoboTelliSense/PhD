% label_sequence Add ground truth information to a video sequence.
%
% This script assumes you have a video sequence stored as a series 
% of images (with consecutive names) all in the same directory.
%
% label_sequence loads all the png images in the current directory and
% sorts the filenames using Matlab's sort.  To use the image type,
% simply change the value of the variable 'EXTENSION'.  The images are
% displayed one at a time, and you can click the mouse to indicate the
% location of the target in each frame.  If you make a mistake, click
% the right mouse button to go back and fix it.  Clicking the middle
% button allows you to advance without saving/changing the current
% point location.
%
% Clicking the location of the target in all frames can be tedious.
% To make this task simpler, try labelling only every other image.
% This can be achieved by increasing the 'STEP' from 1 to 2 (or
% higher).  Later you can fill in the missing points using a spline.
% For example, see fill_in_using_spline.m
%
% Author: David Ross, 2003

%EXTENSION = 'png'
close all;
clear;
clc;

START = 1;
STEP = 1; % if STEP is > 1, then we don't label every image

%filenames = dir(['*.' EXTENSION]);
%filenames = sort({filenames.name});
disp('There are the following options:');
disp('--------------------------------');
disp('davidin300');
disp('sylv');
disp('trellis70');
disp('fish');
disp('car4');
disp('car11');
disp('');



CONFIG.datasetName = input('what is the name?  ', 's');
load(CONFIG.datasetName)

numPt = input('which point are you clicking?  ', 's');
cfn_out = [CONFIG.datasetName '_' numPt];


[tempp1, tempp2, T] = size(data);
disp(['there are a total of ' num2str(T) 'points to click']);
%T = length(filenames);

figure;
set(gcf, 'DoubleBuffer', 'on');
colormap('gray');

points = zeros(2,T);


% disp('Click the mouse on the image.');
% disp('  Left button: mark a point and advance');
% disp('  Right button: go backwards (to fix mistakes)');
% disp('  Middle button: advance without marking/changing the points');

tt = START;
tic
duration=0;
while tt <= T;
    duration = duration + toc
    % load the image
    %im = imread(filenames{tt});
    im = data(:,:,tt);
    
    % display the image
    %image(im);
    imagesc(im);
    %text(10,10,num2str(tt),'Color', 'r');
    title(num2str(tt));
    if any(points(:,tt) ~= 0)
        hold on;
        plot(points(1,tt),points(2,tt),'rx');
        hold off;
    end
    
    % get the points
    [x,y,button] = ginput(1);
    
    
    %     [points(1,tt),points(2,tt), button] = ginput(1);

    % if the button was 1, save the point and advance
    % if the button was 3, go backwards
    % if the button was 2, advance without saving the point
    if button == 1
        points(1,tt) = x;
        points(2,tt) = y;
        tt = tt+STEP;
    elseif button == 3
        tt = max(tt-STEP,1);
    else
        tt = tt+STEP;
    end
    save(cfn_out, 'points');
    toc;
end

disp('Done!.  You should probably save "points".');
