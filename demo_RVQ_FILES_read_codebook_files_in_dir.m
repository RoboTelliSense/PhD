    figure;
    [Q, M, sw, sh, mdl_CB_DxMQ, temp1, temp2]  ...   %temp1 and temp2 have green and blue channels (not needed for single channel)
                            =  RVQ_FILES_read_codebook_file  ('F:\salman\phd\1_Dudek__aRVQ_08_04_1000_0_RofE__\170_codebook.dcbk'); 
    DM2_show(mdl_CB_DxMQ, sh, sw, Q, M, 1);
    UTIL_FILE_save2pdf('1_Dudek__aRVQ_08_04_1000_0_RofE__170_codebook.pdf', gcf, 300);
