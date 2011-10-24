%CB: codebook
%mu: codevector
%Q: number of stages
%x_Dx1: test vector
function TSVQ = TSVQ_2_encode(DM2, TSVQ)

    [D,N]                           =   size(DM2);

    for n=1:N
        
        %------------------------------
        % INITIALIZE
        %------------------------------ 
        x_Dx1                       =   DM2(:,n);
        CB_DxKt                     =   TSVQ.mdl_3_CB_DxKt;
        Q                           =   TSVQ.mdl_1_Q__1x1;

        featr_Qx1                   =   [];     %TSVQ feature vector, similar to XDR in RVQ
        K                           =   2;      %binary TSVQ, hence K=2

        parent_idx                  =   1;      %we start at: parent_idx = 1, see TSVQ_1_learn for a nice graphic showing this
        q                           =   0;      %we start at: level (stage)      = 0


        %------------------------------
        % PROCESSING (compute 5 things)
        %------------------------------ 
        [q, featr_Qx1]      =   TSVQ_givenParentFindBestChild_recursive(x_Dx1, parent_idx, featr_Qx1, CB_DxKt, q, Q); %featr_Qx1 is binary VQ featr_Qx1
        recon_Dx1           =   CB_DxKt(:, featr_Qx1(Q));
        error_Dx1           =   x_Dx1-recon_Dx1;
        SNRdB               =   UTIL_METRICS_compute_SNRdB(x_Dx1, error_Dx1);
        rmse                =   UTIL_METRICS_compute_rms(error_Dx1);

        
        %save stats: 1, 2, 3
        if (strcmp(TSVQ.in_2__data, 'trg'))
            TSVQ.trg_1_featr_QxN(:,n)   =   featr_Qx1;
            TSVQ.trg_2_recon_DxN(:,n)   =   recon_Dx1;
            TSVQ.trg_3_error_DxN(:,n)   =   error_Dx1;
        elseif (strcmp(TSVQ.in_2__data, 'tst'))
            TSVQ.tst_1_featr_QxN(:,n)   =   featr_Qx1;
            TSVQ.tst_2_recon_DxN(:,n)   =   recon_Dx1;
            TSVQ.tst_3_error_DxN(:,n)   =   error_Dx1;
        end        
    end
    %end looping over input data points

%------------------------------
% POST-PROCESSING
%------------------------------     
%save stats: 4, 5
    if (strcmp(TSVQ.in_2__data, 'trg'))
        TSVQ.trg_4_SNRdB_1x1=   UTIL_METRICS_compute_SNRdB      (DM2(:),  TSVQ.trg_3_error_DxN(:));  
        TSVQ.trg_5_rmse__1x1=   UTIL_METRICS_compute_rms        (         TSVQ.trg_3_error_DxN(:));  
    elseif (strcmp(TSVQ.in_2__data, 'tst'))
        TSVQ.tst_4_SNRdB_1x1=   UTIL_METRICS_compute_SNRdB      (DM2(:),  TSVQ.tst_3_error_DxN(:));  
        TSVQ.tst_5_rmse__1x1=   UTIL_METRICS_compute_rms        (         TSVQ.tst_3_error_DxN(:));  
    end    
    