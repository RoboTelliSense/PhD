%> @file main_TRK_subspace.m
%> @file Main file for tracking.  This is the SINGLE entry point for my PhD thesis experiments.
%>   
%> Copyright (c) Salman Aslam.  All rights reserved.
%> Date created : around Feb, 2011
%> Date modified: Aug 21, 2011
%%
    clear;
    clc;
    close all;

         %PCA     RVQ           TSVQ      iPCA,bPCA,RVQ,TSVQ     datasetIndex
    main(8,     8,8,1000,0,2,   3,2,      0,   0,   1,  0,         3); %sylv   8x8, RofE
    %main(8,     8,2,1000,0,1,   3,2,      0,   0,   1,  0,         6); %car4,  8x2, maxQ
    %main(8,     8,2,1000,0,1,   -2,2,      0,   0,   1,  0,         7); %car11, 8x2, maxQ
    %main(32,     8,4,1000,     5,2,      1,   1,   1,  1,         1)