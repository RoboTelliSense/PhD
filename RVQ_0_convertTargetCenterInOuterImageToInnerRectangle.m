function [innerRect] = RVQ_0_convertTargetCenterInOuterImageToInnerRectangle(cx, cy, sw, sh, sNx, sNy)
    
    
    innerRect(1) = cx - (sNx-1)/2 - (sw-1)/2;
    innerRect(2) = cy - (sNy-1)/2 - (sh-1)/2;
    innerRect(3) = sNx;
    innerRect(4) = sNy;
