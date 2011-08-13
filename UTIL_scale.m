%output starts from 0 and goes to desired_scale    
function Y = UTIL_scale(X, desired_scale, maxval, minval)

        rang                =   maxval-minval;
        scale               =   desired_scale/rang;
        bias                =   minval*scale;
        
        Y                   =   X*scale - bias; 
        
          
        