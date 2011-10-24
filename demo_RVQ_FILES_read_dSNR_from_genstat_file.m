%% This program demonstrates how to read decoder SNR values from gen.exe's chatter file.
% 
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : April 10, 2011
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
    decoder_SNR_dB          =   RVQ_FILES_read_dSNR_from_genstat_file('referenceRVQ/reference_6_gen.txt')