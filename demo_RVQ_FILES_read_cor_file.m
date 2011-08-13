%% This program demonstrates how to read and display Explorer generated .cor file which has nsr values. 
% 
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : April 25, 2011
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
    NSR = RVQ_FILES_read_cor_file('referenceRVQ/reference_9_00472_640x480.cor', 640, 480, 11, 41);

%-------------------------------------
%POST-PROCESSING
%-------------------------------------
    figure;
    imagesc(10*log10(1./NSR))
    colorbar
    impixelinfo    
    title('reconstruction SNR (dB)');
    axis equal
    axis tight
