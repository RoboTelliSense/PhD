%rw is the ROI width, rh is the ROI height, ROI is the region in which we
%want to find the highest SNR/STG value. 

function [best_ix, best_iy] = RVQ_3_getBestTargetPositionFromSNRSTG(SNR, STG, gamma_SNR, gamma_STG, cix, ciy, rw, rh)

    %threshold
        SNR_thresholded         =   RVQ_FILES_threshold_SNRandSTG       (SNR, STG, gamma_SNR, gamma_STG);  %SNR_thresholded = medfilt2(SNR_thresholded(:,:,1), [3,3]);                        
        
    %find window
        rect                    =   UTIL_ROI_givenCenterFindRect    (cix, ciy, rw, rh);

    %find max in window
        bDescending             =   true;
        [r1, c1, maxvalues]     =   UTIL_ROI_getBestValuesInRect    (SNR_thresholded, rect, bDescending);

    %return highest value
        best_ix                =   c1(1);
        best_iy                =   r1(1);
                 
     %[Wxl, Wxr, Wyt, Wyb]=   UTIL_ROI_centerOnPointAndComputeCornerCoordinates(cix, ciy, Ww, Wh);
     %[r1, c1, maxvalues] =
     %UTIL_ROI_getBestValuesInROI(SNR_thresholded(:,:,1), Wxl, Wxr, Wyt, Wyb)
                 