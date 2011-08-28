%CB: codebook
%mu: codevector
%P: number of stages
function TSVQ = TSVQ_3_test(tst_Dx1, TSVQ)

    CB_DxKt                 =   TSVQ.CB_DxKt;
    P                       =   TSVQ.P;

%initialize
    descriptor_Px1          =   [];     %TSVQ descriptor, similar to XDR in RVQ
    K                       =   2;      %binary TSVQ, hence K=2

    parent_idx              =   1;      %we start at: parent_idx = 1, see TSVQ_1_train for a nice graphic showing this
    p                       =   0;      %we start at: level (stage)      = 0


%test
    [p, descriptor_Px1]     =   TSVQ_givenParentFindBestChild_recursive(tst_Dx1, parent_idx, descriptor_Px1, CB_DxKt, p, P); %descriptor_Px1 is binary VQ descriptor_Px1

%results
    best_mu_Dx1             =   CB_DxKt(:, descriptor_Px1(P));
    err_Dx1                 =   tst_Dx1-best_mu_Dx1;
    %snr_dB                 =   UTIL_METRICS_compute_PSNRdB(255, err_Dx1(:));
    snr_dB                  =   UTIL_METRICS_compute_SNRdB(tst_Dx1, err_Dx1);
    rmse                    =   UTIL_METRICS_compute_rms_value(err_Dx1);

    TSVQ.tst_2_recon_Dx1        =   best_mu_Dx1;
    TSVQ.tst_3_err_Dx1          =   err_Dx1;
    TSVQ.tst_SNRdB          =   snr_dB;
    TSVQ.tst_rmse         =   rmse;

    TSVQ.tst_1_descriptor_Px1       =   descriptor_Px1;


        