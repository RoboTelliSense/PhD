%!!attention!! assumption here is that image is 1D

function [r, c, maxvalues] = UTIL_ROI_getBestValuesInROI(I, xl, xr, yt, yb, bDescending)

        [Ih, Iw] =  size(I); %I is image from which ROI is extracted
    
    %extract ROC
        ROI     =   I( yt : yb  ,   xl : xr  )  ;
        ROIw    =   xr-xl+1;
        ROIh    =   yb-yt+1; %you can also do [ROIh, ROIw] = size(ROI)
    
    %get max values and indeces in ROI
        temp                =   ROI';                       %Matlab sort command creates indeces that are counted columnwise, but I am used to counting row wise
        if (bDescending)
            [maxvalues indeces] =   sort(temp(:), 'descend');   %i.e. say in C, in computing idx = y*Iw+x, I count along rows
                                                                %that's why I
                                                                %transpose ROI
        else
            [maxvalues indeces] =   sort(temp(:), 'ascend');   %i.e. say in C, in computing idx = y*Iw+x, I count along rows
                                                                %that's why I
                                                                %transpose
                                                                %ROI
        end
    %convert indeces to r,c (ROI based)
        [r,c] = UTIL_idx_to_xy(indeces, ROIw);
                
    %convert indeces to r,c (image based)
        r = r + (yt-1);
        c = c + (xl-1);