clear;
clc;
close all;
%------------------------------------------------
% PRE-PROCESSING
%------------------------------------------------
%read results
    OUT                     =   results_numbers();      %read numbers


%------------------------------------------------
% PROCESSING: PCA
%------------------------------------------------
                           
%------------------------------------------------
% PROCESSING: TSVQ
%------------------------------------------------
%     Table_rvq__tstD         = [ DM2_filtered_mean(OUT.rvq__1_Dudek__, -1, 1);
%                                 DM2_filtered_mean(OUT.rvq__2_david__, -1, 1);
%                                 DM2_filtered_mean(OUT.rvq__3_sylv___, -1, 1);
%                                 DM2_filtered_mean(OUT.rvq__5_fish___, -1, 1);
%                                 DM2_filtered_mean(OUT.rvq__6_car4___, -1, 1);
%                                 DM2_filtered_mean(OUT.rvq__7_car11__, -1, 1);];
%     temp                    =   mean(Table_rvq__tstD);
%     Table_rvq__tstD         =   [Table_rvq__tstD;temp]';
% 
% 
%     Table_rvq__M            = [ DM2_filtered_mean(OUT.rvq__1_Dudek__, -1, 2) ...
%                                 DM2_filtered_mean(OUT.rvq__2_david__, -1, 2) ...
%                                 DM2_filtered_mean(OUT.rvq__3_sylv___, -1, 2) ...
%                                 DM2_filtered_mean(OUT.rvq__5_fish___, -1, 2) ...
%                                 DM2_filtered_mean(OUT.rvq__6_car4___, -1, 2) ...
%                                 DM2_filtered_mean(OUT.rvq__7_car11__, -1, 2)];
%     temp                    =   mean(Table_rvq__M, 2);
%     Table_rvq__M            =   [Table_rvq__M temp];
% 
% 
% 
%     Table_tsvq              = [ OUT.tsvq_1_Dudek__ ...
%                                 OUT.tsvq_2_david__ ...
%                                 OUT.tsvq_3_sylv___ ...
%                                 OUT.tsvq_5_fish___ ...
%                                 OUT.tsvq_6_car4___ ...
%                                 OUT.tsvq_7_car11__ ];
%     temp                    =   mean(Table_tsvq, 2);
%     Table_tsvq              =   [Table_tsvq temp];
%     
% %comparison best
%     Table_1__best           = [ UTIL_min_ignoring_a_num(OUT.pca__1_Dudek__, -1)     UTIL_min_ignoring_a_num(OUT.tsvq_1_Dudek__, -1)    UTIL_min_ignoring_a_num(OUT.rvq__1_Dudek__, -1)    ;
%                                 UTIL_min_ignoring_a_num(OUT.pca__2_david__, -1)     UTIL_min_ignoring_a_num(OUT.tsvq_2_david__, -1)    UTIL_min_ignoring_a_num(OUT.rvq__2_david__, -1)    ;
%                                 UTIL_min_ignoring_a_num(OUT.pca__3_sylv___, -1)     UTIL_min_ignoring_a_num(OUT.tsvq_3_sylv___, -1)    UTIL_min_ignoring_a_num(OUT.rvq__3_sylv___, -1)    ;
%                                 UTIL_min_ignoring_a_num(OUT.pca__5_fish___, -1)     UTIL_min_ignoring_a_num(OUT.tsvq_5_fish___, -1)    UTIL_min_ignoring_a_num(OUT.rvq__5_fish___, -1)    ;
%                                 UTIL_min_ignoring_a_num(OUT.pca__6_car4___, -1)     UTIL_min_ignoring_a_num(OUT.tsvq_6_car4___, -1)    UTIL_min_ignoring_a_num(OUT.rvq__6_car4___, -1)    ;
%                                 UTIL_min_ignoring_a_num(OUT.pca__7_car11__, -1)     UTIL_min_ignoring_a_num(OUT.tsvq_7_car11__, -1)    UTIL_min_ignoring_a_num(OUT.rvq__7_car11__, -1)    ];
% 
%     temp1                   =   mean(Table_1__best);
%     Table_1__best           =   [Table_1__best;temp1]';
% 
%     
% %comparison DoF_16 (PCA: 16, TSVQ: 3 stages, RVQ: 8x2)
%     Table_2a_16             = [ OUT.pca__1_Dudek__(2)            OUT.tsvq_1_Dudek__(1)           UTIL_min_ignoring_a_num(OUT.rvq__1_Dudek__(1,:), -1)    ; 
%                                 OUT.pca__2_david__(2)            OUT.tsvq_2_david__(1)           UTIL_min_ignoring_a_num(OUT.rvq__2_david__(1,:), -1)    ;
%                                 OUT.pca__3_sylv___(2)            OUT.tsvq_3_sylv___(1)           UTIL_min_ignoring_a_num(OUT.rvq__3_sylv___(1,:), -1)    ;
%                                 OUT.pca__5_fish___(2)            OUT.tsvq_5_fish___(1)           UTIL_min_ignoring_a_num(OUT.rvq__5_fish___(1,:), -1)    ;
%                                 OUT.pca__6_car4___(2)            OUT.tsvq_6_car4___(1)           UTIL_min_ignoring_a_num(OUT.rvq__6_car4___(1,:), -1)    ;
%                                 OUT.pca__7_car11__(2)            OUT.tsvq_7_car11__(1)           UTIL_min_ignoring_a_num(OUT.rvq__7_car11__(1,:), -1)    ];
%                             
%     temp2                   =   mean(Table_2a_16);
%     Table_2a_16             =   [Table_2a_16;temp2]';
% 
%     
% %comparison DoF_32 (PCA: 32, TSVQ: 4 stages, RVQ: 8x4)   
%     Table_2b_32             = [ OUT.pca__1_Dudek__(3)           OUT.tsvq_1_Dudek__(2)           min(OUT.rvq__1_Dudek__(2,:))    ;
%                                 OUT.pca__2_david__(3)           OUT.tsvq_2_david__(2)           min(OUT.rvq__2_david__(2,:))    ;
%                                 OUT.pca__3_sylv___(3)           OUT.tsvq_3_sylv___(2)           min(OUT.rvq__3_sylv___(2,:))    ;
%                                 OUT.pca__5_fish___(3)           OUT.tsvq_5_fish___(2)           min(OUT.rvq__5_fish___(2,:))    ;
%                                 OUT.pca__6_car4___(3)           OUT.tsvq_6_car4___(2)           min(OUT.rvq__6_car4___(2,:))    ;
%                                 OUT.pca__7_car11__(3)           OUT.tsvq_7_car11__(2)           min(OUT.rvq__7_car11__(2,:))    ];
%                             
%     temp3                   =   mean(Table_2b_32);
%     Table_2b_32             =   [Table_2b_32;temp3]';


