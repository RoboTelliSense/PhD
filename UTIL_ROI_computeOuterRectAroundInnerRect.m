%3 players here:
%1. inner rect (this has all the pixels you want to test)
%2. window: you place a sliding window on every pixel of inner rect,
%however since you can't place the window on the border or close to border
%pixels, you need a larger outer rect.
%3. outer rect

%so basically you want to compute a larger rect outside inner rect so that a sliding
%window with dimensions ww x wh can be centered on any pixel in the inner
%rect

%the center of the inner rect is (ricx, ricy)

function Rrect = UTIL_ROI_computeOuterRectAroundInnerRect(ricx, ricy, riw, rih, ww, wh)
  
        borderx     =   (ww-1)/2; 
        bordery     =   (wh-1)/2; 
    
    %you want to test in rect               [rix, riy, riw, rih]
    %but you need to extract a larger rect  [rx,  ry,  rw,  rh]
    %(ricx, ricy) is center of both rects
        rw          =   riw + (2 * borderx);
        rh          =   rih + (2 * bordery);
        Rrect       =   UTIL_ROI_givenCenterFindRect(ricx, ricy, rw, rh);
        
        