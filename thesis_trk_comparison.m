clear;
clc;
close all;
%------------------------------------------------
% PRE-PROCESSING
%------------------------------------------------
%read results
    OUT                     =  thesis_trk_results();      %read numbers


%------------------------------------------------
% PROCESSING: PCA
%------------------------------------------------
%for rvq, we use 1:3 since we only use 8x2, 8x4, 8x8 and ignore 8x12 and 8x16
    Table_1a_best           = [ min(    OUT.pca,                        [], 2)  ...
                                min(    OUT.tsvq,                       [], 2)  ...
                                min(    OUT.rvq1(:,1:3),                [], 2)  ...
                                min(    OUT.rvq2(:,1:3),                [], 2)  ...
                                min(    OUT.rvq3(:,1:3),                [], 2)  ...
                                min(    OUT.rvq4(:,1:3),                [], 2)  ];
                            
    Table_1b_mean           = [ mean(   OUT.pca,                            2)  ...
                                mean(   OUT.tsvq,                           2)  ...
                                mean(   OUT.rvq1(:,1:3),                    2)  ...
                                mean(   OUT.rvq2(:,1:3),                    2)  ...
                                mean(   OUT.rvq3(:,1:3),                    2)  ...
                                DM2_filtered_mean(OUT.rvq4(:,1:3), 9999,    2)  ];  
                            
% %comparison DoF_16 (PCA: 16, TSVQ: 3 stages, RVQ: 8x2)
    Table_2a_16             = [ OUT.pca(:,2) ...
                                OUT.tsvq(:,1) ...
                                OUT.rvq1(:,1) ...
                                OUT.rvq2(:,1) ...
                                OUT.rvq3(:,1) ...
                                OUT.rvq4(:,1) ];
                                

    Table_2b_32             = [ OUT.pca(:,3)  ...
                                OUT.tsvq(:,2) ...
                                OUT.rvq1(:,2) ...
                                OUT.rvq2(:,2) ...
                                OUT.rvq3(:,2) ...
                                OUT.rvq4(:,2) ];
                            
                            
    
								

