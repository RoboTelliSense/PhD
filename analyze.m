clear;
clc;
close all;
load Dudek;

%INPUTS
    pca__Q                  =   16;
    rvq__maxQ               =   8;
    rvq__M                  =   2;
    rvq__targetSNRdB        =   1000;
    rvq__tstI               =   3; %testing index, 4 options are, 1: maxQ, 2: RofE, 3: nulE , 4: monE
    tsvq_maxQ               =   3;
    tsvq_M                  =   2;
    bUseIPCA                =   1;
    bUseBPCA                =   1;   
    bUseRVQx                =   1;
    bUseTSVQ                =   1;
    ds_code                 =   1;
    [PARAM.ds_2_name, PARAM.ds_3_name] =    UTIL_DATASET_getName3(ds_code);

%ALGO
    tstD                    =   RVQ__testing_rule_string(rvq__tstI); %decode stop rule for test vectors
    aRVQx.config_str        =   RVQ__config_string(rvq__maxQ, rvq__M, rvq__targetSNRdB, tstD);
  

%tracker name
    trkaRVQx.config_str     =   [PARAM.ds_3_name    aRVQx.config_str];
    rvq                     =   textread([trkaRVQx.config_str '.txt']);
    rvq                     =   textread('1_Dudek__aMEAN__.txt');
    I                       =   data(:,:,1);
%plot    
    plot(rvq(:,6))
    grid on
    axis([0 600 0 30])
   
    figure;
    imagesc(I);colormap('gray');
    hold on
    UTIL_PLOT_filledCircle( [rvq(16), rvq(17)],   3,   3000,   'y');      %yellow color
    UTIL_PLOT_filledCircle( [rvq(18), rvq(19)],   3,   3000,   'y');      %yellow color    
    UTIL_PLOT_filledCircle( [rvq(20), rvq(21)],   3,   3000,   'y');      %yellow color    
    UTIL_PLOT_filledCircle( [rvq(22), rvq(23)],   3,   3000,   'y');      %yellow color    
    UTIL_PLOT_filledCircle( [rvq(24), rvq(25)],   3,   3000,   'y');      %yellow color    
    UTIL_PLOT_filledCircle( [rvq(26), rvq(27)],   3,   3000,   'y');      %yellow color    
    UTIL_PLOT_filledCircle( [rvq(28), rvq(29)],   3,   3000,   'y');      %yellow color    
    axis equal;
    axis tight;
    
