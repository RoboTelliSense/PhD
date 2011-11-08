    clear;
    clc;
    close all;
    
    figure;
    
    for f=5:5:500
        f
    [Q, M, sw, sh, mdl_CB_DxMQ, temp1, temp2]  ...   %temp1 and temp2 have green and blue channels (not needed for single channel)
                            =  RVQ_FILES_read_codebook_file  (['3_sylv___aRVQ_08_02_1000_0_maxQ__\' num2str(f) '_codebook.dcbk']); 
                            %=  RVQ_FILES_read_codebook_file
                            %(['2_david__aRVQ_08_08_1000_0_monR__\' num2str(f) '_codebook.dcbk']); 
    DM2_show(mdl_CB_DxMQ, sh, sw, Q, M, 1);
    pause(0.5);
    %UTIL_FILE_save2pdf('1_Dudek__aRVQ_08_04_1000_0_RofE__170_codebook.pdf', gcf, 300);
    end