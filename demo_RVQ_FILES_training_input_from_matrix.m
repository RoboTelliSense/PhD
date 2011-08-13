%% This file shows how to use RVQ training.
% 
% Scalar example mentioned in the IDDM paper.
% D is dimensionality of snippets, 1 here since we have scalars.
% N is number of training examples (snippets), 256 scalar values in this example.
% 
% Also see main_compare_bPCA_ESVQ_RVQ_TSVQ.m where this example is used
% again alongwith other examples
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : April 20, 2011
% Date last modified : July 19, 2011.
%%

%-------------------------------
% INITIALIZATIONS
%-------------------------------

    clear;
    clc;
    close all;

    DM2                     =   1:256;          %input data matrix, DxN                       
    [D,N]                   =   size(DM2);      %
    
    sRVQ.maxP               =   8;              %max number of stages, sRVQ.P contains actual number of stages 
    sRVQ.M                  =   2;              %number of codevectors/stage
    sRVQ.targetSNR          =   1000;
    sRVQ.sw                 =   1;              %snippet width
    sRVQ.sh                 =   1;              %snippet height
    sRVQ.dir_out            =   '';             %directory where output files are saved

%-------------------------------
% PROCESSING
%-------------------------------
    %training (gen -l will test training examples as well)
    sRVQ                    =   RVQ__training       (DM2, sRVQ);    %creates the .sml file for RVQ, then runs gen.exe for training
                                                                    %codebooks, then runs gen.exe -l to test training vectors and 
                                                                    %saves results in positiveExamples.idx

                                sRVQ.CB_r                           %display the codebook
