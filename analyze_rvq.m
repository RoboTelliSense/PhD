clear;
clc;
close all;

%============================================    
% PRE-PROCESSING    
%============================================
%RVQ    
    rvq__maxQ               =   8;
    rvq__M                  =   2;
    rvq__tstI               =   1; %1, 2, 3, or 4    
    rvq__tSNR               =   1000;
    rvq__lmbd               =   0;
    rvq__type               =   'uint8';
    
    ds_code                 =   6;

%PARAM
    
    [PARAM.ds_2_name, PARAM.ds_3_name] ...
                            =    UTIL_DATASET_getName3(ds_code);
    PARAM.tgt_sw            =   33;
    PARAM.tgt_sh            =   33;
    
%USE RVQ and PARAM    
    [aRVQx trkaRVQx]        =   RVQx_config(PARAM, [], rvq__maxQ, rvq__M, rvq__tSNR, rvq__tstI, rvq__lmbd, rvq__type);    

%============================================    
% PROCESSING    
%============================================
    rvq                     =   textread(['results2\' trkaRVQx.config_str '.txt']);

%============================================    
% POST-PROCESSING    
%============================================   
    stem(rvq(:,21), '.')
    
    figure;
    hold on;
    load car4
    [t1, t2, F]=size(data);
    idx=0;
    for f=6:F
        idx=f-5;
        %I=data(:,:,f);
        imshow(uint8(data(:,:,f)));
        
        x1=rvq(idx,16);
        y1=rvq(idx,17);
        x2=rvq(idx,18);
        y2=rvq(idx,19);
        %x3=rvq(idx,20);
        %y3=rvq(idx,21);

        hold on;
        UTIL_PLOT_filledCircle([x1 y1], 3, 300, 'r');
        UTIL_PLOT_filledCircle([x2 y2], 3, 300, 'r');
        %UTIL_PLOT_filledCircle([x3 y3], 3, 300, 'r');
        hold off;
        title(num2str(f));
        f
        drawnow
        
        
    end