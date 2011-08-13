        if (f>sOptions.batchsize)

            figure(2);
            subplot(5,5,5);     
            hold on; 
            if (bUseRVQ1) plot(f_trg, rvq1_trgout_actual_stages,  'g-'); end
            if (bUseRVQ2) plot(f_trg, rvq2_trgout_actual_stages,  'k-'); end

            set(gca, 'FontSize', 8);
            UTIL_makeTitle('stages in codebook', 'k', fs); 
            %axis tight
            grid on;   
            hold off;
        
  

            figure(2);
            subplot(5,5,10);     
            hold on;            
            if (bUseRVQ1) plot(sOptions.batchsize+1:f, rvq1_tst_maxstages(sOptions.batchsize+1:f),  'g.-'); end
            if (bUseRVQ2) plot(sOptions.batchsize+1:f, rvq2_tst_maxstages(sOptions.batchsize+1:f),  'k.-'); end
            
            if (bUseRVQ1) plot(sOptions.batchsize+1:f, rvq1_tst_stages(sOptions.batchsize+1:f),  'g-'); end
            if (bUseRVQ2) plot(sOptions.batchsize+1:f, rvq2_tst_stages(sOptions.batchsize+1:f),  'k-'); end
            
            set(gca, 'FontSize', 8);
            UTIL_makeTitle('test stages (max and picked)', 'k', fs); 
            %axis tight
            grid on;   

            hold off;
        
        end
        

