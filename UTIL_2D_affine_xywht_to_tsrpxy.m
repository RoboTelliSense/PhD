function tsrpxy = UTIL_2D_affine_xywht_to_tsrpxy(xywht, scale)

    top_left_x              =   xywht(1);
    top_left_y              =   xywht(2);
    w                       =   xywht(3);       
    h                       =   xywht(4);
    theta                   =   xywht(5);
    
    s                       =   w/scale;
    r                       =   h/w;                %aspect ratio
    
    tx                      =   top_left_x + w/2;   %x coordinate of center of bounding box
    ty                      =   top_left_y + h/2;   %y      "      "    "    "     "     " 
    
%------------------------    
% PROCESSING
%------------------------
    tsrpxy(1)               =   theta;          
    tsrpxy(2)               =   s;              
    tsrpxy(3)               =   r;              
    tsrpxy(4)               =   0;                     
    tsrpxy(5)               =   tx;               
    tsrpxy(6)               =   ty;               