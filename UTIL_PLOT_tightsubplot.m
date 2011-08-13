%Downloaded from web (don't know from where) and modified.  All rights reserved.
%Date: July 7, 2011.
%%
%Description: 
%This file displays several images in one figure.
%%

function UTIL_PLOT_tightsubplot(numRows, numCols, idx, I_rgb)

    colormap('gray');
       
    [row, col]      =   UTIL_idx_to_xy(idx, numCols);
    row             =   double(row-1);
    col             =   double(col-1);
    x               =   col*(1/numCols);
    y               =   (numRows-row-1)*(1/numRows);
    
    
    w               =   1/numCols-.001;
    h               =   1/numRows-0.001;
                        subplot('position', [x, y, w, h]); 
  
                        imagesc((I_rgb));
                        axis equal
                        axis off; 



