function SNR_thresholded = RVQ_FILES_threshold_SNRandSTG(SNR, STG, thresh_SNR, thresh_STG)

    [iih, iiw]                  =   size(STG);
    
    SNR_thresholded             =   zeros(iih, iiw);
    
    
    for r = 1:iih
        for c = 1:iiw

            if (   STG(r,c)     >=      thresh_STG  && ...
                   SNR(r,c)     >       thresh_SNR)
               
                SNR_thresholded(r,c) = SNR(r,c);
                
            end
            
        end
    end
            