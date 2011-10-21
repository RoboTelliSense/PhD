clear;
clc;
close all;
%------------------------------------------------
% PRE-PROCESSING
%------------------------------------------------
    OUT                     =   results_numbers();      %read numbers


%------------------------------------------------
% PROCESSING
%------------------------------------------------
%comparison best
    comparison_best         = [ min(min(OUT.pca__1_Dudek__))     min(min(OUT.tsvq_1_Dudek__))    min(min(OUT.rvq__1_Dudek__))    ;
                                min(min(OUT.pca__2_david__))     min(min(OUT.tsvq_2_david__))    min(min(OUT.rvq__2_david__))    ;
                                min(min(OUT.pca__3_sylv___))     min(min(OUT.tsvq_3_sylv___))    min(min(OUT.rvq__3_sylv___))    ;
                                min(min(OUT.pca__5_fish___))     min(min(OUT.tsvq_5_fish___))    min(min(OUT.rvq__5_fish___))    ;
                                min(min(OUT.pca__6_car4___))     min(min(OUT.tsvq_6_car4___))    min(min(OUT.rvq__6_car4___))    ;
                                min(min(OUT.pca__7_car11__))     min(min(OUT.tsvq_7_car11__))    min(min(OUT.rvq__7_car11__))    ];

    temp1                   =   mean(comparison_best);
    comparison_best         =   [comparison_best;temp1]

    
%comparison DoF_16 (PCA: 16, TSVQ: 3 stages, RVQ: 8x2)
    comparison_DoF_16       = [ OUT.pca__1_Dudek__(2)            OUT.tsvq_1_Dudek__(1)           min(OUT.rvq__1_Dudek__(1,:))    ; 
                                OUT.pca__2_david__(2)            OUT.tsvq_2_david__(1)           min(OUT.rvq__2_david__(1,:))    ;
                                OUT.pca__3_sylv___(2)            OUT.tsvq_3_sylv___(1)           min(OUT.rvq__3_sylv___(1,:))    ;
                                OUT.pca__5_fish___(2)            OUT.tsvq_5_fish___(1)           min(OUT.rvq__5_fish___(1,:))    ;
                                OUT.pca__6_car4___(2)            OUT.tsvq_6_car4___(1)           min(OUT.rvq__6_car4___(1,:))    ;
                                OUT.pca__7_car11__(2)            OUT.tsvq_7_car11__(1)           min(OUT.rvq__7_car11__(1,:))    ];
                            
    temp2                   =   mean(comparison_DoF_16);
    comparison_DoF_16       =   [comparison_DoF_16;temp2]

    
%comparison DoF_32 (PCA: 32, TSVQ: 4 stages, RVQ: 8x4)   
    comparison_DoF_32       = [ OUT.pca__1_Dudek__(3)           OUT.tsvq_1_Dudek__(2)           min(OUT.rvq__1_Dudek__(2,:))    ;
                                OUT.pca__2_david__(3)           OUT.tsvq_2_david__(2)           min(OUT.rvq__2_david__(2,:))    ;
                                OUT.pca__3_sylv___(3)           OUT.tsvq_3_sylv___(2)           min(OUT.rvq__3_sylv___(2,:))    ;
                                OUT.pca__5_fish___(3)           OUT.tsvq_5_fish___(2)           min(OUT.rvq__5_fish___(2,:))    ;
                                OUT.pca__6_car4___(3)           OUT.tsvq_6_car4___(2)           min(OUT.rvq__6_car4___(2,:))    ;
                                OUT.pca__7_car11__(3)           OUT.tsvq_7_car11__(2)           min(OUT.rvq__7_car11__(2,:))    ];
                            
    temp3                   =   mean(comparison_DoF_32);
    comparison_DoF_32       =   [comparison_DoF_32;temp3]


