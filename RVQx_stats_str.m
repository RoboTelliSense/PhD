function str_rvq = RVQx_stats_str(aRVQx, tst_n)

    maxQ                =   aRVQx.in_3__maxQ;
    
    str_rvq             =   sprintf('%8.0f%8.0f ', aRVQx.mdl_1_Q___1x1, aRVQx.tst_6_reqdQ_1xN(tst_n));
    
    %training: rmse after each stage (obtained from encoder codebook)
    for q =1:maxQ
        temp2           =   sprintf('%8.2f', aRVQx.trg_9_ermse_Qx1(q));   
        str_rvq         =   [str_rvq ' ' temp2];            
    end
        
    %test: rmse after each stage (obtained from decoder rms error at every
    %stage
    for q =1:maxQ
        temp2           =   sprintf('%8.2f', aRVQx.tst_9_drmse_Qx1(q)); %decoder rmses
        str_rvq         =   [str_rvq ' ' temp2];            
    end   