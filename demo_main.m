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
    main(16,     8,2,1000,     3,2,      1,   1,   1,  1,         1)