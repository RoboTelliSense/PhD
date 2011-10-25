% This file generates tracking tables and plots.
%
% Copyright (c) Salman Aslam.  All rights reserved.
% Date created : Oct 22, 2011
% Date modified: Oct 24, 2011





    clear;
    clc;
    close all;

%select an algo to run
    bUsePCA                 =   0;
    bUseTSVQ                =   0;
    bUseRVQ1                =   0;
    bUseRVQ2                =   0;
    bUseRVQ3                =   1;
    bUseRVQ4                =   0;

    bSave                   =   1; 
%------------------------------------------------
% PRE-PROCESSING
%------------------------------------------------   
   
%input data
    OUT                     =  thesis_trk_results();      %read numbers
    
%select labels, etc based on algo
    if (bUsePCA)
        algo_xlabel         =   'Number of eigenvectors, Q';
        algo_xTickLabels    =   {'8', '16', '32'};
        algo_legend         =   {'Q=8', 'Q=16', 'Q=32'};
        Table_Nd_x_Nc       =   OUT.pca;
        algofn              =   'pca__';
    elseif (bUseTSVQ)
        algo_xlabel         =   'Number of stages, P';
        algo_xTickLabels    =   {'3', '4', '5'};
        algo_legend         =   {'P=3', 'P=4', 'P=5'};
        Table_Nd_x_Nc       =   OUT.tsvq;        
        algofn              =   'tsvq_';
    else
        algo_xlabel         =   'Number of stages x codevectors/stage, PxM';
        algo_xTickLabels    =   {'8x2', '8x4', '8x8'};
        algo_legend         =   {'PxM=8x2', 'PxM=8x4', 'PxM=8x8'};        
        if      (bUseRVQ1) Table_Nd_x_Nc = OUT.rvq1(:,1:3);algofn='rvq1_';  %1:3 means only use 8x2, 8x4, 8x8
        elseif  (bUseRVQ2) Table_Nd_x_Nc = OUT.rvq2(:,1:3);algofn='rvq2_';
        elseif  (bUseRVQ3) Table_Nd_x_Nc = OUT.rvq3(:,1:3);algofn='rvq3_';
        elseif  (bUseRVQ4) Table_Nd_x_Nc = OUT.rvq4(:,1:3);algofn='rvq4_';
        end
    end
    
    ylabel1                 =   'tracking error'; 
    yampl                   =   15; %max y amplitude
    ds_xlabel               =   'publicly available datasets';
    ds_xTickLabels          =   {'Dudek', 'davidin300', 'sylv', 'fish', 'car4', 'car11'};    
    ds_legend               =   ds_xTickLabels;
    [Nd, Nc]                =   size(Table_Nd_x_Nc); %Nc is number of configurations
                                                     %Nd is number of datasets

%------------------------------------------------
% PROCESSING
%------------------------------------------------  
%1. CONFIGURATIONS ON X AXIS (plot rows)
    %plot1a: instantaneous
    h1=figure;
    plot(Table_Nd_x_Nc(1,:), 'r*-'); hold on; %Dudek
    plot(Table_Nd_x_Nc(2,:), 'g+-');          %davidin300
    plot(Table_Nd_x_Nc(3,:), 'ro-');          %sylv
    plot(Table_Nd_x_Nc(4,:), 'g^-');          %fish
    plot(Table_Nd_x_Nc(5,:), 'bs-');          %car4
    plot(Table_Nd_x_Nc(6,:), 'bd-');          %car11
    legend(ds_legend);
    grid on;
    axis([1 Nc 0 yampl])
    set(gca, 'XTick', 1:Nc);
    set(gca, 'XTickLabel', algo_xTickLabels);
    xlabel(algo_xlabel);
    ylabel(ylabel1);

 
    %plot1b: averaged by squashing up down
    h2=figure;
    Table_config_1x6 = mean(Table_Nd_x_Nc, 1);
    bar(Table_config_1x6);
    grid on;
    axis([0 Nc+1 0 yampl]);
    set(gca, 'XTick', 1:Nc);
    set(gca, 'XTickLabel', algo_xTickLabels);
    xlabel(algo_xlabel);
    ylabel(ylabel1);
  

    
    
    
    
    
    
%2. DATASETS ON X AXIS (plot cols)
    %plot2a: instantaneous
    h3=figure;
    plot(1:Nd, Table_Nd_x_Nc(:,1), 'b*-'); hold on; %8
    plot(1:Nd, Table_Nd_x_Nc(:,2), 'gs-');          %16
    plot(1:Nd, Table_Nd_x_Nc(:,3), 'rd-');          %32
    legend(algo_legend);
    grid on;
    axis([1 Nd 0 yampl]);
    set(gca, 'XTick', 1:Nd);
    set(gca, 'XTickLabel', ds_xTickLabels);
    xlabel(ds_xlabel);
    ylabel(ylabel1);
    
    %plot 2b: averaged by squashing left right
    h4=figure;
    Table_config_3x1 = mean(Table_Nd_x_Nc, 2);
    bar(Table_config_3x1);
    grid on;
    axis([0 Nd+1 0 yampl]);
    set(gca, 'XTick', 1:Nd);
    set(gca, 'XTickLabel', ds_xTickLabels);
    xlabel(ds_xlabel);
    ylabel(ylabel1);

    mean1                   =   DM2_filtered_mean(Table_Nd_x_Nc, 9999, 1);
    mean2                   =   DM2_filtered_mean(Table_Nd_x_Nc, 9999, 2);
    
%save to hard disk
    if (bSave)
        UTIL_FILE_save2pdf(                 ['temp/results_' algofn 'trk_1a.pdf'], h1, 300); 
        UTIL_FILE_save2pdf(                 ['temp/results_' algofn 'trk_1b.pdf'], h2, 300);   
        UTIL_FILE_save2pdf(                 ['temp/results_' algofn 'trk_2a.pdf'], h3, 300); 
        UTIL_FILE_save2pdf(                 ['temp/results_' algofn 'trk_2b.pdf'], h4, 300);   
        UTIL_matrix2latex(Table_Nd_x_Nc,    ['temp/results_' algofn 'trk.tex'], 'rowLabels', ds_legend, 'columnLabels', algo_legend, 'alignment', 'c', 'format', '%-6.2f');        
    end    
