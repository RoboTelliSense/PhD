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
    bUsemaxP                =   0;
    bUseRofE                =   0;
    bUsenulE                =   0;
    bUsemonR                =   1;

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
        algofn              =   'pca_';
    elseif (bUseTSVQ)
        algo_xlabel         =   'Number of stages, P';
        algo_xTickLabels    =   {'3', '4', '5'};
        algo_legend         =   {'P=3', 'P=4', 'P=5'};
        Table_Nd_x_Nc       =   OUT.tsvq;        
        algofn              =   'tsvq';
    else
        algo_xlabel         =   'Number of stages x codevectors/stage, PxM';
        algo_xTickLabels    =   {'8x2', '8x4', '8x8'};
        algo_legend         =   {'PxM=8x2', 'PxM=8x4', 'PxM=8x8'};        
        if      (bUsemaxP) Table_Nd_x_Nc = OUT.maxP;algofn='maxP';  %1:3 means only use 8x2, 8x4, 8x8
        elseif  (bUseRofE) Table_Nd_x_Nc = OUT.RofE;algofn='RofE';
        elseif  (bUsenulE) Table_Nd_x_Nc = OUT.nulE;algofn='nulE';
        elseif  (bUsemonR) Table_Nd_x_Nc = OUT.monR;algofn='monR';
        end
    end
    
    ylabel1                 =   'tracking error'; 
    yampl                   =   15; %max y amplitude
    ds_xlabel               =   'publicly available datasets';
    ds_xTickLabels          =   {'1. Dudek', '2. davidin300', '3. sylv', '4. fish', '5. car4', '6. car11', 'mean'};    
    ds_legend               =   ds_xTickLabels;
    [Nd, Nc]                =   size(Table_Nd_x_Nc); %Nc is number of configurations
                                                     %Nd is number of datasets

%------------------------------------------------
% PROCESSING
%------------------------------------------------  
%1. CONFIGURATIONS ON X AXIS (plot rows)
    %plot a: instantaneous
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

    %plot: instantaneous
    h2=figure;
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

    
    %plot c: averaged by squashing up down
    h3=figure;
    Table_config_1x6 = DM2_filtered_mean(Table_Nd_x_Nc, 50, 1);
    bar(Table_config_1x6);
    grid on;
    axis([0 Nc+1 0 yampl]);
    set(gca, 'XTick', 1:Nc);
    set(gca, 'XTickLabel', algo_xTickLabels);
    xlabel(algo_xlabel);
    ylabel(ylabel1);
  

    %plot d: averaged by squashing left right
    h4=figure;
    Table_config_3x1 = DM2_filtered_mean(Table_Nd_x_Nc, 50, 2);
    bar(Table_config_3x1);
    grid on;
    axis([0 Nd+1 0 yampl]);
    set(gca, 'XTick', 1:Nd);
    set(gca, 'XTickLabel', ds_xTickLabels);
    xlabel(ds_xlabel);
    ylabel(ylabel1);

    mean1                   =   DM2_filtered_mean(Table_Nd_x_Nc, 50, 1);
    mean2                   =   DM2_filtered_mean(Table_Nd_x_Nc, 50, 2);
    Table_Nd_x_Nc           =   [Table_Nd_x_Nc; mean1];
    
%save to hard disk
    if (bSave)
        UTIL_FILE_save2pdf(                 ['temp/results_final_' algofn '_a.pdf'], h1, 300); 
        UTIL_FILE_save2pdf(                 ['temp/results_final_' algofn '_b.pdf'], h2, 300);   
        UTIL_FILE_save2pdf(                 ['temp/results_final_' algofn '_c.pdf'], h3, 300); 
        UTIL_FILE_save2pdf(                 ['temp/results_final_' algofn '_d.pdf'], h4, 300);   
        UTIL_matrix2latex(Table_Nd_x_Nc,    ['temp/results_final_' algofn '.tex'], 'rowLabels', ds_legend, 'columnLabels', algo_legend, 'alignment', 'c', 'format', '%-6.2f');        
    end    
