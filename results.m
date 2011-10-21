clear;
clc;
close all;
%------------------------------------------------
% PRE-PROCESSING
%------------------------------------------------
    OUT                     =   results_tables();


%------------------------------------------------
% PROCESSING
%------------------------------------------------
%comparison best
    comparison_best         = [ min(min(OUT.pca_Dudek))         min(min(OUT.tsvq_Dudek))        min(min(OUT.ervq_Dudek))         ;
                                min(min(OUT.pca_davidin300))    min(min(OUT.tsvq_davidin300))   min(min(OUT.ervq_davidin300))    ;
                                min(min(OUT.pca_sylv))          min(min(OUT.tsvq_sylv))         min(min(OUT.ervq_sylv))          ;
                                min(min(OUT.pca_fish))          min(min(OUT.tsvq_fish))         min(min(OUT.ervq_fish))          ;
                                min(min(OUT.pca_car4))          min(min(OUT.tsvq_car4))         min(min(OUT.ervq_car4))          ;
                                min(min(OUT.pca_car11))         min(min(OUT.tsvq_car11))        min(min(OUT.ervq_car11))        ];
    temp1                   =   mean(comparison_best);
    comparison_best         =   [comparison_best;temp1]

%comparison DoF_16
    comparison_DoF_16       = [ OUT.pca_Dudek(2)        OUT.tsvq_Dudek(1)       min(OUT.ervq_Dudek(1,:));
                                OUT.pca_davidin300(2)   OUT.tsvq_davidin300(1)  min(OUT.ervq_davidin300(1,:));
                                OUT.pca_sylv(2)         OUT.tsvq_sylv(1)        min(OUT.ervq_sylv(1,:));
                                OUT.pca_fish(2)         OUT.tsvq_fish(1)        min(OUT.ervq_fish(1,:));
                                OUT.pca_car4(2)         OUT.tsvq_car4(1)        min(OUT.ervq_car4(1,:));
                                OUT.pca_car11(2)        OUT.tsvq_car11(1)       min(OUT.ervq_car11(1,:))];
    temp2                   =   mean(comparison_DoF_16);
    comparison_DoF_16       =   [comparison_DoF_16;temp2]

%comparison DoF_16    
    comparison_DoF_32       = [ OUT.pca_Dudek(3)       OUT.tsvq_Dudek(2)       min(OUT.ervq_Dudek(2,:))         ;
                                OUT.pca_davidin300(3)  OUT.tsvq_davidin300(2)  min(OUT.ervq_davidin300(2,:))    ;
                                OUT.pca_sylv(3)        OUT.tsvq_sylv(2)        min(OUT.ervq_sylv(2,:))          ;
                                OUT.pca_fish(3)        OUT.tsvq_fish(2)        min(OUT.ervq_fish(2,:))          ;
                                OUT.pca_car4(3)        OUT.tsvq_car4(2)        min(OUT.ervq_car4(2,:))          ;
                                OUT.pca_car11(3)       OUT.tsvq_car11(2)       min(OUT.ervq_car11(2,:))         ];
    temp2                   =   mean(comparison_DoF_32);
    comparison_DoF_32       =   [comparison_DoF_32;temp2]


%------------------------------------------------
% POST-PROCESSING
%------------------------------------------------              
    rowLabels               =   {'2', '4', '8', '12', '16'};  
    rowLabels2              =   {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11', 'mean'};  
    colLabels               =   {'maxQ', 'RofE', 'nulE', 'monR'};
    colLabels2              =   {'PCA', 'TSVQ', 'RVQ'};

%mesh(Dudek)
set(gca, 'XTickLabel', colLabels);
set(gca, 'YTickLabel', [2 4 8 12 16]);
  
UTIL_matrix2latex(OUT.ervq_Dudek,       'tables_1_Dudek_rvq.tex',          'rowLabels', rowLabels, 'columnLabels', colLabels, 'alignment', 'c', 'format', '%-6.2f');
UTIL_matrix2latex(OUT.ervq_davidin300,  'tables_2_davidin300_rvq.tex',     'rowLabels', rowLabels, 'columnLabels', colLabels, 'alignment', 'c', 'format', '%-6.2f');
UTIL_matrix2latex(OUT.ervq_sylv,        'tables_3_sylv_rvq.tex',           'rowLabels', rowLabels, 'columnLabels', colLabels, 'alignment', 'c', 'format', '%-6.2f');
UTIL_matrix2latex(OUT.ervq_fish,        'tables_5_fish_rvq.tex',           'rowLabels', rowLabels, 'columnLabels', colLabels, 'alignment', 'c', 'format', '%-6.2f');
UTIL_matrix2latex(OUT.ervq_car4,        'tables_6_car4_rvq.tex',           'rowLabels', rowLabels, 'columnLabels', colLabels, 'alignment', 'c', 'format', '%-6.2f');
UTIL_matrix2latex(OUT.ervq_car11,       'tables_7_car11_rvq.tex',          'rowLabels', rowLabels, 'columnLabels', colLabels, 'alignment', 'c', 'format', '%-6.2f');
UTIL_matrix2latex(comparison_best,      'tables_comparison_best.tex',      'rowLabels', rowLabels2,'columnLabels', colLabels2,'alignment', 'c', 'format', '%-6.2f');
UTIL_matrix2latex(comparison_DoF_16,    'tables_comparison_DoF_16.tex',    'rowLabels', rowLabels2,'columnLabels', colLabels2,'alignment', 'c', 'format', '%-6.2f');
UTIL_matrix2latex(comparison_DoF_32,    'tables_comparison_DoF_32.tex',    'rowLabels', rowLabels2,'columnLabels', colLabels2, 'alignment', 'c', 'format', '%-6.2f');

% a=[7.96 7.07 8.21 8.34 8.96];
% mean(a);
% a=[19.19 11.08 7.27 9.60];
% mean(a);