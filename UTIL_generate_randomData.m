clear;
clc;
close all;

Np=600;
for f=1:1000
    f
    RAND.unif_cdf_maxFxNp     (f,:)    =   rand(1,Np); 
    RAND.gaus_maxFx6xNp  (f,:,:)  =   randn(6,Np); 
end

clear Np;
clear f;
save RandomData