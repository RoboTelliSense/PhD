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
    Table_1_best           = [ min(    OUT.pca,            [], 2)  ...
                                min(    OUT.tsvq,           [], 2)  ...
                                min(    OUT.maxP,           [], 2)  ...
                                min(    OUT.RofE,           [], 2)  ...
                                min(    OUT.nulE,           [], 2)  ...
                                min(    OUT.monR,           [], 2)  ];
                            
    Table_2_mean           = [ mean(   OUT.pca,                2)  ...
                                mean(   OUT.tsvq,               2)  ...
                                mean(   OUT.maxP,               2)  ...
                                mean(   OUT.RofE,               2)  ...
                                mean(   OUT.nulE,               2)  ...
                                DM2_filtered_mean(OUT.monR, 50, 2)  ];   %because this has one track lost
                            
% %comparison DoF_16 (PCA: 16, TSVQ: 3 stages, RVQ: 8x2)
    Table_3_16             = [ OUT.pca( :,2) ...
                                OUT.tsvq(:,1) ...
                                OUT.maxP(:,1) ...
                                OUT.RofE(:,1) ...
                                OUT.nulE(:,1) ...
                                OUT.monR(:,1) ];
                                

    Table_4_32             = [ OUT.pca( :,3)  ...
                                OUT.tsvq(:,2) ...
                                OUT.maxP(:,2) ...
                                OUT.RofE(:,2) ...
                                OUT.nulE(:,2) ...
                                OUT.monR(:,2) ];
                            
% %comparison algo parameters                           
     Table_3a               =   mean(OUT.pca); 
     Table_3b               =   mean(OUT.tsvq); 
     Table_3c               =   mean(OUT.maxP); 
     Table_3d               =   mean(OUT.RofE); 
     Table_3e               =   mean(OUT.nulE); 
     Table_3f               =   DM2_filtered_mean(OUT.monR, 50, 1); 
								

%------------------------------------------------
% POST-PROCESSING
%------------------------------------------------  
    labels_datasets         =   {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11'};   
    labels_algos            =   {'PCA', 'TSVQ', 'maxP', 'RofE', 'nulE', 'monR'};
 
%figure 1
    figure;
    plot(Table_1_best(:,1), 'r*-');hold on;
    plot(Table_1_best(:,2), 'gs-');
    plot(Table_1_best(:,3), 'bd-');
    plot(Table_1_best(:,4), 'c^-');
    plot(Table_1_best(:,5), 'mx-');
    plot(Table_1_best(:,6), 'k+-');
    legend(labels_algos);
    set(gca, 'XTickLabel', labels_datasets);
    grid on;
    xlabel('publicly available datasets');
    ylabel('best tracking error');
    axis([1 6 0 15]);
    UTIL_FILE_save2pdf('temp/results_final_1a_best', gcf, 300);
 

    figure;
    bar(DM2_cnt_min_row_element(Table_1_best));
    set(gca, 'XTickLabel', labels_algos);
    xlabel('learning algorithms');
    ylabel('best percentage');
    axis([0 7 0 100]);
    grid on;
    UTIL_FILE_save2pdf('temp/results_final_1b_best_percent', gcf, 300);
    
%figure 2    
    figure;
    plot(Table_2_mean(:,1), 'r*-');hold on;
    plot(Table_2_mean(:,2), 'gs-');
    plot(Table_2_mean(:,3), 'bd-');
    plot(Table_2_mean(:,4), 'c^-');
    plot(Table_2_mean(:,5), 'mx-');
    plot(Table_2_mean(:,6), 'k+-');
    legend(labels_algos);
    set(gca, 'XTickLabel', labels_datasets);
    grid on;
    xlabel('publicly available datasets');
    ylabel('mean tracking error');
    axis([1 6 0 15]);
    UTIL_FILE_save2pdf('temp/results_final_2a_mean', gcf, 300);

    figure;
    bar(DM2_cnt_min_row_element(Table_2_mean));
    set(gca, 'XTickLabel', labels_algos);
    xlabel('learning algorithms');
    ylabel('mean percentage');
    axis([0 7 0 100]);
    grid on;
    UTIL_FILE_save2pdf('temp/results_final_2b_mean_percent', gcf, 300);
    
%figure 3
    figure;
    plot(Table_3_16(:,1), 'r*-');hold on;
    plot(Table_3_16(:,2), 'gs-');
    plot(Table_3_16(:,3), 'bd-');
    plot(Table_3_16(:,4), 'c^-');
    plot(Table_3_16(:,5), 'mx-');
    plot(Table_3_16(:,6), 'k+-');
    legend(labels_algos);
    set(gca, 'XTickLabel', labels_datasets);
    grid on;
    xlabel('publicly available datasets');
    ylabel('tracking error, PCA_{16}, TSVQ_3, RVQ_{8x2}'); 
    axis([1 6 0 15]);
    UTIL_FILE_save2pdf('temp/results_final_3a_16', gcf, 300);
    
    figure;
    bar(DM2_cnt_min_row_element(Table_3_16));
    set(gca, 'XTickLabel', labels_algos);
    xlabel('learning algorithms');
    ylabel('Storage=16 percentage');
    axis([0 7 0 100]);
    grid on;
    UTIL_FILE_save2pdf('temp/results_final_3b_16_percent', gcf, 300);
    
%figure 4    
    figure;
    plot(Table_4_32(:,1), 'r*-');hold on;
    plot(Table_4_32(:,2), 'gs-');
    plot(Table_4_32(:,3), 'bd-');
    plot(Table_4_32(:,4), 'c^-');
    plot(Table_4_32(:,5), 'mx-');
    plot(Table_4_32(:,6), 'k+-');
    legend(labels_algos);
    set(gca, 'XTickLabel', labels_datasets);
    grid on;
    xlabel('publicly available datasets');
    ylabel('tracking error, PCA_{32}, TSVQ_4, RVQ_{8x4}'); 
    axis([1 6 0 15]);
    UTIL_FILE_save2pdf('temp/results_final_4a_32', gcf, 300);
    
    figure;
    bar(DM2_cnt_min_row_element(Table_4_32));
    set(gca, 'XTickLabel', labels_algos);
    xlabel('learning algorithms');
    ylabel('Storage=32 percentage');
    axis([0 7 0 100]);
    grid on;
    UTIL_FILE_save2pdf('temp/results_final_4b_32_percent', gcf, 300);
        
%figure 5



%tables
    Table_1_best           =   [Table_1_best ; DM2_cnt_min_row_element(Table_1_best)];
    Table_2_mean           =   [Table_2_mean ; DM2_cnt_min_row_element(Table_2_mean)];

    Table_3_16             =   [Table_3_16   ; DM2_cnt_min_row_element(Table_3_16)];
    Table_4_32             =   [Table_4_32   ; DM2_cnt_min_row_element(Table_4_32)];
    
    labels_datasets         =   [labels_datasets ' \% best'];
    
    UTIL_matrix2latex(Table_1_best, 'temp/results_final_1_best.tex', 'rowLabels', labels_datasets, 'columnLabels', labels_algos, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(Table_2_mean, 'temp/results_final_2_mean.tex', 'rowLabels', labels_datasets, 'columnLabels', labels_algos, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(Table_3_16,   'temp/results_final_3_16.tex',   'rowLabels', labels_datasets, 'columnLabels', labels_algos, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(Table_4_32,   'temp/results_final_4_32.tex',   'rowLabels', labels_datasets, 'columnLabels', labels_algos, 'alignment', 'c', 'format', '%-6.2f');