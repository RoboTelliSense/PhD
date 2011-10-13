function [trg_idxs, tst_idxs] = UTIL_DATA_get_trg_tst_idxs(N, percentage_tst)
    
    start                   =   1;
    stop                    =   N;
    cnt                     =   round(percentage_tst*N);
    
    bSorted                 =   1;
    bNoDuplicates           =   1;
    bPlot                   =   0;
    
    tst_idxs                =   rand_int(start, stop, cnt, bSorted, bNoDuplicates, bPlot);
    trg_idxs                =   (setdiff([start:stop], tst_idxs))';
