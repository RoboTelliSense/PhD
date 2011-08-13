function I_out = UTIL_IP_image_to_rowWiseVectorized(I)

    I_transposed    =   I';
    I_out           =   I_transposed(:);    %entire image is vectorized row wise, and lies in a single column
    I_out           =   I_out';             %now, output is a single row