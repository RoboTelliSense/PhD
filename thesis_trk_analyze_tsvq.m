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
            I=1:5:F;
            t=1:F;
            
   figure;
   subplot(2,1,1)
   plot(1:F-5, tsvq1(:,5), 'b');hold on;p1=plot(1:5:F-5, tsvq1(1:5:F-5,5), 'b*');
   plot(1:F-5, tsvq2(:,5), 'g');hold on;p2=plot(1:5:F-5, tsvq2(1:5:F-5,5), 'gs');
   plot(1:F-5, tsvq3(:,5), 'r');hold on;p3=plot(1:5:F-5, tsvq3(1:5:F-5,5), 'rd');
   grid 
   xlabel('frames')
   ylabel('tracking error');
   legend([p1 p2 p3],{'P=3', 'P=4', 'P=5'}, 'Location', 'best')
    
subplot(2,1,2)
   plot(1:F-5, tsvq1(:,6), 'b');hold on;p1=plot(1:5:F-5, tsvq1(1:5:F-5,6), 'b*');
   plot(1:F-5, tsvq2(:,6), 'g');hold on;p2=plot(1:5:F-5, tsvq2(1:5:F-5,6), 'gs');
   plot(1:F-5, tsvq3(:,6), 'r');hold on;p3=plot(1:5:F-5, tsvq3(1:5:F-5,6), 'rd');
   grid 
   legend([p1 p2 p3],{'P=3', 'P=4', 'P=5'}, 'Location', 'best')
   xlabel('frames')
   ylabel('average tracking error');
UTIL_FILE_save2pdf('temp/out20.pdf');
   
    figure;
    hold on;

    idx=0;
    for f=10:10
        idx=f-5;
        %I=data(:,:,f);
        figure;
        imshow(uint8(data(:,:,f)));
        hold on;
        UTIL_PLOT_filledCircle([truepts(1,1,f) truepts(2,1,f)], 5, 300, 'y');
        UTIL_PLOT_filledCircle([truepts(1,2,f) truepts(2,2,f)], 5, 300, 'y');
        UTIL_PLOT_filledCircle([truepts(1,3,f) truepts(2,3,f)], 5, 300, 'y');
        UTIL_PLOT_filledCircle([truepts(1,4,f) truepts(2,4,f)], 5, 300, 'y');
        UTIL_PLOT_filledCircle([truepts(1,5,f) truepts(2,5,f)], 5, 300, 'y');
        UTIL_PLOT_filledCircle([truepts(1,6,f) truepts(2,6,f)], 5, 300, 'y');
        UTIL_PLOT_filledCircle([truepts(1,7,f) truepts(2,7,f)], 5, 300, 'y');
        UTIL_FILE_save2pdf('temp/out21.pdf');
        

        
        figure;
        imshow(uint8(data(:,:,f)));
        hold on;
        UTIL_PLOT_filledCircle([tsvq1(idx,16) tsvq1(idx,17)], 5, 300, 'b');
        UTIL_PLOT_filledCircle([tsvq1(idx,18) tsvq1(idx,19)], 5, 300, 'b');
        UTIL_PLOT_filledCircle([tsvq1(idx,20) tsvq1(idx,21)], 5, 300, 'b');
        UTIL_PLOT_filledCircle([tsvq1(idx,22) tsvq1(idx,23)], 5, 300, 'b');
        UTIL_PLOT_filledCircle([tsvq1(idx,24) tsvq1(idx,25)], 5, 300, 'b');
        UTIL_PLOT_filledCircle([tsvq1(idx,26) tsvq1(idx,27)], 5, 300, 'b');
        UTIL_PLOT_filledCircle([tsvq1(idx,28) tsvq1(idx,29)], 5, 300, 'b');
        UTIL_FILE_save2pdf('temp/out22.pdf');

        figure;
        imshow(uint8(data(:,:,f)));
        hold on;        
        UTIL_PLOT_filledCircle([tsvq2(idx,16) tsvq2(idx,17)], 5, 300, 'g');
        UTIL_PLOT_filledCircle([tsvq2(idx,18) tsvq2(idx,19)], 5, 300, 'g');
        UTIL_PLOT_filledCircle([tsvq2(idx,20) tsvq2(idx,21)], 5, 300, 'g');
        UTIL_PLOT_filledCircle([tsvq2(idx,22) tsvq2(idx,23)], 5, 300, 'g');
        UTIL_PLOT_filledCircle([tsvq2(idx,24) tsvq2(idx,25)], 5, 300, 'g');
        UTIL_PLOT_filledCircle([tsvq2(idx,26) tsvq2(idx,27)], 5, 300, 'g');
        UTIL_PLOT_filledCircle([tsvq2(idx,28) tsvq2(idx,29)], 5, 300, 'g');
        UTIL_FILE_save2pdf('temp/out23.pdf');
        
        figure;
        imshow(uint8(data(:,:,f)));
        hold on;        
        UTIL_PLOT_filledCircle([tsvq3(idx,16) tsvq3(idx,17)], 5, 300, 'r');
        UTIL_PLOT_filledCircle([tsvq3(idx,18) tsvq3(idx,19)], 5, 300, 'r');
        UTIL_PLOT_filledCircle([tsvq3(idx,20) tsvq3(idx,21)], 5, 300, 'r');
        UTIL_PLOT_filledCircle([tsvq3(idx,22) tsvq3(idx,23)], 5, 300, 'r');
        UTIL_PLOT_filledCircle([tsvq3(idx,24) tsvq3(idx,25)], 5, 300, 'r');
        UTIL_PLOT_filledCircle([tsvq3(idx,26) tsvq3(idx,27)], 5, 300, 'r');
        UTIL_PLOT_filledCircle([tsvq3(idx,28) tsvq3(idx,29)], 5, 300, 'r');
        UTIL_FILE_save2pdf('temp/out24.pdf');
        
        %UTIL_PLOT_filledCircle([x3 y3], 5, 300, 'r');
        hold off;
        title(num2str(f));
        f
        drawnow
        
        
    end    