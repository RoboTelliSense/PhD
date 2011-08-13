%if (Ntrg_snp             >=  sOptions.batchsize)
                                TRK_draw_3a_metrics_trg( ipca_trg_SNRdB, ipca_trg_rmse, ipca_trgout_avgrmse, f, f_trg,   fs, 1);        
    if (bUsebPCA)               TRK_draw_3a_metrics_trg( bpca_trg_SNRdB, bpca_trg_rmse, bpca_trgout_avgrmse, f, f_trg,   fs, 2);        end
    if (bUseTSVQ)               TRK_draw_3a_metrics_trg( tsvq_trg_SNRdB, tsvq_trg_rmse, tsvq_trgout_avgrmse, f, f_trg,   fs, 4);        end
	if (bUseRVQ)                TRK_draw_3a_metrics_trg( rvq__trg_SNRdB, rvq__trg_rmse, rvq__trgout_avgrmse, f, f_trg,   fs, 3);        end 
%end



                                TRK_draw_3b_metrics_tst( ipca_tst_snr, ipca_tst_rmse, ipca_tst_avgrmse, f,          fs, 1);
    if (bUsebPCA)               TRK_draw_3b_metrics_tst( bpca_tst_snr, bpca_tst_rmse, bpca_tst_avgrmse, f,          fs, 2);        end
    if (bUseTSVQ)               TRK_draw_3b_metrics_tst( tsvq_tst_snr, tsvq_tst_rmse, tsvq_tst_avgrmse, f,          fs, 4);        end
	if (bUseRVQ)                TRK_draw_3b_metrics_tst( rvq__tst_snr, rvq__tst_rmse, rvq__tst_avgrmse, f,          fs, 3);        end      
    

    