%------------------------------------------------
% POST-PROCESSING
%------------------------------------------------  
    labels_datasets         =   {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11'};   
    labels_algos            =   {'PCA', 'TSVQ', 'maxP', 'RofE', 'nulE', 'monR'};
 
%figures
    figure;
    plot(Table_1a_best(:,1), 'r*-');hold on;
    plot(Table_1a_best(:,2), 'gs-');
    plot(Table_1a_best(:,3), 'bd-');
    plot(Table_1a_best(:,4), 'c^-');
    plot(Table_1a_best(:,5), 'mx-');
    plot(Table_1a_best(:,6), 'k+-');
    legend(labels_algos);
    set(gca, 'XTickLabel', labels_datasets);
    grid on;
    xlabel('publicly available datasets');
    ylabel('best tracking error');
    axis([1 6 0 15]);
    UTIL_FILE_save2pdf('temp/results_final_1a_best', gcf, 300);
 
    
    figure;
    plot(Table_1b_mean(:,1), 'r*-');hold on;
    plot(Table_1b_mean(:,2), 'gs-');
    plot(Table_1b_mean(:,3), 'bd-');
    plot(Table_1b_mean(:,4), 'c^-');
    plot(Table_1b_mean(:,5), 'mx-');
    plot(Table_1b_mean(:,6), 'k+-');
    legend(labels_algos);
    set(gca, 'XTickLabel', labels_datasets);
    grid on;
    xlabel('publicly available datasets');
    ylabel('mean tracking error');
    axis([1 6 0 15]);
    UTIL_FILE_save2pdf('temp/results_final_1b_mean', gcf, 300);
    
    figure;
    plot(Table_2a_16(:,1), 'r*-');hold on;
    plot(Table_2a_16(:,2), 'gs-');
    plot(Table_2a_16(:,3), 'bd-');
    plot(Table_2a_16(:,4), 'c^-');
    plot(Table_2a_16(:,5), 'mx-');
    plot(Table_2a_16(:,6), 'k+-');
    legend(labels_algos);
    set(gca, 'XTickLabel', labels_datasets);
    grid on;
    xlabel('publicly available datasets');
    ylabel('tracking error, PCA_{16}, TSVQ_3, RVQ_{8x2}'); 
    axis([1 6 0 15]);
    UTIL_FILE_save2pdf('temp/results_final_2a_16', gcf, 300);
    

    figure;
    plot(Table_2b_32(:,1), 'r*-');hold on;
    plot(Table_2b_32(:,2), 'gs-');
    plot(Table_2b_32(:,3), 'bd-');
    plot(Table_2b_32(:,4), 'c^-');
    plot(Table_2b_32(:,5), 'mx-');
    plot(Table_2b_32(:,6), 'k+-');
    legend(labels_algos);
    set(gca, 'XTickLabel', labels_datasets);
    grid on;
    xlabel('publicly available datasets');
    ylabel('tracking error, PCA_{32}, TSVQ_4, RVQ_{8x4}'); 
    axis([1 6 0 15]);
    UTIL_FILE_save2pdf('temp/results_final_2b_32', gcf, 300);
    
    figure;
    bar(DM2_cnt_min_row_element(Table_1a_best));
    set(gca, 'XTickLabel', labels_algos);
    xlabel('learning algorithms');
    ylabel('best percentage');
    axis([0 7 0 100]);
    grid on;
    UTIL_FILE_save2pdf('temp/results_final_1a_best_percent', gcf, 300);
    
    
    
    figure;
    bar(DM2_cnt_min_row_element(Table_1b_mean));
    set(gca, 'XTickLabel', labels_algos);
    xlabel('learning algorithms');
    ylabel('mean percentage');
    axis([0 7 0 100]);
    grid on;
    UTIL_FILE_save2pdf('temp/results_final_1b_mean_percent', gcf, 300);
    
    
    
    figure;
    bar(DM2_cnt_min_row_element(Table_2a_16));
    set(gca, 'XTickLabel', labels_algos);
    xlabel('learning algorithms');
    ylabel('Storage=16 percentage');
    axis([0 7 0 100]);
    grid on;
    UTIL_FILE_save2pdf('temp/results_final_2a_16_percent', gcf, 300);
    
    
    figure;
    bar(DM2_cnt_min_row_element(Table_2b_32));
    set(gca, 'XTickLabel', labels_algos);
    xlabel('learning algorithms');
    ylabel('Storage=32 percentage');
    axis([0 7 0 100]);
    grid on;
    UTIL_FILE_save2pdf('temp/results_final_2b_32_percent', gcf, 300);
    
    
%tables
    Table_1a_best           =   [Table_1a_best ; DM2_cnt_min_row_element(Table_1a_best)];
    Table_1b_mean           =   [Table_1b_mean ; DM2_cnt_min_row_element(Table_1b_mean)];

    Table_2a_16             =   [Table_2a_16   ; DM2_cnt_min_row_element(Table_2a_16)];
    Table_2b_32             =   [Table_2b_32   ; DM2_cnt_min_row_element(Table_2b_32)];
    
    labels_datasets         =   [labels_datasets ' \% best'];
    
    UTIL_matrix2latex(Table_1a_best, 'temp/results_final_1a_best.tex', 'rowLabels', labels_datasets, 'columnLabels', labels_algos, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(Table_1b_mean, 'temp/results_final_1b_mean.tex', 'rowLabels', labels_datasets, 'columnLabels', labels_algos, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(Table_2a_16,   'temp/results_final_2a_16.tex',   'rowLabels', labels_datasets, 'columnLabels', labels_algos, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(Table_2b_32,   'temp/results_final_2b_32.tex',   'rowLabels', labels_datasets, 'columnLabels', labels_algos, 'alignment', 'c', 'format', '%-6.2f');