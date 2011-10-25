clear;
clc;
close all;

    tsvq_Q                  =   3;
    ds_code                 =   1;
    load Dudek
    [t1, t2, F]=size(data);
    
    [PARAM.ds_2_name, PARAM.ds_3_name] =    UTIL_DATASET_getName3(ds_code);
    PARAM.tgt_sw            =   33;
    PARAM.tgt_sh            =   33;
    
    
    tsvq_Q                  =   3;
    [aTSVQ1 trkTSVQ1]       =   TSVQ_config(PARAM, [], tsvq_Q, 2);
    tsvq1                     =   textread(['results2\' trkTSVQ1.config_str '.txt']);
    
    tsvq_Q                  =   4;
    [aTSVQ2 trkTSVQ2]        =   TSVQ_config(PARAM, [], tsvq_Q, 2);
    tsvq2                     =   textread(['results2\' trkTSVQ2.config_str '.txt']);
    
    tsvq_Q                  =   5;
    [aTSVQ3 trkTSVQ3]        =   TSVQ_config(PARAM, [], tsvq_Q, 2);
    tsvq3                     =   textread(['results2\' trkTSVQ3.config_str '.txt']);    
    
    %stem(tsvq(:,21), '.')
    
   figure;
   subplot(2,1,1)
   plot(6:F, tsvq1(:,5), 'b');
hold on;
plot(6:F, tsvq2(:,5), 'g');
plot(6:F, tsvq3(:,5), 'r');
grid 
    
subplot(2,1,2)
 plot(tsvq1(:,6), 'b');
hold on;
plot(tsvq2(:,6), 'g');
plot(tsvq3(:,6), 'r');
grid

    figure;
    hold on;

    idx=0;
    for f=445:470
        idx=f-5;
        %I=data(:,:,f);
        imshow(uint8(data(:,:,f)));
        
        hold on;
        UTIL_PLOT_filledCircle([tsvq1(idx,16) tsvq1(idx,17)], 3, 300, 'b');
        UTIL_PLOT_filledCircle([tsvq1(idx,18) tsvq1(idx,19)], 3, 300, 'b');
        UTIL_PLOT_filledCircle([tsvq1(idx,20) tsvq1(idx,21)], 3, 300, 'b');
        UTIL_PLOT_filledCircle([tsvq1(idx,22) tsvq1(idx,23)], 3, 300, 'b');
        UTIL_PLOT_filledCircle([tsvq1(idx,24) tsvq1(idx,25)], 3, 300, 'b');
        UTIL_PLOT_filledCircle([tsvq1(idx,26) tsvq1(idx,27)], 3, 300, 'b');
        UTIL_PLOT_filledCircle([tsvq1(idx,28) tsvq1(idx,29)], 3, 300, 'b');
        
        UTIL_PLOT_filledCircle([tsvq2(idx,16) tsvq2(idx,17)], 3, 300, 'g');
        UTIL_PLOT_filledCircle([tsvq2(idx,18) tsvq2(idx,19)], 3, 300, 'g');
        UTIL_PLOT_filledCircle([tsvq2(idx,20) tsvq2(idx,21)], 3, 300, 'g');
        UTIL_PLOT_filledCircle([tsvq2(idx,22) tsvq2(idx,23)], 3, 300, 'g');
        UTIL_PLOT_filledCircle([tsvq2(idx,24) tsvq2(idx,25)], 3, 300, 'g');
        UTIL_PLOT_filledCircle([tsvq2(idx,26) tsvq2(idx,27)], 3, 300, 'g');
        UTIL_PLOT_filledCircle([tsvq2(idx,28) tsvq2(idx,29)], 3, 300, 'g');
        
        
        UTIL_PLOT_filledCircle([tsvq3(idx,16) tsvq3(idx,17)], 3, 300, 'r');
        UTIL_PLOT_filledCircle([tsvq3(idx,18) tsvq3(idx,19)], 3, 300, 'r');
        UTIL_PLOT_filledCircle([tsvq3(idx,20) tsvq3(idx,21)], 3, 300, 'r');
        UTIL_PLOT_filledCircle([tsvq3(idx,22) tsvq3(idx,23)], 3, 300, 'r');
        UTIL_PLOT_filledCircle([tsvq3(idx,24) tsvq3(idx,25)], 3, 300, 'r');
        UTIL_PLOT_filledCircle([tsvq3(idx,26) tsvq3(idx,27)], 3, 300, 'r');
        UTIL_PLOT_filledCircle([tsvq3(idx,28) tsvq3(idx,29)], 3, 300, 'r');
        
        %UTIL_PLOT_filledCircle([x3 y3], 3, 300, 'r');
        hold off;
        title(num2str(f));
        f
        drawnow
        pause
        
    end    