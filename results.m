clear;
clc;
close all;
%1. Dudek
%           maxQ  RofE  nulE  monR
rvq_Dudek   =[  10000     6.68  7.96  7.85 ; %m=2
            8.40  8.19  7.22  8.89 ; %m=4
            9.13  7.95  8.67  8.47 ; %m=8
            8.34  10.02 8.18  7.60 ; %m=12
            8.05  10.08 8.10  9.25];  %m=16
  
pca_Dudek  = [7.44;7.81;8.54];
tsvq_Dudek = [8.62;11.87;9.71];
%           8.48  8.58  8.03  8.41   %mean

%2. davidin300
rvq_davidin300   =[  5.67  6.93  8.72  11.31 ; %m=2
            4.39  5.95  4.59  5 ; %m=4
            8.08  6.14  8.50  8.52 ; %m=8
            6.07  5.65  6.70  4.52 ; %m=12
            5.48  5.33  4.60  4.29];  %m=16
pca_davidin300 = [8.36;4.60;6.93];
tsvq_davidin300 = [12.88; 6.29; 5.93]; 
     
%sylv
rvq_sylv = [4.26 4.29 4.72 5.61;
        4.69 4.66 4.82 4.70;
        4.66 4.56 4.88 4.95;
        4.19 5.03 4.43 4.96;
        4.89 4.54 4.77 4.69];
pca_sylv = [4.34;5.47;5.72];    
tsvq_sylv=[4.70;4.80;4.61];        

%fish
rvq_fish = [2.73 3.82 3.93 3.32;
        2.84 2.97 10.40 2.60;
        13.09 2.60 13.97 13.29;
        5.24 5.37 4.52 4.44;
        4.42 12.04 4.87 4.37];
 pca_fish=[9.75;2.17;7.98];
tsvq_fish =[10.07;4.59;5.47];

%car4
rvq_car4=[5.08 4.86 5.18 5.93;
      5.0 5.16 5.03 5.51;
      5.12 5.27 5.39 6.35;
      5.11 5.34 4.72 5.84;
      6.47 6.63 5.52 5.28];
 pca_car4=[4.79;4.60;5.52];
 tsvq_car4=[5.11;6.79;5.80];
 
 %car11
rvq_car11 = [2.32 2.23 2.57 2.23;
         2.30 2.06 2.12 2.71;
         2.14 2.48 3.45 12.04;
         2.94 2.90 5.29 10000;
         10000 2.78 2.97 2];
pca_car11=[2.21;2.13;2.39];
tsvq_car11=[2.21;5.28;2.94];

%comparison best
comparison_best=    [   min(min(pca_Dudek))         min(min(tsvq_Dudek))        min(min(rvq_Dudek))         ;
                        min(min(pca_davidin300))    min(min(tsvq_davidin300))   min(min(rvq_davidin300))    ;
                        min(min(pca_sylv))          min(min(tsvq_sylv))         min(min(rvq_sylv))          ;
                        min(min(pca_fish))          min(min(tsvq_fish))         min(min(rvq_fish))          ;
                        min(min(pca_car4))          min(min(tsvq_car4))         min(min(rvq_car4))          ;
                        min(min(pca_car11))         min(min(tsvq_car11))        min(min(rvq_car11))        ]
temp1=mean(comparison_best);
comparison_best=[comparison_best;temp1]

%comparison DoF_16

comparison_DoF_16 = [pca_Dudek(2)       tsvq_Dudek(1)       min(rvq_Dudek(1,:));
                    pca_davidin300(2)   tsvq_davidin300(1)  min(rvq_davidin300(1,:));
                    pca_sylv(2)         tsvq_sylv(1)        min(rvq_sylv(1,:));
                    pca_fish(2)         tsvq_fish(1)        min(rvq_fish(1,:));
                    pca_car4(2)         tsvq_car4(1)        min(rvq_car4(1,:));
                    pca_car11(2)        tsvq_car11(1)       min(rvq_car11(1,:))];
temp2=mean(comparison_DoF_16);
comparison_DoF_16=[comparison_DoF_16;temp2]

comparison_DoF_32 = [pca_Dudek(3)       tsvq_Dudek(2)       min(rvq_Dudek(2,:))         ;
                     pca_davidin300(3)  tsvq_davidin300(2)  min(rvq_davidin300(2,:))    ;
                     pca_sylv(3)        tsvq_sylv(2)        min(rvq_sylv(2,:))          ;
                     pca_fish(3)        tsvq_fish(2)        min(rvq_fish(2,:))          ;
                     pca_car4(3)        tsvq_car4(2)        min(rvq_car4(2,:))          ;
                     pca_car11(3)       tsvq_car11(2)       min(rvq_car11(2,:))         ];
temp2=mean(comparison_DoF_32);
comparison_DoF_32=[comparison_DoF_32;temp2]


                  
rowLabels = {'2', '4', '8', '12', '16'};  
rowLabels2 = {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11', 'mean'};  
colLabels = {'maxQ', 'RofE', 'nulE', 'monR'};
colLabels2 = {'PCA', 'TSVQ', 'RVQ'};

%mesh(Dudek)
set(gca, 'XTickLabel', colLabels);
set(gca, 'YTickLabel', [2 4 8 12 16]);
  
UTIL_matrix2latex(rvq_Dudek,        'tables_1_Dudek_rvq.tex',          'rowLabels', rowLabels, 'columnLabels', colLabels, 'alignment', 'c', 'format', '%-6.2f');
UTIL_matrix2latex(rvq_davidin300,   'tables_2_davidin300_rvq.tex',     'rowLabels', rowLabels, 'columnLabels', colLabels, 'alignment', 'c', 'format', '%-6.2f');
UTIL_matrix2latex(rvq_sylv,         'tables_3_sylv_rvq.tex',           'rowLabels', rowLabels, 'columnLabels', colLabels, 'alignment', 'c', 'format', '%-6.2f');
UTIL_matrix2latex(rvq_fish,         'tables_5_fish_rvq.tex',           'rowLabels', rowLabels, 'columnLabels', colLabels, 'alignment', 'c', 'format', '%-6.2f');
UTIL_matrix2latex(rvq_car4,         'tables_6_car4_rvq.tex',           'rowLabels', rowLabels, 'columnLabels', colLabels, 'alignment', 'c', 'format', '%-6.2f');
UTIL_matrix2latex(rvq_car11,        'tables_7_car11_rvq.tex',          'rowLabels', rowLabels, 'columnLabels', colLabels, 'alignment', 'c', 'format', '%-6.2f');
UTIL_matrix2latex(comparison_best,  'tables_comparison_best.tex',      'rowLabels', rowLabels2,'columnLabels', colLabels2, 'alignment', 'c', 'format', '%-6.2f');
UTIL_matrix2latex(comparison_DoF_16,'tables_comparison_DoF_16.tex',    'rowLabels', rowLabels2,'columnLabels', colLabels2, 'alignment', 'c', 'format', '%-6.2f');
UTIL_matrix2latex(comparison_DoF_32,'tables_comparison_DoF_32.tex',    'rowLabels', rowLabels2,'columnLabels', colLabels2, 'alignment', 'c', 'format', '%-6.2f');

a=[7.96 7.07 8.21 8.34 8.96];
mean(a);
a=[19.19 11.08 7.27 9.60];
mean(a);