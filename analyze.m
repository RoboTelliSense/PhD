clear;
clc;
close all;
load Dudek;

Dudek_F = 570;
%PARAM
    pca__Q                  =   16;
    rvq__maxQ               =   8;
    rvq__M                  =   2;
    rvq__tSNR               =   1000;
    rvq__tstI               =   3; %testing index, 4 options are, 1: maxQ, 2: RofE, 3: nulE , 4: monR
    rvq__lmbd               =   0;
    tsvq_maxQ               =   3;
    tsvq_M                  =   2;
    bUseIPCA                =   0;
    bUseBPCA                =   0;   
    bUseRVQx                =   1;
    bUseTSVQ                =   0;
    ds_code                 =   1;
    [PARAM.ds_2_name, PARAM.ds_3_name] =    UTIL_DATASET_getName3(ds_code);

    
%--------------------------------------------------
% PROCESSING
%--------------------------------------------------
    rvq                     =   textread(['F:\Dropbox\results\' trkaRVQx.config_str '.txt'])
    I                       =   data(:,:,1);
    

%--------------------------------------------------
% POST-PROCESSING
%--------------------------------------------------
    
%plot    
    plot(rvq(:,6))
    grid on
    axis([0 600 0 30])
   f=1;
    figure;
    imagesc(I);colormap('gray');
    hold on
    UTIL_PLOT_filledCircle( [rvq(f, 16), rvq(f, 17)],   3,   3000,   'g');      %yellow color
    UTIL_PLOT_filledCircle( [rvq(f, 18), rvq(f, 19)],   3,   3000,   'g');      %yellow color    
    UTIL_PLOT_filledCircle( [rvq(f, 20), rvq(f, 21)],   3,   3000,   'g');      %yellow color    
    UTIL_PLOT_filledCircle( [rvq(f, 22), rvq(f, 23)],   3,   3000,   'g');      %yellow color    
    UTIL_PLOT_filledCircle( [rvq(f, 24), rvq(f, 25)],   3,   3000,   'g');      %yellow color    
    UTIL_PLOT_filledCircle( [rvq(f, 26), rvq(f, 27)],   3,   3000,   'g');      %yellow color    
    UTIL_PLOT_filledCircle( [rvq(f, 28), rvq(f, 29)],   3,   3000,   'g');      %yellow color    
    axis equal;
    axis tight;
    
