function TRK_draw_3b_metrics_tst(tstSNR, tst_RMSE, tst_RMSEavg, f, CONFIG.plot_title_fontsz, algo_code)

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
        UTIL_makeTitle('test SNR (dB)', 'k', CONFIG.plot_title_fontsz); 
        %axis tight
        grid on;   
        hold off;
        
        
    %RMSE
        subplot(5,4,4);     
        hold on;
        plot(1:f, tst_RMSE(1:f),  [color '-']);  
        set(gca, 'FontSize', 8);
        UTIL_makeTitle('test rmse', 'k', CONFIG.plot_title_fontsz); 
        %axis tight
        grid on;   
        hold off; 


    %AVG RMSE
        subplot(5,4,8);     
        hold on;
        plot(1:f, tst_RMSEavg(1:f),  [color '-']); 
        set(gca, 'FontSize', 8);
        UTIL_makeTitle('mean test rmse', 'k', CONFIG.plot_title_fontsz);       
        %axis tight
        grid on;   
        hold off;  