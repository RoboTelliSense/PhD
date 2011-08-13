%each signal row vector is concatenated to make one large signal vector
%same is done for error
function reconSNR_dB = TSVQ_3_test_designMatrix(DM, CB, T)

    [Ntrg, D]  = size(DM);
    
    S_rowvec = [];
    E_rowvec = [];
    for i=1:Ntrg
        Itst_rowvec                             =   DM(i,:);
        S_rowvec                                =   [S_rowvec Itst_rowvec];
        [recon, residual_rowvec, bVQ, snr_dB]   =   TSVQ_3_test(CB, T, Itst_rowvec);
        E_rowvec                                =   [E_rowvec residual_rowvec];
    end
    
    
    reconSNR_dB                                 =   UTIL_METRICS_compute_SNRdB(S_rowvec, E_rowvec);
                
