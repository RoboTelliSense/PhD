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
                                

    Table_4_32             = [  OUT.pca( :,3)  ...
                                OUT.tsvq(:,2) ...
                                OUT.maxP(:,2) ...
                                OUT.RofE(:,2) ...
                                OUT.nulE(:,2) ...
                                OUT.monR(:,2) ];
                            
% %comparison algo parameters                           
     Table_5a_pca_          =   mean(OUT.pca); 
     Table_5b_tsvq          =   mean(OUT.tsvq); 
     Table_5c_maxP          =   mean(OUT.maxP); 
     Table_5d_RofE          =   mean(OUT.RofE); 
     Table_5e_nulE          =   mean(OUT.nulE); 
     Table_5f_monR          =   DM2_filtered_mean(OUT.monR, 50, 1); %don't use track lost
								

%------------------------------------------------
% POST-PROCESSING
%------------------------------------------------  
    labels_datasets         =   {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11'};   
    labels_algos            =   {'PCA', 'TSVQ', 'maxP', 'RofE', 'nulE', 'monR'};
    labels_configs          =   {'PCA (8), TSVQ (3), RVQ (8x2)', 'PCA (16), TSVQ (4), RVQ (8x4)', 'PCA (32), TSVQ (5), RVQ (8x8)'};
 
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
    ylabel('tracking error, best');
    axis([1 6 0 15]);
    UTIL_FILE_save2pdf('temp/results_final_1a_best', gcf, 300);
 

    figure;
    bar(DM2_cnt_min_row_element(Table_1_best));
    set(gca, 'XTickLabel', labels_algos);
    xlabel('learning algorithms');
    ylabel('tracking error, best, percentage');
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
    ylabel('tracking error, mean');
    axis([1 6 0 15]);
    UTIL_FILE_save2pdf('temp/results_final_2a_mean', gcf, 300);

    figure;
    bar(DM2_cnt_min_row_element(Table_2_mean));
    set(gca, 'XTickLabel', labels_algos);
    xlabel('learning algorithms');
    ylabel('tracking error, mean, percentage');
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
    ylabel('tracking error, PCA_{16}, TSVQ_3, RVQ_{8x2}, percentage');
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
    ylabel('tracking error, PCA_{32}, TSVQ_4, RVQ_{8x4}, percentage');
    axis([0 7 0 100]);
    grid on;
    UTIL_FILE_save2pdf('temp/results_final_4b_32_percent', gcf, 300);
        
%figure 5
    figure;
    bar(Table_5a_pca_);
    set(gca, 'XTickLabel', {'8', '16', '32'});
    xlabel('PCA, number of eigenvectors (Q)');
    ylabel('tracking error');
    axis([0 4 0 15]);
    grid on;
    UTIL_FILE_save2pdf('temp/results_final_5a_pca_', gcf, 300);

    figure;
    bar(Table_5b_tsvq);
    set(gca, 'XTickLabel', {'3', '4', '5'});
    xlabel('TSVQ, number of stages (P)');
    ylabel('tracking error');
    axis([0 4 0 15]);
    grid on;
    UTIL_FILE_save2pdf('temp/results_final_5b_tsvq', gcf, 300);
    
    figure;
    bar(Table_5c_maxP);
    set(gca, 'XTickLabel', {'8x2', '8x4', '8x8'});
    xlabel('maxP, number of stages x number of code-vectors per stage (PxM)');
    ylabel('tracking error');
    axis([0 4 0 15]);
    grid on;
    UTIL_FILE_save2pdf('temp/results_final_5c_maxP', gcf, 300);

    figure;
    bar(Table_5d_RofE);
    set(gca, 'XTickLabel', {'8x2', '8x4', '8x8'});
    xlabel('RofE, number of stages x number of code-vectors per stage (PxM)');
    ylabel('tracking error');
    axis([0 4 0 15]);
    grid on;
    UTIL_FILE_save2pdf('temp/results_final_5d_RofE', gcf, 300);

    
    figure;
    bar(Table_5e_nulE);
    set(gca, 'XTickLabel', {'8x2', '8x4', '8x8'});
    xlabel('nulE, number of stages x number of code-vectors per stage (PxM)');
    ylabel('tracking error');
    axis([0 4 0 15]);
    grid on;
    UTIL_FILE_save2pdf('temp/results_final_5e_nulE', gcf, 300);

    figure;
    bar(Table_5f_monR);
    set(gca, 'XTickLabel', {'8x2', '8x4', '8x8'});
    xlabel('monR, number of stages x number of code-vectors per stage (PxM)');
    ylabel('tracking error');
    axis([0 4 0 15]);
    grid on;
    UTIL_FILE_save2pdf('temp/results_final_5f_monR', gcf, 300);
    
    
%tables
    Table_1_best            =   [Table_1_best ; DM2_cnt_min_row_element(Table_1_best)];
    Table_2_mean            =   [Table_2_mean ; DM2_cnt_min_row_element(Table_2_mean)];

    Table_3_16              =   [Table_3_16   ; DM2_cnt_min_row_element(Table_3_16)];
    Table_4_32              =   [Table_4_32   ; DM2_cnt_min_row_element(Table_4_32)];
    Table_5a_pca_           =   [Table_5a_pca_  mean(Table_5a_pca_)];
    Table_5b_tsvq           =   [Table_5b_tsvq  mean(Table_5b_tsvq)];
    Table_5c_maxP           =   [Table_5c_maxP  mean(Table_5c_maxP)];
    Table_5d_RofE           =   [Table_5d_RofE  mean(Table_5d_RofE)];
    Table_5e_nulE           =   [Table_5e_nulE  mean(Table_5e_nulE)];
    Table_5f_monR           =   [Table_5f_monR  mean(Table_5f_monR)];
    
    labels_datasets         =   [labels_datasets ' \% best'];
    
    UTIL_matrix2latex(Table_1_best,   'temp/results_final_1_best.tex',   'rowLabels', labels_datasets, 'columnLabels', labels_algos, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(Table_2_mean,   'temp/results_final_2_mean.tex',   'rowLabels', labels_datasets, 'columnLabels', labels_algos, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(Table_3_16,     'temp/results_final_3_16.tex',     'rowLabels', labels_datasets, 'columnLabels', labels_algos, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(Table_4_32,     'temp/results_final_4_32.tex',     'rowLabels', labels_datasets, 'columnLabels', labels_algos, 'alignment', 'c', 'format', '%-6.2f');
    
    UTIL_matrix2latex(Table_5a_pca_,   'temp/results_final_5a_pca_.tex', 'columnLabels', {'8',   '16',   '32',   'mean'}, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(Table_5b_tsvq,   'temp/results_final_5b_tsvq.tex', 'columnLabels', {'3',   '4' ,   '5',    'mean'}, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(Table_5c_maxP,   'temp/results_final_5c_maxP.tex', 'columnLabels', {'8x2', '8x4' , '8x8',  'mean'}, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(Table_5d_RofE,   'temp/results_final_5d_RofE.tex', 'columnLabels', {'8x2', '8x4' , '8x8',  'mean'}, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(Table_5e_nulE,   'temp/results_final_5e_nulE.tex', 'columnLabels', {'8x2', '8x4' , '8x8',  'mean'}, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(Table_5f_monR,   'temp/results_final_5f_monR.tex', 'columnLabels', {'8x2', '8x4' , '8x8',  'mean'}, 'alignment', 'c', 'format', '%-6.2f');
    