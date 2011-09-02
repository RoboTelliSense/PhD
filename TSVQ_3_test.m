%CB: codebook
%mu: codevector
%P: number of stages
%x_Dx1: test vector
function TSVQ = TSVQ_3_test(x_Dx1, TSVQ)

    CB_DxKt                     =   TSVQ.mdl_2_CB_DxKt;
    P                           =   TSVQ.mdl_3_P;

%initialize
    descriptor_Px1              =   [];     %TSVQ descriptor, similar to XDR in RVQ
    K                           =   2;      %binary TSVQ, hence K=2

    parent_idx                  =   1;      %we start at: parent_idx = 1, see TSVQ_1_train for a nice graphic showing this
    p                           =   0;      %we start at: level (stage)      = 0


%test
    [p, descriptor_Px1]         =   TSVQ_givenParentFindBestChild_recursive(x_Dx1, parent_idx, descriptor_Px1, CB_DxKt, p, P); %descriptor_Px1 is binary VQ descriptor_Px1

%results
    best_mu_Dx1                 =   CB_DxKt(:, descriptor_Px1(P));
    err_Dx1                     =   x_Dx1-best_mu_Dx1;
    SNRdB                       =   UTIL_METRICS_compute_SNRdB(x_Dx1, err_Dx1);
    rmse                        =   UTIL_METRICS_compute_rms_value(err_Dx1);

    TSVQ.tst_1_descriptor_Px1   =   descriptor_Px1;
    TSVQ.tst_2_recon_Dx1        =   best_mu_Dx1;
    TSVQ.tst_3_err_Dx1          =   err_Dx1;
    TSVQ.tst_4_SNRdB            =   SNRdB;
    TSVQ.tst_5_rmse             =   rmse;   