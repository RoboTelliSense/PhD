    clear;
    clc;
    close all;
    
%------------------------------------------------
% PRE-PROCESSING
%------------------------------------------------   
%input data
    OUT                     =   results_numbers();      %read numbers
    
%make a single matrix: stack columns for each dataset side by side
    Table_pca_3x6           = [ OUT.pca__1_Dudek__ ... %8;16;32
                                OUT.pca__2_david__ ... %8;16;32
                                OUT.pca__3_sylv___ ... %8;16;32
                                OUT.pca__5_fish___ ... %8;16;32
                                OUT.pca__6_car4___ ... %8;16;32
                                OUT.pca__7_car11__ ];  %8;16;32

%plot rows, one at a time (xaxis: datasets)
    figure;
    plot(1:6, Table_pca_3x6(1,:), 'b*-'); hold on; %8
    plot(1:6, Table_pca_3x6(2,:), 'gs-');          %16
    plot(1:6, Table_pca_3x6(3,:), 'rd-');          %32
    legend({'Q=8', 'Q=16', 'Q=32'});
    grid on;
    axis([1 6 0 15])
    set(gca, 'XTick', 1:6);
    set(gca, 'XTickLabel', {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11'});
    xlabel('publicly available datasets');
    ylabel('tracking error');
    UTIL_FILE_save2pdf('temp/results_pca__trk_1a', gcf, 300); 


    
%plot cols (xaxis: Q)
    figure;
    plot(Table_pca_3x6(:,1), 'r*-'); hold on; %Dudek
    plot(Table_pca_3x6(:,2), 'g+-');          %davidin300
    plot(Table_pca_3x6(:,3), 'ro-');          %sylv
    plot(Table_pca_3x6(:,4), 'g^-');          %fish
    plot(Table_pca_3x6(:,5), 'bs-');          %car4
    plot(Table_pca_3x6(:,6), 'bd-');          %car11
    legend({'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11'});
    grid on;
    axis([1 3 0 15])
    set(gca, 'XTick', 1:3);
    set(gca, 'XTickLabel', {'8', '16', '32'});
    xlabel('Number of eigenvectors, Q');
    ylabel('tracking error');
    UTIL_FILE_save2pdf('temp/results_pca__trk_1b', gcf, 300);     
 
%average over datasets
    figure;
    Table_config_1x6 = mean(Table_pca_3x6, 1)
    bar(Table_config_1x6)
    grid on;
    axis([0 7 0 15])
    set(gca, 'XTick', 1:6);
    set(gca, 'XTickLabel', {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11'});
    xlabel('publicly available datasets');
    ylabel('tracking error');
    UTIL_FILE_save2pdf('temp/results_pca__trk_1c.pdf', gcf, 300);    
    
    
%average over 8, 16, 32
    figure;
    Table_config_3x1 = mean(Table_pca_3x6, 2)
    bar(Table_config_3x1)
    grid on;
    axis([0 4 0 15])
    set(gca, 'XTick', 1:3);
    set(gca, 'XTickLabel', {'8', '16', '32'});
    xlabel('Number of eigenvectors, Q');
    ylabel('tracking error');
    UTIL_FILE_save2pdf('temp/results_pca__trk_1d', gcf, 300);   
    

    UTIL_matrix2latex(Table_pca_3x6,   'temp/results_pca__trk.tex',    'rowLabels', {'Q=8', 'Q=16', 'Q=32'}, 'columnLabels', {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11'}, 'alignment', 'c', 'format', '%-6.2f');
