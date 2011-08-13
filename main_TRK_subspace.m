%dependencies
% Dudek.mat, RandomData.mat, RVQ__training_gen8.exe
% on Linux, make sure you do chmod +x RVQ__training_gen8.linux

clear;
clc;
close all;
colormap('gray');

%for checking                                     
TRK_subspace_wrapper(600, 4, 0,          16,     8,2,1000,      3,2,      1, 1, 1,         1)


                     %Np  Nw weighting   PCA      RVQ          TSVQ      algorithms     datasetIndex
%TRK_subspace_wrapper(600, 4, 0,          128,     8,2,1000,      1,2,      0, 1, 0,         1)
