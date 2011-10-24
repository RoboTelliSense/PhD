clear;
clc;
close all;

    tsvq_Q                  =   5;
    ds_code                 =   7;
    
    [PARAM.ds_2_name, PARAM.ds_3_name] =    UTIL_DATASET_getName3(ds_code);
    PARAM.tgt_sw            =   33;
    PARAM.tgt_sh            =   33;
    
    [aTSVQ trkTSVQ]        =   TSVQ_config(PARAM, [], tsvq_Q, 2);
    
    tsvq                     =   textread(['results2\' trkTSVQ.config_str '.txt']);
    
    
    %stem(tsvq(:,21), '.')
    
    figure;
    hold on;
    load car11
    [t1, t2, F]=size(data);
    idx=0;
    for f=6:F
        idx=f-5;
        %I=data(:,:,f);
        imshow(uint8(data(:,:,f)));
        
        x1=tsvq(idx,16);
        y1=tsvq(idx,17);
        x2=tsvq(idx,18);
        y2=tsvq(idx,19);
        %x3=tsvq(idx,20);
        %y3=tsvq(idx,21);

        hold on;
        UTIL_PLOT_filledCircle([x1 y1], 3, 300, 'r');
        UTIL_PLOT_filledCircle([x2 y2], 3, 300, 'r');
        %UTIL_PLOT_filledCircle([x3 y3], 3, 300, 'r');
        hold off;
        title(num2str(f));
        f
        drawnow
        
        
    end    