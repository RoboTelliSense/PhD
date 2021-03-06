%CB: codebook
%mu: codevector
%P: number of stages
%x_Dx1: test vector
function TSVQ = TSVQ_3_test(DM2, TSVQ)

    [D,N]                           =   size(DM2);

    for n=1:N
        
        %------------------------------
        % INITIALIZE
        %------------------------------ 
        x_Dx1                       =   DM2(:,n);
        CB_DxKt                     =   TSVQ.mdl_3_CB_DxKt;
        P                           =   TSVQ.mdl_1_P__1x1;

        descr_Px1                   =   [];     %TSVQ descriptor, similar to XDR in RVQ
        K                           =   2;      %binary TSVQ, hence K=2

        parent_idx                  =   1;      %we start at: parent_idx = 1, see TSVQ_1_train for a nice graphic showing this
        p                           =   0;      %we start at: level (stage)      = 0


        %------------------------------
        % PROCESSING (compute 5 things)
        %------------------------------ 
        [p, descr_Px1]      =   TSVQ_givenParentFindBestChild_recursive(x_Dx1, parent_idx, descr_Px1, CB_DxKt, p, P); %descr_Px1 is binary VQ descr_Px1
        recon_Dx1           =   CB_DxKt(:, descr_Px1(P));
        error_Dx1           =   x_Dx1-recon_Dx1;
        SNRdB               =   UTIL_METRICS_compute_SNRdB(x_Dx1, error_Dx1);
        rmse                =   UTIL_METRICS_compute_rms_value(error_Dx1);

        %------------------------------
        % POST-PROCESSING
        %------------------------------         
        %save        
        if (strcmp(TSVQ.in_2_mode, 'trg'))
            TSVQ.trg_1_descr_PxN(:,n)   =   descr_Px1;
            TSVQ.trg_2_recon_DxN(:,n)   =   recon_Dx1;
            TSVQ.trg_3_error_DxN(:,n)   =   error_Dx1;
        elseif (strcmp(TSVQ.in_2_mode, 'tst'))
            TSVQ.tst_1_descr_PxN(:,n)   =   descr_Px1;
            TSVQ.tst_2_recon_DxN(:,n)   =   recon_Dx1;
            TSVQ.tst_3_error_DxN(:,n)   =   error_Dx1;
        end
        
        
    end
    %end looping over input data points
    
    if (strcmp(TSVQ.in_2_mode, 'trg'))
        TSVQ.trg_4_SNRdB_1x1=   UTIL_METRICS_compute_SNRdB       (DM2(:),  TSVQ.trg_3_error_DxN(:));  
        TSVQ.trg_5_rmse__1x1=   UTIL_METRICS_compute_rms_value   (         TSVQ.trg_3_error_DxN(:));  
    elseif (strcmp(TSVQ.in_2_mode, 'tst'))
        TSVQ.tst_4_SNRdB_1x1=   UTIL_METRICS_compute_SNRdB       (DM2(:),  TSVQ.tst_3_error_DxN(:));  
        TSVQ.tst_5_rmse__1x1=   UTIL_METRICS_compute_rms_value   (         TSVQ.tst_3_error_DxN(:));  
    end    
    