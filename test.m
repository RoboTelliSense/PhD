clear;
clc;
%close all;
load
ALGO.tst_6_partQ_1xN=ALGO.tst_6_partQ_1x1;

ALGO.in_11_lmbd = 0.003;



DFFS                    =   abs(ALGO.tst_3_error_DxN/256);              %scale and make positive, PCA terminology from Moghaddam and Pentland terminology to keep things uniform
if (strcmp(TRK.name, 'trkaRVQx'))
    DIFS                =   repmat(ALGO.in_11_lmbd*(ALGO.in_3__maxQ-ALGO.tst_6_partQ_1xN), D, 1);
    DFFS                =   DFFS + DIFS;
end
    
temp_weights            =   exp(-( sum(DFFS.^2)+ sum(DIFS.^2)            )./stddev)';
weights                 =   temp_weights ./ sum(temp_weights); 

figure;stem(weights);title(num2str(ALGO.in_11_lmbd));axis([1 600 0 1]);grid