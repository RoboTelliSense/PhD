clear;
clc;
close all;

[DM2, w, h]                 =   DM2_create_random;
DM2                         =   [4 6 8 10 20 22 24 26];
DM2_weighted                     =   DM2_window_and_repeat(DM2, 2, 1)
