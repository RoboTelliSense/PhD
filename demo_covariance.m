clear;
clc;
close all;

dataSet                     =   2;

if (dataSet==1)
    A                       =   [1 2 3; ...
                                 3 8 4];
elseif (dataSet==2)
    A                       =   randn(300,200);
end
[D N]                       =   size(A);
muA                         =   mean(A,2);
Az                          =   A - repmat(muA, 1,N);
Sigma_1                     =   cov(A',1);
Sigma_2                     =   (1/N)*Az*Az';
diff                        =   Sigma_1 - Sigma_2; 
                                norm(diff(:))