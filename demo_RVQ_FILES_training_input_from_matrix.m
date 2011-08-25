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
    
    RVQ.maxP               =   8;              %max number of stages, RVQ.P contains actual number of stages 
    RVQ.M                  =   2;              %number of codevectors/stage
    RVQ.targetSNR          =   1000;
    RVQ.sw                 =   1;              %snippet width
    RVQ.sh                 =   1;              %snippet height
    RVQ.dir_out            =   '';             %directory where output files are saved

%-------------------------------
% PROCESSING
%-------------------------------
    %training (gen -l will test training examples as well)
    RVQ                    =   RVQ__training       (DM2, RVQ);    %creates the .sml file for RVQ, then runs gen.exe for training
                                                                    %codebooks, then runs gen.exe -l to test training vectors and 
                                                                    %saves results in positiveExamples.idx

                                RVQ.CB_r                           %display the codebook
