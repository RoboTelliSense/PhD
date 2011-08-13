%!!caution!! assumption here is that image is 1D

function [R, C, maxvalues] = UTIL_ROI_getBestValuesInRect(I, win, bDescending) %win is window, an ROI

        [Ih, Iw]    =  size(I); %I is image from which Iwin is extracted
    
        wx          =   win(1);    %top left x coordinate of win
        wy          =   win(2);    %top left y coordinate of win
        ww          =   win(3);
        wh          =   win(4);
       
        Iwin       =   I( wy : wy + wh - 1  ,   wx : wx + ww - 1  )  ;  %image containing pixels in win

    
    %get max values and indeces in Iwin
        temp                    =   Iwin';                         %Matlab sort command creates indeces that are counted columnwise, but I am used to counting row wise
        if (bDescending)
            [maxvalues indeces] =   sort(temp(:), 'descend');       %i.e. say in C, in computing idx = y*Iw+x, I count along rows that's why I transpose Iwin
        else
            [maxvalues indeces] =   sort(temp(:), 'ascend');   
        end
        
    %convert indeces to r,c (Iwin based)
        [R,C] = UTIL_idx_to_xy(indeces, ww);
                
    %convert indeces to r,c (image based)
        R = R + (wy-1);
        C = C + (wx-1);