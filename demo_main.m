%> @file demo_main.m
%> @file Main file for tracking.  This is the SINGLE entry point for my PhD thesis experiments.
%>   
%> Copyright (c) Salman Aslam.  All rights reserved.
%> Date created : around Feb, 2011
%> Date modified: Oct 26, 2011
%%
    clear;
    clc;
    close all;

         %PCA     RVQ           TSVQ      iPCA,bPCA,RVQ,TSVQ     datasetIndex
    main(32,     8,4,1000,0,3,   4,2,      0,   0,   1,  0,         5); %fish           8x4, nulE
    main(32,     8,2,1000,0,2,   4,2,      0,   0,   1,  0,         1); %Dudek          8x2, RofE
    main(32,     8,8,1000,0,4,   4,2,      0,   0,   1,  0,         2); %davidin300     8x8, monR
    main(32,     8,2,1000,0,1,   4,2,      0,   0,   1,  0,         3); %sylv           8x2, maxP
    main(32,     8,2,1000,0,1,   4,2,      0,   0,   1,  0,         6); %car4           8x2, maxP
    main(32,     8,2,1000,0,1,   4,2,      0,   0,   1,  0,         7); %car11          8x2, maxP