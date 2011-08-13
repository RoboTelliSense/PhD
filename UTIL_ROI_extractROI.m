function Iroi = UTIL_ROI_extractROI(I, Rrect)

    rx      =   Rrect(1);
    ry      =   Rrect(2);
    rw      =   Rrect(3);
    rh      =   Rrect(4);
    
    
    Iroi    =   I(ry : ry+rh-1,   rx : rx+rw-1);