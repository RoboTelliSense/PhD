clear;
clc;
close all;

[DM2, w, h]                 =   DATAMATRIX_create_random_DM2;
DM2                         =   [4 6 8 10 20 22 24 26];
DM2_weighted                     =   DATAMATRIX_pick_last_Nw_values_and_weight_in_DM2(DM2, 2, 1)
