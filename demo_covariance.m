clear;
clc;
close all;

dataSet                     =   2;

if (dataSet==1)
    DM2                     =   [1 2 3; ...
                                 3 8 4];
elseif (dataSet==2)
    DM2                     =   randn(300,200);
end
[D N]                       =   size(DM2);
DM2mu                       =   mean(DM2,2);
DM2z                        =   DM2 - rep5mat(DM2mu, 1,N);
Sigma_1                     =   cov(DM2',1);
Sigma_2                     =   (1/N)*DM2z*DM2z';
diff                        =   Sigma_1 - Sigma_2; 
                                norm(diff(:))