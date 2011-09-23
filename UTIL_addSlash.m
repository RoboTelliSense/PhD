function odir = UTIL_addSlash(dir_in)

    if (ispc)   
        odir = [dir_in '\'];
    elseif (isunix) 
        odir = [dir_in '/'];
    end
            