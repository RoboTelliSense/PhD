%% This program demonstrats how to read and display Explorer generated .stg file which has number
%% of stages information for every pixel. 
% 
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : July 20, 2011
% Date last modified : July 20, 2011
%%

%-------------------------------------
%INITIALIZATIONS
%-------------------------------------
    clear;
    clc;
    close all;

%-------------------------------------
%PROCESSING
%-------------------------------------
    P                       =   8;
    STG                     =   RVQ_FILES_read_stg_file('referenceRVQ/reference_10_00472_640x480.stg', 640, 480, 11, 41, 8);

%-------------------------------------
%POST-PROCESSING
%-------------------------------------
    figure;
    imagesc(STG)
    colorbar
    caxis([1 P])
    impixelinfo    
    title('Number of stages used in reconstruction');
    axis equal
    axis tight
