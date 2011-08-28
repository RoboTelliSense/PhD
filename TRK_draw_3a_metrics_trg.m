function TRK_draw_3a_metrics_trg(trgSNR, trg_RMSE, trg_RMSEavg, f, CONFIG.trg_frames, CONFIG.plot_title_fontsz, algo_code) 

    if      (algo_code==1)  str='iPCA';     color = 'r';    
    elseif  (algo_code==2)  str='bPCA';     color = 'm';
    elseif  (algo_code==3)  str='RVQ';      color = 'g';
    elseif  (algo_code==4)  str='TSVQ';     color = 'b';
    end 
    
    
    
    %SNR
%         subplot(5,4,5);     
%         hold on; 
%         plot(CONFIG.trg_frames, trgSNR,  [color '-']);    
%         UTIL_makeTitle('SNR (dB)', 'k', CONFIG.plot_title_fontsz);     
%         %axis tight
%         grid on;   
%         hold off;
        
        
    %RMSE
        subplot(5,4,3);
        hold on;
        plot(CONFIG.trg_frames, trg_RMSE,  [color '-']);  
        set(gca, 'FontSize', 8);
        UTIL_makeTitle('training rmse', 'k', CONFIG.plot_title_fontsz);       
        %axis tight
        grid on;   
        hold off; 


    %AVG RMSE
        subplot(5,4,7); 
        hold on;
        plot(CONFIG.trg_frames, trg_RMSEavg,  [color '-']);
        set(gca, 'FontSize', 8);
        UTIL_makeTitle('mean training rmse', 'k', CONFIG.plot_title_fontsz);   
        %axis tight
        grid on;   
        hold off;  
    
   