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
    main(32,     8,4,1000,0,2,   4,2,      0,   1,   1,  1,         1); %Dudek   8x4, RofE