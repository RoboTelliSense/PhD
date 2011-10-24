function [trkIPCA, trkBPCA, trkRVQ, trkTSVQ] = TRK_updateMetrics(CONFIG, )

		trkIPCA.tst_SNRdB_Fx1(f)  	=   trkIPCA.tst_4_SNRdB_1x1;
        trkIPCA.trk_rmse__Fx1(f)    	=   trkIPCA.tst_5_rmse__1x1;
        trkIPCA.trk_armse_Fx1(f) 	=   UTIL_compute_avg(trkIPCA.trk_rmse__Fx1(1:f));
		


                            trkIPCA.trg_SNRdB_Tx1      =   [trkIPCA.trg_SNRdB_Tx1        IPCA.trg_4_SNRdB_1x1];
                            trkIPCA.trg_rmse__Tx1       =   [trkIPCA.trg_rmse__Tx1       IPCA.trg_5_rmse__1x1];
                            temp1               =   UTIL_compute_avg (trkIPCA.trg_rmse__Tx1); trkIPCA.trg_armse_Tx1  =   [trkIPCA.trg_armse_Tx1  temp1 ]; 

	if (PARAM.in_bUseBPCA )   BPCA.tst_SNRdB_Fx1(f) =   trkIPCA.tst_SNRdB_Fx1(f);                    end
	if (PARAM.in_bUseRVQ)    rvq__tst_SNRdB(f) =   trkIPCA.tst_SNRdB_Fx1(f);                    end
	if (PARAM.in_bUseTSVQ)   tsvq_tst_SNRdB(f) =   trkIPCA.tst_SNRdB_Fx1(f);                    end

	if (PARAM.in_bUseBPCA )   bpca_tst_rmse(f)=   trkIPCA.trk_rmse__Fx1(f);                    end
	if (PARAM.in_bUseRVQ)    rvq__tst_rmse(f)=   trkIPCA.trk_rmse__Fx1(f);                    end
	if (PARAM.in_bUseTSVQ)   tsvq_tst_rmse(f)=   trkIPCA.trk_rmse__Fx1(f);                    end

	if (PARAM.in_bUseBPCA )   bpca_tst_avgrmse(f)=   trkIPCA.trk_armse_Fx1(f);                    end
	if (PARAM.in_bUseRVQ)    rvq__tst_avgrmse(f)=   trkIPCA.trk_armse_Fx1(f);                    end
	if (PARAM.in_bUseTSVQ)   tsvq_tst_avgrmse(f)=   trkIPCA.trk_armse_Fx1(f);                    end
			
			
			
		if (PARAM.in_bUseIPCA )   trkIPCA.tst_SNRdB_Fx1(f)=   trkIPCA.tst_4_SNRdB_1x1;     end
		if (PARAM.in_bUseBPCA )   tst_SNRdB_Fx1(f)=   trkBPCA.tst_4_SNRdB_1x1;     end
		if (PARAM.in_bUseRVQ)    rvq__tst_SNRdB(f)=   trkRVQ.tst_4_SNRdB_1x1;     end  
		if (PARAM.in_bUseTSVQ)   tsvq_tst_SNRdB(f)=   trkTSVQ.tst_4_SNRdB_1x1;     end

		if (PARAM.in_bUseBPCA )   bpca_tst_rmse(f)=   trkBPCA.tst_5_rmse__1x1;     end
		if (PARAM.in_bUseRVQ)    rvq__tst_rmse(f)=   trkRVQ.tst_5_rmse__1x1;     end  
		if (PARAM.in_bUseTSVQ)   tsvq_tst_rmse(f)=   trkTSVQ.tst_5_rmse__1x1;     end

		if (PARAM.in_bUseBPCA )   bpca_tst_avgrmse(f)=   UTIL_compute_avg     (bpca_tst_rmse(1:f));  end
		if (PARAM.in_bUseRVQ)    rvq__tst_avgrmse(f)=   UTIL_compute_avg     (rvq__tst_rmse(1:f));  end
            if (PARAM.in_bUseTSVQ)   tsvq_tst_avgrmse(f)=   UTIL_compute_avg     (tsvq_tst_rmse(1:f));  end


            if (PARAM.in_bUseBPCA )   trkBPCA.trg_4_SNRdB_1x1      =   [trkBPCA.trg_4_SNRdB_1x1        BPCA.trg_4_SNRdB_1x1];                        end
            if (PARAM.in_bUseRVQ)    rvq__trg_SNRdB      =   [rvq__trg_SNRdB        RVQ.trg_4_SNRdB_1x1];                        end
            if (PARAM.in_bUseTSVQ)   tsvq_trg_SNRdB      =   [tsvq_trg_SNRdB        TSVQ.trg_4_SNRdB_1x1];                        end

            if (PARAM.in_bUseBPCA )   trkBPCA.trg_5_rmse__1x1       =   [trkBPCA.trg_5_rmse__1x1      BPCA.trg_5_rmse__1x1];                        end
            if (PARAM.in_bUseRVQ)    rvq__trg_rmse       =   [rvq__trg_rmse      RVQ.trg_5_rmse__1x1];                        end
            if (PARAM.in_bUseTSVQ)   tsvq_trg_rmse       =   [tsvq_trg_rmse      TSVQ.trg_5_rmse__1x1];                        end

            if (PARAM.in_bUseBPCA )   temp2 = UTIL_compute_avg (trkBPCA.trg_5_rmse__1x1); trkBPCA.trgout_avgrmse  =   [trkBPCA.trgout_avgrmse  temp2 ];                    end
            if (PARAM.in_bUseRVQ)    temp3 = UTIL_compute_avg (rvq__trg_rmse); rvq__trgout_avgrmse  =   [rvq__trgout_avgrmse  temp3];                    	end
            if (PARAM.in_bUseTSVQ)   temp4 = UTIL_compute_avg (tsvq_trg_rmse); tsvq_trgout_avgrmse  =   [tsvq_trgout_avgrmse  temp4];                     end     			