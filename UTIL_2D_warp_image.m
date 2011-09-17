%> X_hxw, Y_hxw             :   points obtained using meshgrid

function I_hxw = UTIL_2D_warp_image(I_HxW, X_hxw, Y_hxw)

    I_hxw                   =   interp2(I_HxW, X_hxw, Y_hxw);
    
    I_hxw(find(isnan(I_hxw))) = 0;
