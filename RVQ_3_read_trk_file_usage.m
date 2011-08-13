clear;
clc;
close all;

dir_out                 =   'test_out/'
dir_I                   =   'img/Dudek/';
ext_I                   =   '.png';
cfn_trk                 =   [dir_out 'tracks.csv'];
sw                      =   33;
sh                      =   33;
[F, CIX, CIY, CX, CY]   =   textread(cfn_trk, '%d   %d %d   %d %d', 'delimiter', ',');
fI                      =   F(1);
Nf                      =   length(F);
fF                      =   fI + Nf - 1;
f_idx                   =   1;
for f=fI:fF
    str_f       =   UTIL_GetZeroPrefixedFileNumber(f);
    cfn_I       =   [dir_I str_f ext_I];
    I           =   imread(cfn_I);
    rect        =   [CX(f_idx)-(sw-1)/2 CY(f_idx)-(sh-1)/2 sw sh];
    imshow(I);
    title(str_f);
    hold on;
    rectangle('Position', rect, 'EdgeColor', 'r');
    hold off;
    impixelinfo
    pause
    f_idx = f_idx+1;
end
