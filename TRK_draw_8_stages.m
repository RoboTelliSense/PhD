        if (f>PARAM.trg_freq)

            figure(2);
            subplot(5,5,5);     
            hold on; 
            if (bUseRVQE1) plot(PARAM.trg_frame_idxs, rvq1_trgout_actual_stages,  'g-'); end
            if (bUseRVQE2) plot(PARAM.trg_frame_idxs, rvq2_trgout_actual_stages,  'k-'); end

            set(gca, 'FontSize', 8);
            UTIL_makeTitle('stages in codebook', 'k', PARAM.plot_title_fontsz); 
            %axis tight
            grid on;   
            hold off;
        
  

            figure(2);
            subplot(5,5,10);     
            hold on;            
            if (bUseRVQE1) plot(PARAM.trg_freq+1:f, rvq1_tst_maxstages(PARAM.trg_freq+1:f),  'g.-'); end
            if (bUseRVQE2) plot(PARAM.trg_freq+1:f, rvq2_tst_maxstages(PARAM.trg_freq+1:f),  'k.-'); end
            
            if (bUseRVQE1) plot(PARAM.trg_freq+1:f, rvq1_tst_stages(PARAM.trg_freq+1:f),  'g-'); end
            if (bUseRVQE2) plot(PARAM.trg_freq+1:f, rvq2_tst_stages(PARAM.trg_freq+1:f),  'k-'); end
            
            set(gca, 'FontSize', 8);
            UTIL_makeTitle('test stages (max and picked)', 'k', PARAM.plot_title_fontsz); 
            %axis tight
            grid on;   

            hold off;
        
        end
        

