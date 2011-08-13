%!! attention !! assumption that w (rect width) and h (rect height) are odd
%iw and ih are image width and height (these are being passed in so that
%the rect does not go out of the image)

function rect = UTIL_ROI_givenCenterFindRect(cx, cy, w, h)  %(cx, cy) is the center point of the window

    x      =   cx - (w-1)/2;
    y      =   cy - (h-1)/2;
    
    if (x < 1)
        x = 1;
    end
    
    if (y < 1)
        y=1;
    end

    rect    =   [x y w h];  %(x, y) is the top left coordinate of the rect