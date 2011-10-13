function RVQ = RVQ__3_decode_grayscale_onevector(x_Dx1, RVQ, n)
    
    cdbkQ                   =   RVQ.mdl_1_Q__1x1;                   %actual number of stages in the codebook
    D                       =   length(x_Dx1);
    M                       =   RVQ.in_4__M___;                     %number of codevectors/stage
    DC_DxMQ                 =   RVQ.mdl_4_DC_DxMQ;
    
    if      (strcmp(RVQ.in_2__data, 'trg'))   
        featr_Qx1           =   RVQ.trg_1_featr_QxN(:,n);
        stopQ               =   RVQ.trg_6_stopQ_1xN(1,n);
        qidx__Qx1           =   RVQ.trg_7_qidx__QxN(:,n);
        
    elseif  (strcmp(RVQ.in_2__data, 'tst'))   
        featr_Qx1           =   RVQ.tst_1_featr_QxN(:,n);
        stopQ               =   RVQ.tst_6_stopQ_1xN(1,n);
        qidx__Qx1           =   RVQ.tst_7_qidx__QxN(:,n);
        
    end
    
    recon_Dx1               =   zeros(D,1);
    for q=1:stopQ
        if (qidx_(q) ~= -9999)
            CV_Dx1          =	RVQ_FILES_getCodevectorFromCodebook(qidx_(q), q, M, DC_DxMQ);   %get codevector 
            recon_Dx1       =   recon_Dx1 + CV_Dx1;                                             %(a) reconstruction
            error_Dx1       =   x_Dx1 - temp2_recon_Dx1;                                        %(b) residual error
            rmses_Qx1(q,1)  =   UTIL_METRICS_compute_rms (error_Dx1);                           %(c) comparison metric
        end
    end
    
    if (strcmp(RVQ.in_2__data, 'trg'))         
        %RVQ.trg_1_featr_QxN(:,n)=   featr_Qx1;                             %1.                                               
        RVQ.trg_2_recon_DxN(:,n)=   recon_Dx1;                              %2.               
        RVQ.trg_3_error_DxN(:,n)=   error_Dx1;                              %3.               
        
        %RVQ.trg_6_stopQ_1xN(1,n)=   stopQ;                                 %num of stages
        %RVQ.trg_7_qidx__QxN(:,n)=   qidx__Qx1; 
        RVQ.trg_9_decrmses_QxN(:,n)= rmses_Qx1;                             %rmse at every stage
        
        
    elseif (strcmp(RVQ.in_2__data, 'tst'))        
        %RVQ.tst_1_featr_QxN(:,n)=  featr_Qx1;                              %1.             
        RVQ.tst_2_recon_DxN(:,n)=   recon_Dx1;                              %2.               
        RVQ.tst_3_error_DxN(:,n)=   error_Dx1;                              %3.        
        
        %RVQ.tst_6_stopQ_1xN(1,n)=  stopQ;  
        %RVQ.tst_7_qidx__QxN(:,n)=   qidx__Qx1;     
        RVQ.tst_9_decrmses_QxN(:,n)=   rmses_Qx1;
             
    end