%------------------------------------------------
% POST-PROCESSING
%------------------------------------------------  
    labels_datasets         =   {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11', 'mean'};      
    labels_pca__8_16_32     =   {'8', '16', '32'};
    labels_tsvq_3_4_5       =   {'3', '4', '5'};    
    labels_rvq__2_4_8_12_16 =   {'2', '4', '8', '12', '16'};  
    labels_tstD             =   {'maxQ', 'RofE', 'nulE', 'monR'};
    labels_algos            =   {'PCA', 'TSVQ', 'RVQ'};
  

    
%Appendix A
    %PCA
    UTIL_matrix2latex(OUT.pca__1_Dudek__,   'AppA_table_pca__1_Dudek__.tex',    'rowLabels', labels_pca__8_16_32,                                  'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(OUT.pca__2_david__,   'AppA_table_pca__2_david__.tex',    'rowLabels', labels_pca__8_16_32,                                  'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(OUT.pca__3_sylv___,   'AppA_table_pca__3_sylv___.tex',    'rowLabels', labels_pca__8_16_32,                                  'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(OUT.pca__5_fish___,   'AppA_table_pca__5_fish___.tex',    'rowLabels', labels_pca__8_16_32,                                  'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(OUT.pca__6_car4___,   'AppA_table_pca__6_car4___.tex',    'rowLabels', labels_pca__8_16_32,                                  'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(OUT.pca__7_car11__,   'AppA_table_pca__7_car11__.tex',    'rowLabels', labels_pca__8_16_32,                                  'alignment', 'c', 'format', '%-6.2f');
    
    %TSVQ
    UTIL_matrix2latex(OUT.tsvq_1_Dudek__,   'AppA_table_tsvq_1_Dudek__.tex',    'rowLabels', labels_tsvq_3_4_5,                                    'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(OUT.tsvq_2_david__,   'AppA_table_tsvq_2_david__.tex',    'rowLabels', labels_tsvq_3_4_5,                                    'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(OUT.tsvq_3_sylv___,   'AppA_table_tsvq_3_sylv___.tex',    'rowLabels', labels_tsvq_3_4_5,                                    'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(OUT.tsvq_5_fish___,   'AppA_table_tsvq_5_fish___.tex',    'rowLabels', labels_tsvq_3_4_5,                                    'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(OUT.tsvq_6_car4___,   'AppA_table_tsvq_6_car4___.tex',    'rowLabels', labels_tsvq_3_4_5,                                    'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(OUT.tsvq_7_car11__,   'AppA_table_tsvq_7_car11__.tex',    'rowLabels', labels_tsvq_3_4_5,                                    'alignment', 'c', 'format', '%-6.2f');

    %RVQ    
    UTIL_matrix2latex(OUT.rvq__1_Dudek__,   'AppA_table_rvq__1_Dudek__.tex',    'rowLabels', labels_rvq__2_4_8_12_16, 'columnLabels', labels_tstD, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(OUT.rvq__2_david__,   'AppA_table_rvq__2_david__.tex',    'rowLabels', labels_rvq__2_4_8_12_16, 'columnLabels', labels_tstD, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(OUT.rvq__3_sylv___,   'AppA_table_rvq__3_sylv___.tex',    'rowLabels', labels_rvq__2_4_8_12_16, 'columnLabels', labels_tstD, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(OUT.rvq__5_fish___,   'AppA_table_rvq__5_fish___.tex',    'rowLabels', labels_rvq__2_4_8_12_16, 'columnLabels', labels_tstD, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(OUT.rvq__6_car4___,   'AppA_table_rvq__6_car4___.tex',    'rowLabels', labels_rvq__2_4_8_12_16, 'columnLabels', labels_tstD, 'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(OUT.rvq__7_car11__,   'AppA_table_rvq__7_car11__.tex',    'rowLabels', labels_rvq__2_4_8_12_16, 'columnLabels', labels_tstD, 'alignment', 'c', 'format', '%-6.2f');

%Appendix B    
    UTIL_matrix2latex(comparison_best,      'tables_comparison_best.tex',       'rowLabels', labels_datasets,         'columnLabels', labels_algos,'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(comparison_DoF_16,    'tables_comparison_DoF_16.tex',     'rowLabels', labels_datasets,         'columnLabels', labels_algos,'alignment', 'c', 'format', '%-6.2f');
    UTIL_matrix2latex(comparison_DoF_32,    'tables_comparison_DoF_32.tex',     'rowLabels', labels_datasets,         'columnLabels', labels_algos,'alignment', 'c', 'format', '%-6.2f');
    
    figure;
    subplot(2,2,1)
    plot(comparison_best(:,1), 'g*-'); hold on;%PCA
    plot(comparison_best(:,2), 'bs-'); %TSVQ
    plot(comparison_best(:,3), 'rd-'); %RVQ
    legend(labels_algos);
    grid on;
    axis([1 7 0 15])
    set(gca, 'XTickLabel', {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11', 'average'});
    xlabel('6 datasets, and average over all 6');
    ylabel('best rms tracking error over all configurations');
    
    subplot(2,2,3)
    plot(comparison_DoF_16(:,1), 'g*-'); hold on;%PCA
    plot(comparison_DoF_16(:,2), 'bs-'); %TSVQ
    plot(comparison_DoF_16(:,3), 'rd-'); %RVQ
    legend(labels_algos);
    grid on;
    axis([1 7 0 15])
    set(gca, 'XTickLabel', {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11', 'average'});
    xlabel('6 datasets, and average over all 6');
    ylabel('PCA_{16}, TSVQ_{3}, RVQ_{8x2} rms tracking error');    
    
    subplot(2,2,4)
    plot(comparison_DoF_32(:,1), 'g*-'); hold on;%PCA
    plot(comparison_DoF_32(:,2), 'bs-'); %TSVQ
    plot(comparison_DoF_32(:,3), 'rd-'); %RVQ
    legend(labels_algos);
    grid on;
    axis([1 7 0 15])
    set(gca, 'XTickLabel', {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11', 'average'});
    xlabel('6 datasets, and average over all 6');
    ylabel('PCA_{32}, TSVQ_{4}, RVQ_{8x4} rms tracking error');      