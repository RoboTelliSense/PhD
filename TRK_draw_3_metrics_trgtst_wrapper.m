%if (Ntrg_snp             >=  CONFIG.trg_updateInterval)
                                TRK_draw_3a_metrics_trg( trkIPCA.trg_SNRdB_Tx1, trkIPCA.trg_RMSE_Tx1, trkIPCA.trg_RMSEavg_Tx1, f, CONFIG.trg_frames,   CONFIG.plot_title_fontsize, 1);        
    if (bUseBPCA )               TRK_draw_3a_metrics_trg( trkBPCA.trg_SNRdB, trkBPCA.trg_rmse, trkBPCA.trgout_avgrmse, f, CONFIG.trg_frames,   CONFIG.plot_title_fontsize, 2);        end
    if (bUseTSVQ)               TRK_draw_3a_metrics_trg( tsvq_trg_SNRdB, tsvq_trg_rmse, tsvq_trgout_avgrmse, f, CONFIG.trg_frames,   CONFIG.plot_title_fontsize, 4);        end
	if (bUseRVQ)                TRK_draw_3a_metrics_trg( rvq__trg_SNRdB, rvq__trg_rmse, rvq__trgout_avgrmse, f, CONFIG.trg_frames,   CONFIG.plot_title_fontsize, 3);        end 
%end



                                TRK_draw_3b_metrics_tst( trkIPCA.tst_SNRdB_Fx1, trkIPCA.tst_RMSE_Fx1, trkIPCA.tst_RMSEavg_Fx1, f,          CONFIG.plot_title_fontsize, 1);
    if (bUseBPCA )               TRK_draw_3b_metrics_tst( BPCA.tst_SNRdB_Fx1, bpca_tst_rmse, bpca_tst_avgrmse, f,          CONFIG.plot_title_fontsize, 2);        end
    if (bUseTSVQ)               TRK_draw_3b_metrics_tst( tsvq_tst_SNRdB, tsvq_tst_rmse, tsvq_tst_avgrmse, f,          CONFIG.plot_title_fontsize, 4);        end
	if (bUseRVQ)                TRK_draw_3b_metrics_tst( rvq__tst_SNRdB, rvq__tst_rmse, rvq__tst_avgrmse, f,          CONFIG.plot_title_fontsize, 3);        end      
    

    



