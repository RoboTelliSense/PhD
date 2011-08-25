        if (f>CONFIG.trg_updateInterval)

            figure(2);
            subplot(5,5,5);     
            hold on; 
            if (bUseRVQ1) plot(CONFIG.trg_frames, rvq1_trgout_actual_stages,  'g-'); end
            if (bUseRVQ2) plot(CONFIG.trg_frames, rvq2_trgout_actual_stages,  'k-'); end

            set(gca, 'FontSize', 8);
            UTIL_makeTitle('stages in codebook', 'k', CONFIG.plot_title_fontsize); 
            %axis tight
            grid on;   
            hold off;
        
  

            figure(2);
            subplot(5,5,10);     
            hold on;            
            if (bUseRVQ1) plot(CONFIG.trg_updateInterval+1:f, rvq1_tst_maxstages(CONFIG.trg_updateInterval+1:f),  'g.-'); end
            if (bUseRVQ2) plot(CONFIG.trg_updateInterval+1:f, rvq2_tst_maxstages(CONFIG.trg_updateInterval+1:f),  'k.-'); end
            
            if (bUseRVQ1) plot(CONFIG.trg_updateInterval+1:f, rvq1_tst_stages(CONFIG.trg_updateInterval+1:f),  'g-'); end
            if (bUseRVQ2) plot(CONFIG.trg_updateInterval+1:f, rvq2_tst_stages(CONFIG.trg_updateInterval+1:f),  'k-'); end
            
            set(gca, 'FontSize', 8);
            UTIL_makeTitle('test stages (max and picked)', 'k', CONFIG.plot_title_fontsize); 
            %axis tight
            grid on;   

            hold off;
        
        end
        

