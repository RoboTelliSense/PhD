clear;
clc;
close all;

A = [ 1 1 2; ... 
     2 1 3; ...
     3 2 3; ...
     2 3 1; ...
     1 1 2]
 
[p1, pr]  =RVQ_3_createCCD(A, 3, 1)