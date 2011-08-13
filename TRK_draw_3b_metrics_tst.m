function TRK_draw_3b_metrics_tst(tstSNR, tstRMSE, tstAVGRMSE, f, fs, algo_code)

    if      (algo_code==1)  str='iPCA';     color = 'r';    
    elseif  (algo_code==2)  str='bPCA';     color = 'm';
    elseif  (algo_code==3)  str='RVQ';      color = 'g';
    elseif  (algo_code==4)  str='TSVQ';     color = 'b';
    end   
    
    %SNR
        subplot(5,4,5);     
        hold on; 
        plot(2:f, tstSNR(2:f),  [color '-']); 
        set(gca, 'FontSize', 8);
        UTIL_makeTitle('test SNR (dB)', 'k', fs); 
        %axis tight
        grid on;   
        hold off;
        
        
    %RMSE
        subplot(5,4,4);     
        hold on;
        plot(1:f, tstRMSE(1:f),  [color '-']);  
        set(gca, 'FontSize', 8);
        UTIL_makeTitle('test rmse', 'k', fs); 
        %axis tight
        grid on;   
        hold off; 


    %AVG RMSE
        subplot(5,4,8);     
        hold on;
        plot(1:f, tstAVGRMSE(1:f),  [color '-']); 
        set(gca, 'FontSize', 8);
        UTIL_makeTitle('mean test rmse', 'k', fs);       
        %axis tight
        grid on;   
        hold off;  