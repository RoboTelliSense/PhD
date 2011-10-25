clear;
clc;
close all;

    pca__Q                  =   32;
    ds_code                 =   7;
    
    [PARAM.ds_2_name, PARAM.ds_3_name] =    UTIL_DATASET_getName3(ds_code);
    PARAM.tgt_sw            =   33;
    PARAM.tgt_sh            =   33;
    
    [apcax trkapcax]        =   BPCA_config(PARAM, [], pca__Q);
    
    pca                     =   textread(['results2\' trkapcax.config_str '.txt']);
    
    
    %stem(pca(:,21), '.')
    
    figure;
    hold on;
    load car11
    [t1, t2, F]=size(data);
    idx=0;
    for f=6:F
        idx=f-5;
        %I=data(:,:,f);
        imshow(uint8(data(:,:,f)));
        
        x1=pca(idx,16);
        y1=pca(idx,17);
        x2=pca(idx,18);
        y2=pca(idx,19);
        %x3=pca(idx,20);
        %y3=pca(idx,21);

        hold on;
        UTIL_PLOT_filledCircle([x1 y1], 3, 300, 'r');
        UTIL_PLOT_filledCircle([x2 y2], 3, 300, 'r');
        %UTIL_PLOT_filledCircle([x3 y3], 3, 300, 'r');
        hold off;
        title(num2str(f));
        f
        drawnow
        
        
    end    