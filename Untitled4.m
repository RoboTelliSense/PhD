clear;
clc;
close all;

figure;

load Exp1
    subplot(2,1,1)
    hold on
    grid on; 
    plot(lst_M, rmse_tst(:,1), 'g+-');   
    plot(lst_M, rmse_tst(:,2), 'bd-');  
    plot(lst_M, rmse_tst(:,3), 'm*-');  
    plot(lst_M, rmse_tst(:,4), 'ks-');      
    legend('tst, maxQ', 'tst, RofE', 'tst, nulE', 'tst, monR', 'Location', 'Best'); %
    xlabel('number of code-vectors per stage, m');
    UTIL_FILE_save2pdf('aRVQ_dudek_trg_1_to_95_tst_96_to_100.pdf', gcf, 300);
clear;

load Exp2
    subplot(2,1,2)
    hold on
    grid on; 
    plot(lst_M, rmse_tst(:,1), 'g+-');   
    plot(lst_M, rmse_tst(:,2), 'bd-');  
    plot(lst_M, rmse_tst(:,3), 'm*-');  
    plot(lst_M, rmse_tst(:,4), 'ks-');      
    legend('tst, maxQ', 'tst, RofE', 'tst, nulE', 'tst, monR', 'Location', 'Best'); %
    xlabel('number of code-vectors per stage, m');
    UTIL_FILE_save2pdf('aRVQ_dudek_trg_1_to_95_tst_96_to_100.pdf', gcf, 300);    