clear;
clc;
%close all;
%load David;
clf;

%PARAM
    pca__Q                  =   16;
    
    rvq__maxQ               =   8;
    rvq__tSNR               =   1000;
    rvq__lmbd               =   0;
    rvq__type               =   'uint8';
    
    tsvq_maxQ               =   3;
    tsvq_M                  =   2;
    
    bUseIPCA                =   0;
    bUseBPCA                =   0;   
    bUseRVQx                =   1;
    bUseTSVQ                =   0;
    
    ds_code                 =   1;
    
    [PARAM.ds_2_name, PARAM.ds_3_name] =    UTIL_DATASET_getName3(ds_code);
    PARAM.ds_4_name                    =    UTIL_DATASET_getName4(ds_code);
    PARAM.tgt_sw            =   33;
    PARAM.tgt_sh            =   33;
    
    
%--------------------------------------------------
% RVQ
%--------------------------------------------------
    figure(1);clf;
    
    rvq__M = 4;
    
    for val=[2 3 5:15]
        clf;
        grid on;
        hold on;
        for rvq__tstI = [1 2 3 4] %testing index, 4 options are, 1: maxQ, 2: RofE, 3: nulE , 4: monR
            [aRVQx trkaRVQx]        =   RVQx_config(PARAM, [], rvq__maxQ, rvq__M, rvq__tSNR, rvq__tstI, rvq__lmbd, rvq__type);    
            rvq                     =   textread(['results\' trkaRVQx.config_str '.txt']);
            [F,temp]                =   size(rvq);
            
            I=1:5:F;
            t=1:F;
            if     (rvq__tstI==1)   a=rvq(:,val);plot(t,a, 'r');p1=plot(I, a(I), 'ro');
            elseif (rvq__tstI==2)   a=rvq(:,val);plot(t,a, 'g');p2=plot(I, a(I), 'g+');  
            elseif (rvq__tstI==3)   a=rvq(:,val);plot(t,a, 'b');p3=plot(I, a(I), 'bd');
            elseif (rvq__tstI==4)   a=rvq(:,val);plot(t,a, 'm');p4=plot(I, a(I), 'm*');
            end
        end    
        hold off;
        if      (val==2) ylabel('learning time (sec)')                      ;cfn=[PARAM.ds_4_name '8_4_1000_lrn_time.pdf'];        
        elseif  (val==3) ylabel('condensation time (sec)')                  ;cfn=[PARAM.ds_4_name '8_4_1000_con_time.pdf'];        
        elseif  (val==5) ylabel('tracking error (rmse)')                    ;cfn=[PARAM.ds_4_name '8_4_1000_trk_rmse.pdf'];
        elseif  (val==6) ylabel('tracking error (avg. rmse)')               ;cfn=[PARAM.ds_4_name '8_4_1000_trk_armse.pdf'];
        elseif  (val==7) ylabel('target reconstruction SNR (dB)')           ;cfn=[PARAM.ds_4_name '8_4_1000_snp_SNRdB.pdf'];
        elseif  (val==8) ylabel('target reconstruction error (rmse)')       ;cfn=[PARAM.ds_4_name '8_4_1000_snp_rmse.pdf'];        
        elseif  (val==9) ylabel('target reconstruction error (avg. rmse)')  ;cfn=[PARAM.ds_4_name '8_4_1000_snp_armse.pdf'];           
        elseif  (val==10)ylabel('training SNR (dB)')                        ;cfn=[PARAM.ds_4_name '8_4_1000_trg_SNRdB.pdf'];        
        elseif  (val==11)ylabel('training error (rmse)')                    ;cfn=[PARAM.ds_4_name '8_4_1000_trg_rmse.pdf'];        
        elseif  (val==12)ylabel('training error (avg. rmse)')               ;cfn=[PARAM.ds_4_name '8_4_1000_trg_armse.pdf'];  
        elseif  (val==13)ylabel('testing SNR (dB)')                         ;cfn=[PARAM.ds_4_name '8_4_1000_tst_SNRdB.pdf'];        
        elseif  (val==14)ylabel('testing error (rmse)')                     ;cfn=[PARAM.ds_4_name '8_4_1000_tst_rmse.pdf'];        
        elseif  (val==15)ylabel('testing error (avg. rmse)')                ;cfn=[PARAM.ds_4_name '8_4_1000_tst_armse.pdf'];  
        end
        xlabel('frame number')
        legend([p1 p2 p3 p4], 'maxQ', 'RofE', 'nulE', 'monR', 'Location', 'Best')
        UTIL_FILE_save2pdf(cfn);
    end
    
    


    %axis([0 570 0 15])
    %

%--------------------------------------------------
% POST-PROCESSING
%--------------------------------------------------
    
%plot    
    axis([0 600 0 30])
    
    f=10;
    figure;
    load trellis70
    I=data(:,:,1);
    imagesc(I);colormap('gray');
    hold on
     UTIL_PLOT_filledCircle( [rvq(f, 16), rvq(f, 17)],   3,   3000,   'g');      %yellow color
     UTIL_PLOT_filledCircle( [rvq(f, 18), rvq(f, 19)],   3,   3000,   'g');      %yellow color    
%     UTIL_PLOT_filledCircle( [rvq(f, 20), rvq(f, 21)],   3,   3000,   'g');      %yellow color    
%     UTIL_PLOT_filledCircle( [rvq(f, 22), rvq(f, 23)],   3,   3000,   'g');      %yellow color    
%     UTIL_PLOT_filledCircle( [rvq(f, 24), rvq(f, 25)],   3,   3000,   'g');      %yellow color    
%     UTIL_PLOT_filledCircle( [rvq(f, 26), rvq(f, 27)],   3,   3000,   'g');      %yellow color    
%     UTIL_PLOT_filledCircle( [rvq(f, 28), rvq(f, 29)],   3,   3000,   'g');      %yellow color    
%     axis equal;
%     axis tight;
    
