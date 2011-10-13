function [trg_armse, tst_armse] = UTIL_DATA_crossvalidation(DM2, ALGO, numTrials, percentage_tst)

    [D, N]                  =   size(DM2);

    for i=1:numTrials
        
        [trg_idxs, tst_idxs]=   UTIL_DATA_get_trg_tst_idxs(N, percentage_tst);
        DM2_trg             =   DM2(:,trg_idxs);
        DM2_tst             =   DM2(:,tst_idxs);
        
        if (strcmp(ALGO.in_1__name, 'aBPCA'))
            ALGO            =   PCA__1_learn            (DM2_trg, ALGO);
            ALGO            =   PCA__2_encode_decode    (DM2_tst, ALGO);
        
        elseif (strcmp(ALGO.in_1__name, 'aRVQx'))
            ALGO            =   RVQ__1_learn            (DM2_trg, ALGO);
            ALGO            =   RVQ__2_encode_decode    (DM2_tst, ALGO);
        
        elseif (strcmp(ALGO.in_1__name, 'aTSVQ'))
            ALGO            =   TSVQ_1_learn            (DM2_trg, ALGO);
            ALGO            =   TSVQ_2_encode_decode    (DM2_tst, ALGO);
        end
        
        trg_rmse(i)         =   ALGO.trg_5_rmse__1x1;
        tst_rmse(i)         =   ALGO.tst_5_rmse__1x1; 
        
    end

    trg_armse               =   mean(trg_rmse);
    tst_armse               =   mean(tst_rmse);

