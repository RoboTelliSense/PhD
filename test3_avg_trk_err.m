function [avg_trk_err, correctMask] = test3_avg_trk_err(algoMatrix, thresh)

    correctMask                 =   (algoMatrix<thresh);  
    numCorrect                  =   sum(sum(correctMask));
    algoMatrix_thresholded      =   correctMask.*algoMatrix;    
    avg_trk_err                 =   sum(sum(algoMatrix_thresholded))/numCorrect; 