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
    Table_1__best           = [ min(    OUT.pca,                        [], 2)  ...
                                min(    OUT.tsvq,                       [], 2)  ...
                                min(    OUT.rvq1(:,1:3),                [], 2)  ...
                                min(    OUT.rvq2(:,1:3),                [], 2)  ...
                                min(    OUT.rvq3(:,1:3),                [], 2)  ...
                                min(    OUT.rvq4(:,1:3),                [], 2)  ];
                            
    Table_1__mean           = [ mean(   OUT.pca,                            2)  ...
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
                            
                            
    Table_1__best           =   [Table_1__best ; DM2_cnt_min_row_element(Table_1__best)]
    Table_1__mean           =   [Table_1__mean ; DM2_cnt_min_row_element(Table_1__mean)]
    
    Table_2a_16             =   [Table_2a_16   ; DM2_cnt_min_row_element(Table_2a_16)]
    Table_2b_32             =   [Table_2b_32   ; DM2_cnt_min_row_element(Table_2b_32)]
    
								

%------------------------------------------------
% POST-PROCESSING
%------------------------------------------------  
    labels_datasets         =   {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11', ' \% best'};   
    labels_algos            =   {'PCA', 'TSVQ', 'maxP', 'RofE', 'nulE', 'monR'};
    labels_pca__8_16_32     =   {'8', '16', '32'};
    labels_tsvq_3_4_5       =   {'3', '4', '5'};    
    labels_rvq__2_4_8_12_16 =   {'2', '4', '8', '12', '16'};  
  

     
%     %comparisons    
     UTIL_matrix2latex(Table_1__best, 'temp/Table_1a_best.tex', 'rowLabels', labels_datasets, 'columnLabels', labels_algos, 'alignment', 'c', 'format', '%-6.2f');
     UTIL_matrix2latex(Table_1__mean, 'temp/Table_1b_mean.tex', 'rowLabels', labels_datasets, 'columnLabels', labels_algos, 'alignment', 'c', 'format', '%-6.2f');
     UTIL_matrix2latex(Table_2a_16,   'temp/Table_2a_16.tex',   'rowLabels', labels_datasets, 'columnLabels', labels_algos, 'alignment', 'c', 'format', '%-6.2f');
     UTIL_matrix2latex(Table_2b_32,   'temp/Table_2b_32.tex',   'rowLabels', labels_datasets, 'columnLabels', labels_algos, 'alignment', 'c', 'format', '%-6.2f');

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