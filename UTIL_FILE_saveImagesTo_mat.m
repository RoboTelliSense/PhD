clear;
clc;
close all;

data = uint8([]);
fidx=1;

for f=1:5:487
    f
    %str_f           =   ['C:\salman\portable\RVQ_xplatform1\img\PETS2001_768x576\' UTIL_GetZeroPrefixedFileNumber(f) '.jpg'];
    %str_f           =   ['C:\salman\images\PETS2006\S1-T1-C\S1-T1-C\video\pets2006\S1-T1-C\3\INP_IMG\' UTIL_GetZeroPrefixedFileNumber(f) '.jpg']; 
    %str_f           =   ['C:\salman\images\PETS2009\S0\Background\View_004\Time_13-06\' UTIL_GetZeroPrefixedFileNumber(f) '.jpg'];
    str_f           =   ['C:\salman\images\motinas_fast\' UTIL_GetZeroPrefixedFileNumber(f) '.png'];
    I               =   rgb2gray(imread(str_f));
    data(:,:,fidx)     =   I;
    fidx = fidx+1;
end
datatitle = 'motinas_fast_er';
clear f;
clear fidx;
clear I;
clear str_f;

save([datatitle '.mat'])
%save PETS2009.mat %went from 389:742, red coat female, PETS2009148:340 
%save PETS2001rcf.mat %went from 491:610, red coat female
