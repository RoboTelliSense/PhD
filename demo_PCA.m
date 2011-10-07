    clear;
    clc;
    close all;
    
    DM2z                    =   [1 4 5 -2 -2 -6; ...
                                 3 2 4 -2 -3 -4];
    mu                      =   [2;3];
    DM2                     =   DM2z + repmat(mu, 1, 6)
    
    PCA                     =   []; 
    PCA.mdl_1_Q__1x1        =   100;
    PCA.mode                =   'batch';
    
    PCA                     =   PCA__1_learn(DM2, PCA);  
    
    5.1414*(PCA.mdl_3_U__DxQ)
       