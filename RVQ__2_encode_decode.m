
function RVQ = RVQ__2_encode_decode(DM2, RVQ)

%-------------------------------
%PRE-PROCESSING
%------------------------------- 
    [D,N]                   =   size(DM2);
    
    if (strcmp(RVQ.in_2__data, 'trg'))
        
        RVQ.trg_1_featr_QxN =   [];
        RVQ.trg_2_recon_DxN =   [];                                             
        RVQ.trg_3_error_DxN =   [];                                      
        RVQ.trg_4_SNRdB_1x1 =   -999;
        RVQ.trg_5_rmse__1x1 =   -999;
        RVQ.trg_6_encdQ_1xN =   [];  
        RVQ.trg_7_qidx__QxN =   []; 
        RVQ.trg_8_ermse_QxN =   [];
               
    elseif (strcmp(RVQ.in_2__data, 'tst'))
        
        RVQ.tst_1_featr_QxN =   [];
        RVQ.tst_2_recon_DxN =   [];                                             
        RVQ.tst_3_error_DxN =   [];                                      
        RVQ.tst_4_SNRdB_1x1 =   -999;
        RVQ.tst_5_rmse__1x1 =   -999;
        RVQ.tst_6_encdQ_1xN =   [];  
        RVQ.tst_7_qidx__QxN =   [];
        RVQ.tst_8_drmse_QxN =   [];
        
    end

        
%-------------------------------
% PROCESSING
%-------------------------------         
    for n=1:N
        x_Dx1               =   DM2(:,n);
        RVQ                 =   RVQ__2_encode_grayscale_onevector(x_Dx1, RVQ, n);
        RVQ                 =   RVQ__3_decode_grayscale_onevector(x_Dx1, RVQ, n);
    end        

%-------------------------------
% POST-PROCESSING
%-------------------------------    
    
    if (strcmp(RVQ.in_2__data, 'trg'))
        
        RVQ.trg_4_SNRdB_1x1 =   UTIL_METRICS_compute_SNRdB (DM2(:),  RVQ.trg_3_error_DxN(:));    %4.
        RVQ.trg_5_rmse__1x1 =   UTIL_METRICS_compute_rms   (         RVQ.trg_3_error_DxN(:));    %5.
        RVQ.trg_9_ermse_Qx1 =   DM2_compute_rms_of_every_dimension(RVQ.trg_8_ermse_QxN);
            
                                
     
    elseif (strcmp(RVQ.in_2__data, 'tst'))
        
        RVQ.tst_4_SNRdB_1x1 =   UTIL_METRICS_compute_SNRdB (DM2(:),  RVQ.tst_3_error_DxN(:));    %4.
        RVQ.tst_5_rmse__1x1 =   UTIL_METRICS_compute_rms   (         RVQ.tst_3_error_DxN(:));    %5.
        RVQ.tst_9_drmse_Qx1 =   DM2_compute_rms_of_every_dimension(RVQ.tst_8_drmse_QxN);
    end