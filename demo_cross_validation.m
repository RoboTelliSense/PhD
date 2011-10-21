clear;
clc;
close all;

%lst_M                   =   2:1:16; %RVQ
%lst_Q                  =   [1:8];      %TSVQ
lst_Q                  =   [4:4:256];  %PCA
    
%load results2/rvq_cross_validation_9.mat   %uniform distribution
%load results2/rvq_cross_validation_10.mat  %Gaussian distribution
%load results2/rvq_cross_validation_11.mat  %Gauss Markov distribution
%load results2/rvq_cross_validation_12.mat  %Dudek
%load results2/tsvq_cross_validation_12.mat  %Dudek
load results2/pca_cross_validation_12.mat  %Dudek

figure;
%plot(lst_M, rmse_trg, 'ro-')
plot(lst_Q, rmse_trg, 'ro-')
hold on;
%plot(lst_M, rmse_tst, 'bd-')
plot(lst_Q, rmse_tst, 'bd-')
xlabel('Q (number of PCA eigenvectors)');
%xlabel('Q (number of TSVQ stages)');
%xlabel('M (number of code-vectors per stage)');
ylabel('reconstruction rms error');
%axis([2 10 0 1.5]) %RVQ, random distributions
%axis([2 10 0 20])  %RVQ, Dudek
%axis([1 8 0 20])  %TSVQ, Dudek
axis([0 100 0 20])  %PCA, Dudek
grid on;
legend('trg', 'tst');
UTIL_FILE_save2pdf('PCA_Dudek.pdf')