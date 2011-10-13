
function RVQ = RVQ__2_encode(DM2, RVQ)

%-------------------------------
%INITIALIZATION
%-------------------------------
    [D,N]                   =   size(DM2);
    
        
%-------------------------------
%PRE-PROCESSING
%------------------------------- 
    if (strcmp(RVQ.in_2__data, 'trg'))
        RVQ.trg_1_featr_QxN     =   [];
        RVQ.trg_2_recon_DxN     =   [];                                             
        RVQ.trg_3_error_DxN     =   [];                                      
        RVQ.trg_4_SNRdB_1x1     =   -999;
        RVQ.trg_5_rmse__1x1     =   -999;
        RVQ.trg_6_stopQ_1xN     =   [];  
        RVQ.trg_9_decrmses_QxN     =   [];
        RVQ.trg_7_qidx__QxN     =   [];        
    elseif (strcmp(RVQ.in_2__data, 'tst'))
        RVQ.tst_1_featr_QxN     =   [];
        RVQ.tst_2_recon_DxN     =   [];                                             
        RVQ.tst_3_error_DxN     =   [];                                      
        RVQ.tst_4_SNRdB_1x1     =   -999;
        RVQ.tst_5_rmse__1x1     =   -999;
        RVQ.tst_6_stopQ_1xN     =   [];  
        RVQ.tst_9_decrmses_QxN     =   [];
        RVQ.tst_7_qidx__QxN     =   [];
    end

        
        
    for n=1:N
        x_Dx1               =   DM2(:,n);
        RVQ                 =   RVQ__2_encode_grayscale_onevector(x_Dx1, RVQ, n);
        RVQ                 =   RVQ__3_decode_grayscale_onevector(x_Dx1, RVQ, n)
    end        

    if (strcmp(RVQ.in_2__data, 'trg'))
        RVQ.trg_4_SNRdB_1x1=   UTIL_METRICS_compute_SNRdB (DM2(:),  RVQ.trg_3_error_DxN(:));  
        RVQ.trg_5_rmse__1x1=   UTIL_METRICS_compute_rms   (         RVQ.trg_3_error_DxN(:));  
    elseif (strcmp(RVQ.in_2__data, 'tst'))
        RVQ.tst_4_SNRdB_1x1=   UTIL_METRICS_compute_SNRdB (DM2(:),  RVQ.tst_3_error_DxN(:));  
        RVQ.tst_5_rmse__1x1=   UTIL_METRICS_compute_rms   (         RVQ.tst_3_error_DxN(:));  
    end