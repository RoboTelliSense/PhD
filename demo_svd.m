clear;
clc;
close all;

a=[1 5 8;4 8 1; 2 1 9];
[U,S,V]=svd(a);
[U1, Ssquared_1]=eig(a*a'); %U1 should be the same as U
[V1, Ssquared_2]=eig(a'*a); %V1 should be the same as V
a_out = U*S*V';             %Ssquared_1, Ssquared_2 and S'*S and S*S' should be the same
a-a_out
