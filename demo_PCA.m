    clear;
    clc;
    close all;
    
    DM2                     =   [1 4 5 -2 -2 -6; ...
                                 3 2 4 -2 -3 -4];
    PCA                     =   [];   
    PCA.mode                =   'batch';
    PCA                     =   bPCA_1_train(DM2, PCA);   
       