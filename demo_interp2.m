clear;
clc;
close all;
%interp2 by itself does linear interpolation

x                           =   [1 2 3;4 0 6;7 8 9];

[X,Y]                       =   meshgrid(1:3,1:3);
zi                          =   interp2(x,X,Y)

[X,Y]                       =   meshgrid(-0.5:1:0.5,-0.5:1:0.5);
zi                          =   interp2(x,X,Y)

[X,Y]                       =   meshgrid(1.5:1:2.5,1.5:1:2.5);
zi                          =   interp2(x,X,Y)

[X,Y]                       =   meshgrid(0.5:1:3.5,0.5:1:3.5);
zi                          =   interp2(x,X,Y)