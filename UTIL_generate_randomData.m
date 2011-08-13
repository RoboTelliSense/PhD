clear;
clc;
close all;

Np=600;
for f=1:1000
    f
    RandomData_cdf     (f,:)    =   rand(1,Np); 
    RandomData_sample  (f,:,:)  =   randn(6,Np); 
end

clear Np;
clear f;
save RandomData