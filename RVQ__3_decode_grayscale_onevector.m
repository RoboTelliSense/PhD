function RVQ = RVQ__3_decode_grayscale_onevector(x_Dx1, RVQ, n)
   
    Q                      =   RVQ.mdl_1_Q___1x1;                           %number of stages in codebook
    maxQ                    =   RVQ.in_3__maxQ;
    D                       =   length(x_Dx1);
    M                       =   RVQ.in_4__M___;                             %number of codevectors/stage
    DC_DxMQ                =   RVQ.mdl_4_DC_DxMQ;                          %decoder codebook
    
    if      (strcmp(RVQ.in_2__data, 'trg'))   
        featr_Qx1           =   RVQ.trg_1_featr_QxN(:,n);
        fQ                  =   RVQ.trg_6_stopQ_1xN(1,n);                   %number of stages in feature vector
        qidx_Qx1           =   RVQ.trg_7_qidx__QxN(:,n);
        
    elseif  (strcmp(RVQ.in_2__data, 'tst'))   
        featr_Qx1           =   RVQ.tst_1_featr_QxN(:,n);
        fQ                  =   RVQ.tst_6_stopQ_1xN(1,n);
        qidx_Qx1           =   RVQ.tst_7_qidx__QxN(:,n);
        
    end
    
    recon_Dx1               =   zeros(D,1);
    rmses_Qx1               =   -9999*ones(maxQ,1);
    for q=1:maxQ                      
        if (qidx_Qx1(q) ~= -9999)
            CV_Dx1          = RVQ_FILES_getCodevectorFromCodebook(featr_Qx1(q), q, M, DC_DxMQ);   %get codevector 
            recon_Dx1       =   recon_Dx1 + CV_Dx1;                                             %(a) reconstruction
            error_Dx1       =   x_Dx1 - recon_Dx1;                                        %(b) residual error
            rmses_Qx1(q,1)  =   UTIL_METRICS_compute_rms (error_Dx1);                           %(c) comparison metric
        end
    end
    
    RVQ.tst_2_recon_DxN(:,n)=   recon_Dx1;                              %2.               
    RVQ.tst_3_error_DxN(:,n)=   error_Dx1;                              %3.        
    RVQ.tst_8_drmse_QxN(:,n)=   rmses_Qx1;

    end
