        if (f>CONST.trg_B)

            figure(2);
            subplot(5,5,5);     
            hold on; 
            if (bUseRVQ1) plot(CONST.trg_frame_idxs, rvq1_trgout_actual_stages,  'g-'); end
            if (bUseRVQ2) plot(CONST.trg_frame_idxs, rvq2_trgout_actual_stages,  'k-'); end

            set(gca, 'FontSize', 8);
            UTIL_makeTitle('stages in codebook', 'k', CONST.plot_title_fontsz); 
            %axis tight
            grid on;   
            hold off;
        
  

            figure(2);
            subplot(5,5,10);     
            hold on;            
            if (bUseRVQ1) plot(CONST.trg_B+1:f, rvq1_tst_maxstages(CONST.trg_B+1:f),  'g.-'); end
            if (bUseRVQ2) plot(CONST.trg_B+1:f, rvq2_tst_maxstages(CONST.trg_B+1:f),  'k.-'); end
            
            if (bUseRVQ1) plot(CONST.trg_B+1:f, rvq1_tst_stages(CONST.trg_B+1:f),  'g-'); end
            if (bUseRVQ2) plot(CONST.trg_B+1:f, rvq2_tst_stages(CONST.trg_B+1:f),  'k-'); end
            
            set(gca, 'FontSize', 8);
            UTIL_makeTitle('test stages (max and picked)', 'k', CONST.plot_title_fontsz); 
            %axis tight
            grid on;   

            hold off;
        
        end
        

