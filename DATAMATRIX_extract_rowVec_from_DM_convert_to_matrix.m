function I = DATAMATRIX_extract_rowVec_from_DM_convert_to_matrix(I_vec, ih, iw)
    
    I   =   reshape(I_vec, iw, ih);  %picks up widths but stacks them along columns, so need to transpose
    I   =   I';