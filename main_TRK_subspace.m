%> @file main_TRK_subspace.m
%> @brief Main function for subspace tracking. It is the entry point for my PhD thesis work.
%>
%> dependencies
%> ------------
%> 1. dataset images and ground truth : Dudek.mat, davidin300.mat, sylv.mat, trellis70.mat, fish.mat, car4.mat, car11.mat
%> 2. random data for particle filter : RandomData.mat, 
%> 3. executable files                : RVQ__training_gen8.exe, RVQ__training_gen8.linux
%> 4. on Linux                        : make sure you do chmod +x RVQ__training_gen8.linux
%>
%> Copyright (c) Salman Aslam.  All rights reserved
%> Date created : around May 2011
%> Date modified: Aug 13, 2011

    clear;
    clc;
    close all;
    colormap('gray');
                         %Np  Nw weighting   PCA      RVQ          TSVQ      algorithms datasetIndex
    TRK_subspace_wrapper(600, 4, 0,          16,     8,2,1000,      3,2,      1, 1, 1,         1)