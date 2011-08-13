clear;
clc;
close all;

                            load ivt/dudek.mat;
dir_I                   =   'img\Dudek\720x480\';
ext_I                   =   '.png';

[ih, iw, Nf]            =   size(data);

X                       =   [];
Y                       =   [];

for f=1:Nf
    str_f               =   UTIL_GetZeroPrefixedFileNumber(f);
    cfn_I               =   [dir_I str_f ext_I];
    I                   =   data(:,:,f);
    %[x y]=ginput;
    %X = [X x];
    %Y = [Y y];
                            imwrite(I, cfn_I);
                            f
end