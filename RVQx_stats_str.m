function str_rvq = RVQx_stats_str(aRVQx,n)

    cQ               =   aRVQx.mdl_1_Q___1x1;
    
    str_rvq             =   sprintf('%8.0f%8.0f ', cQ, aRVQx.tst_6_encdQ_1xN(n));
    
    %feature vector (obtained from encoder codebook)
    for q =1:cQ
        temp2           =   sprintf('%8.0f', aRVQx.tst_1_featr_QxN(q,n));   
        str_rvq         =   [str_rvq ' ' temp2];            
    end
        
    %decoder rms error at every stage
    for q =1:cQ
        temp2           =   sprintf('%8.2f', aRVQx.tst_8_drmse_QxN(q,n)); %decoder rmses
        str_rvq         =   [str_rvq ' ' temp2];            
    end   