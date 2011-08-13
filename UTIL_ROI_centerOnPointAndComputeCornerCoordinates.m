%!! attention !! assumption that Ww and Wh, window width and height are odd

function [Wxl, Wxr, Wyt, Wyb] = UTIL_ROI_centerOnPointAndComputeCornerCoordinates(cx, cy, Ww, Wh)

    Wxl = cx - (Ww-1)/2;
    Wxr = cx + (Ww-1)/2;
    Wyt = cy - (Wh-1)/2;
    Wyb = cy + (Wh-1)/2;


%pick best target position
        %-------------------------
            %search window
%             temp_x              =   sX(1) - Wx - (sw-1);
%             temp_y              =   sY(1) - Wy - (sh-1);
%             temp_w              =   sw + 2*Wx + sx;
%             temp_h              =   sh + 2*Wy + sy;
%             Wi                  =   [temp_x, temp_y, temp_w, temp_h]; %search window in inner image dimensions
% 
%             %find best position of target
%             ROI                 =   B_ll(Wi(2) : Wi(2) + Wi(4),   Wi(1) : Wi(1) + Wi(3)); 
%             [r c]               =   find(ROI==max(ROI(:)));
%             cx                  =   Wi(1) + c-1;
%             cy                  =   Wi(2) + r-1;
%             sz                  =   size(cx);
%             if (sz(1)>1)
%                 cx = cx(1);
%                 cy = cy(1);
%             end