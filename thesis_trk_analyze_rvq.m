clear;
clc;
close all;

%============================================    
% PRE-PROCESSING    
%============================================
%RVQ    
    rvq__maxQ               =   8;

    rvq__tstI               =   4; %1, 2, 3, or 4    
    rvq__tSNR               =   1000;
    rvq__lmbd               =   0;
    rvq__type               =   'uint8';
    
    ds_code                 =   1;
        load Dudek
            [t1, t2, F]=size(data);

%PARAM
    
    [PARAM.ds_2_name, PARAM.ds_3_name] ...
                            =    UTIL_DATASET_getName3(ds_code);
    PARAM.tgt_sw            =   33;
    PARAM.tgt_sh            =   33;
    
%USE RVQ and PARAM  
    rvq__M                  =   2;
    [aRVQ2a trkaRVQ2a]      =   RVQx_config(PARAM, [], rvq__maxQ, rvq__M, rvq__tSNR, rvq__tstI, rvq__lmbd, rvq__type);    
    rvqa                    =   textread(['results2\' trkaRVQ2a.config_str '.txt']);

    rvq__M                  =   4;
    [aRVQ2b trkaRVQ2b]      =   RVQx_config(PARAM, [], rvq__maxQ, rvq__M, rvq__tSNR, rvq__tstI, rvq__lmbd, rvq__type);    
    rvqb                    =   textread(['results2\' trkaRVQ2b.config_str '.txt']);

    rvq__M                  =   8;
    [aRVQ2c trkaRVQ2c]      =   RVQx_config(PARAM, [], rvq__maxQ, rvq__M, rvq__tSNR, rvq__tstI, rvq__lmbd, rvq__type);    
    rvqc                    =   textread(['results2\' trkaRVQ2c.config_str '.txt']);
    
%============================================    
% PROCESSING    
%============================================
    

%============================================    
% POST-PROCESSING    
%============================================   
     figure;
   subplot(2,1,1)
   plot(6:F, rvqa(:,5), 'b');
hold on;
plot(6:F, rvqb(:,5), 'g');
plot(6:F, rvqc(:,5), 'r');
grid 
    
subplot(2,1,2)
 plot(rvqa(:,6), 'b');
hold on;
plot(rvqb(:,6), 'g');
plot(rvqc(:,6), 'r');
grid

    
    figure;
    hold on;


    idx=0;
    for f=492:492
        idx=f-5;
        %I=data(:,:,f);
        imshow(uint8(data(:,:,f)));
        

        hold on;
        UTIL_PLOT_filledCircle([rvqa(idx,16) rvqa(idx,17)], 3, 300, 'b');
        UTIL_PLOT_filledCircle([rvqa(idx,18) rvqa(idx,19)], 3, 300, 'b');
        
        UTIL_PLOT_filledCircle([rvqb(idx,16) rvqb(idx,17)], 3, 300, 'g');
        UTIL_PLOT_filledCircle([rvqb(idx,18) rvqb(idx,19)], 3, 300, 'g');
        
        UTIL_PLOT_filledCircle([rvqc(idx,16) rvqc(idx,17)], 3, 300, 'r');
        UTIL_PLOT_filledCircle([rvqc(idx,18) rvqc(idx,19)], 3, 300, 'r');        

        hold off;
        title(num2str(f));
        f
        drawnow
       
        
    end