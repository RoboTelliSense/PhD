function I_out = UTIL_create_3ch_if_1ch(I_in)

    sz  = size(I_in);

    ih   =   sz(1);
    iw   =   sz(2);

%pick itive channels    
    if (length(sz)==3)              %RGB image
        I_out = I_in;
    elseif (length(sz)==2)          %gray scale image
        I_out(:,:,1)    =   I_in;
        I_out(:,:,2)    =   I_in;
        I_out(:,:,3)    =   I_in;
    end
            
