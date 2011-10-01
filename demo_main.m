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

         %PCA     RVQ          TSVQ      iPCA,bPCA,RVQ,TSVQ     datasetIndex
    main(8,     8,2,1000,0,3,   3,2,      0,   0,   1,  0,         1)
    %main(32,     8,4,1000,     5,2,      1,   1,   1,  1,         1)