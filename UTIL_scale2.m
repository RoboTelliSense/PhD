%output will go from min_desired to max_desired  

function Y = UTIL_scale2(X, min_desired, max_desired)

    range_input         =   max(X) - min(X);
    range_desired       =   max_desired-min_desired;
    scale               =   range_desired/range_input;
    
%make Y start from 0    
    Y                   =   X - min(X);  
    
%scale Y    
    Y                   =   scale*Y;
    
%start Y from min_desired    
    Y                   =   Y + min_desired; 
    