%------------------------------------------------
% POST-PROCESSING
%------------------------------------------------  
    labels_datasets         =   {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11', 'mean'};      
    labels_pca__8_16_32     =   {'8', '16', '32'};
    labels_tsvq_3_4_5       =   {'3', '4', '5'};    
    labels_rvq__2_4_8_12_16 =   {'2', '4', '8', '12', '16'};  
  

    
% %Appendix A
  
%     %TSVQ
%     UTIL_matrix2latex(OUT.tsvq_1_Dudek__,   'AppA_table_tsvq_1_Dudek__.tex',    'rowLabels', labels_tsvq_3_4_5,                                    'alignment', 'c', 'format', '%-6.2f');
%     UTIL_matrix2latex(OUT.tsvq_2_david__,   'AppA_table_tsvq_2_david__.tex',    'rowLabels', labels_tsvq_3_4_5,                                    'alignment', 'c', 'format', '%-6.2f');
%     UTIL_matrix2latex(OUT.tsvq_3_sylv___,   'AppA_table_tsvq_3_sylv___.tex',    'rowLabels', labels_tsvq_3_4_5,                                    'alignment', 'c', 'format', '%-6.2f');
%     UTIL_matrix2latex(OUT.tsvq_5_fish___,   'AppA_table_tsvq_5_fish___.tex',    'rowLabels', labels_tsvq_3_4_5,                                    'alignment', 'c', 'format', '%-6.2f');
%     UTIL_matrix2latex(OUT.tsvq_6_car4___,   'AppA_table_tsvq_6_car4___.tex',    'rowLabels', labels_tsvq_3_4_5,                                    'alignment', 'c', 'format', '%-6.2f');
%     UTIL_matrix2latex(OUT.tsvq_7_car11__,   'AppA_table_tsvq_7_car11__.tex',    'rowLabels', labels_tsvq_3_4_5,                                    'alignment', 'c', 'format', '%-6.2f');
% 
%     %RVQ    
%     UTIL_matrix2latex(OUT.rvq__1_Dudek__,   'AppA_table_rvq__1_Dudek__.tex',    'rowLabels', labels_rvq__2_4_8_12_16, 'columnLabels', {'maxQ', 'RofE', 'nulE', 'monR'}, 'alignment', 'c', 'format', '%-6.2f');
%     UTIL_matrix2latex(OUT.rvq__2_david__,   'AppA_table_rvq__2_david__.tex',    'rowLabels', labels_rvq__2_4_8_12_16, 'columnLabels', {'maxQ', 'RofE', 'nulE', 'monR'}, 'alignment', 'c', 'format', '%-6.2f');
%     UTIL_matrix2latex(OUT.rvq__3_sylv___,   'AppA_table_rvq__3_sylv___.tex',    'rowLabels', labels_rvq__2_4_8_12_16, 'columnLabels', {'maxQ', 'RofE', 'nulE', 'monR'}, 'alignment', 'c', 'format', '%-6.2f');
%     UTIL_matrix2latex(OUT.rvq__5_fish___,   'AppA_table_rvq__5_fish___.tex',    'rowLabels', labels_rvq__2_4_8_12_16, 'columnLabels', {'maxQ', 'RofE', 'nulE', 'monR'}, 'alignment', 'c', 'format', '%-6.2f');
%     UTIL_matrix2latex(OUT.rvq__6_car4___,   'AppA_table_rvq__6_car4___.tex',    'rowLabels', labels_rvq__2_4_8_12_16, 'columnLabels', {'maxQ', 'RofE', 'nulE', 'monR'}, 'alignment', 'c', 'format', '%-6.2f');
%     UTIL_matrix2latex(OUT.rvq__7_car11__,   'AppA_table_rvq__7_car11__.tex',    'rowLabels', labels_rvq__2_4_8_12_16, 'columnLabels', {'maxQ', 'RofE', 'nulE', 'monR'}, 'alignment', 'c', 'format', '%-6.2f');

%     %comparisons    
%     UTIL_matrix2latex(Table_1__best,        'AppB_tables_Table_1__best.tex',  'rowLabels', labels_datasets,         'columnLabels', {'PCA', 'TSVQ', 'RVQ'},'alignment', 'c', 'format', '%-6.2f');
%     UTIL_matrix2latex(Table_2a_16,          'AppB_tables_Table_2a_16.tex','rowLabels', labels_datasets,         'columnLabels', {'PCA', 'TSVQ', 'RVQ'},'alignment', 'c', 'format', '%-6.2f');
%     UTIL_matrix2latex(Table_2b_32,          'AppB_tables_Table_2b_32.tex','rowLabels', labels_datasets,         'columnLabels', {'PCA', 'TSVQ', 'RVQ'},'alignment', 'c', 'format', '%-6.2f');

%1. PCA


% %2. TSVQ        
%     figure;
%     plot(Table_tsvq(1,:), 'r*-'); hold on; %8
%     plot(Table_tsvq(2,:), 'gs-');          %16
%     plot(Table_tsvq(3,:), 'bd-');          %32
%     legend({'3 stages', '4 stages', '5 stages'});
%     grid on;
%     axis([1 7 0 15])
%     set(gca, 'XTickLabel', {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11', 'average'});
%     xlabel('6 datasets, and average over all 6');
%     ylabel('best rms tracking error over all configurations');
%     UTIL_FILE_save2pdf('temp/Table_tsvq.pdf', gcf, 300);
%     
% %3a. rvq    
%     %M
%     figure;
%     plot(Table_rvq__M(1,:), 'r*-'); hold on; %2
%     plot(Table_rvq__M(2,:), 'gs-');          %4
%     plot(Table_rvq__M(3,:), 'bd-');          %8
%     plot(Table_rvq__M(4,:), 'k^-');          %12
%     plot(Table_rvq__M(5,:), 'mx-');          %16
%     legend({'8x2', '8x4', '8x8', '8x12', '8x16'});
%     grid on;
%     axis([1 7 0 15])
%     set(gca, 'XTickLabel', {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11', 'average'});
%     xlabel('6 datasets, and average over all 6');
%     ylabel('best rms tracking error over all configurations');
%     UTIL_FILE_save2pdf('temp/Table_rvq__M.pdf', gcf, 300);
%     
% %3b. RVQ    
%     %tstD
%     figure;
%     plot(Table_rvq__tstD(1,:), 'r*-'); hold on; %maxP
%     plot(Table_rvq__tstD(2,:), 'gs-');          %RofE
%     plot(Table_rvq__tstD(3,:), 'bd-');          %nulE
%     plot(Table_rvq__tstD(4,:), 'k^-');          %monR
%     legend({'maxP', 'RofE', 'nulE', 'monR'});
%     grid on;
%     axis([1 7 0 15])
%     set(gca, 'XTickLabel', {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11', 'average'});
%     xlabel('6 datasets, and average over all 6');
%     ylabel('best rms tracking error over all configurations');
%     UTIL_FILE_save2pdf('temp/Table_rvq__tstD.pdf', gcf, 300);
%     
% 
%     
%     
% %Comparisons    
%     figure;
%     plot(Table_1__best(1,:), 'g*-'); hold on;%PCA
%     plot(Table_1__best(2,:), 'bs-'); %TSVQ
%     plot(Table_1__best(3,:), 'rd-'); %RVQ
%     legend({'PCA', 'TSVQ', 'RVQ'});
%     grid on;
%     axis([1 7 0 15])
%     set(gca, 'XTickLabel', {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11', 'average'});
%     xlabel('6 datasets, and average over all 6');
%     ylabel('best rms tracking error over all configurations');
%     UTIL_FILE_save2pdf('temp/Table_1__best.pdf', gcf, 300);
%     
%     figure;
%     plot(Table_2a_16(1,:), 'g*-'); hold on;%PCA
%     plot(Table_2a_16(2,:), 'bs-'); %TSVQ
%     plot(Table_2a_16(3,:), 'rd-'); %RVQ
%     legend({'PCA', 'TSVQ', 'RVQ'});
%     grid on;
%     axis([1 7 0 15])
%     set(gca, 'XTickLabel', {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11', 'average'});
%     xlabel('6 datasets, and average over all 6');
%     ylabel('PCA_{16}, TSVQ_{3}, RVQ_{8x2} rms tracking error');    
%     UTIL_FILE_save2pdf('temp/Table_2a_16.pdf', gcf, 300);
%     
%     figure;
%     plot(Table_2b_32(1,:), 'g*-'); hold on;%PCA
%     plot(Table_2b_32(2,:), 'bs-'); %TSVQ
%     plot(Table_2b_32(3,:), 'rd-'); %RVQ
%     legend({'PCA', 'TSVQ', 'RVQ'});
%     grid on;
%     axis([1 7 0 15])
%     set(gca, 'XTickLabel', {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11', 'average'});
%     xlabel('6 datasets, and average over all 6');
%     ylabel('PCA_{32}, TSVQ_{4}, RVQ_{8x4} rms tracking error');
%     UTIL_FILE_save2pdf('temp/Table_2b_32.pdf', gcf, 300);