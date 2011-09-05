%if (Ntrg_snp             >=  PARAM.trg_B)
                                TRK_draw_3a_metrics_trg( trkIPCA.trg_SNRdB_Tx1, trkIPCA.trg_RMSE_Tx1, trkIPCA.trg_RMSEavg_Tx1, f, PARAM.trg_frame_idxs,   PARAM.plot_title_fontsz, 1);        
    if (bUseBPCA )               TRK_draw_3a_metrics_trg( trkBPCA.trg_4_SNRdB_1x1, trkBPCA.trg_5_rmse__1x1, trkBPCA.trgout_avgrmse, f, PARAM.trg_frame_idxs,   PARAM.plot_title_fontsz, 2);        end
    if (bUseTSVQ)               TRK_draw_3a_metrics_trg( tsvq_trg_SNRdB, tsvq_trg_rmse, tsvq_trgout_avgrmse, f, PARAM.trg_frame_idxs,   PARAM.plot_title_fontsz, 4);        end
	if (bUseRVQ)                TRK_draw_3a_metrics_trg( rvq__trg_SNRdB, rvq__trg_rmse, rvq__trgout_avgrmse, f, PARAM.trg_frame_idxs,   PARAM.plot_title_fontsz, 3);        end 
%end



                                TRK_draw_3b_metrics_tst( trkIPCA.tst_SNRdB_Fx1, trkIPCA.out_5_rmse__Fx1, trkIPCA.out_6_armse_Fx1, f,          PARAM.plot_title_fontsz, 1);
    if (bUseBPCA )               TRK_draw_3b_metrics_tst( BPCA.tst_SNRdB_Fx1, bpca_tst_rmse, bpca_tst_avgrmse, f,          PARAM.plot_title_fontsz, 2);        end
    if (bUseTSVQ)               TRK_draw_3b_metrics_tst( tsvq_tst_SNRdB, tsvq_tst_rmse, tsvq_tst_avgrmse, f,          PARAM.plot_title_fontsz, 4);        end
	if (bUseRVQ)                TRK_draw_3b_metrics_tst( rvq__tst_SNRdB, rvq__tst_rmse, rvq__tst_avgrmse, f,          PARAM.plot_title_fontsz, 3);        end      
    

    



