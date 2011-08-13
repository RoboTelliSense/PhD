function avg_trg_err = test3_avg_trgtst_err(algoMatrix, correctMask)

    numCorrect                  =   sum(sum(correctMask));
    algoMatrix_thresholded      =   correctMask.*algoMatrix;    
    avg_trg_err                 =   sum(sum(algoMatrix_thresholded))/numCorrect; 