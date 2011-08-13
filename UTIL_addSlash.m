function dir_out = UTIL_addSlash(dir_in)

    if (ispc)   
        dir_out = [dir_in '\'];
    elseif (isunix) 
        dir_out = [dir_in '/'];
    end
            