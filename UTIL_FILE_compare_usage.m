    clear;
    clc;
    close all;
    
    dir_out     =   'C:\salman\portable\RVQ_xplatform1\results_std_1_Np_600_Nict_10000_eig_16_Dudek\';
    cfn_1       =   [dir_out 'PCAaffine.csv'];
    cfn_2       =   ['PCAaffine.csv'];
    
    bSame       =   UTIL_file_compare(dir_out, cfn_1, cfn_2)

