%assumption is that the data is grayscale

function DATAMATRIX_display_DM_as_image(DM, sh, sw, numCols)
    
    [Ntrg, D] = size(DM);  %Ntrg: number of training observations, D: dimensionality of data
    
    for i = 1:Ntrg
        Y_channel_matrix        =   DATAMATRIX_extract_rowVec_from_DM_convert_to_matrix(DM(i,:), sh, sw);
                                    UTIL_PLOT_tightsubplot(numCols, i, Y_channel_matrix)
    end
    
