%% This program shows how to read and display gen.exe generated .dcbk file which has
%% the decoder codebook
% 
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : July 20, 2011
% Date last modified : July 20, 2011
%%

%-------------------------------------
%INITIALIZATIONS
%-------------------------------------
    clear;
    clc;
    close all;

%-------------------------------------
%PROCESSING
%-------------------------------------
    figure;
    [Q, M, sw, sh, mdl_CB_DxMQ, temp1, temp2]  ...   %temp1 and temp2 have green and blue channels (not needed for single channel)
                            =  RVQ_FILES_read_codebook_file  ('F:\salman\phd\1_Dudek__aRVQ_08_04_1000_0_RofE__\170_codebook.dcbk'); 
    DM2_show(mdl_CB_DxMQ, sh, sw, Q, M, 1);
    UTIL_FILE_save2pdf('1_Dudek__aRVQ_08_04_1000_0_RofE__170_codebook.pdf', gcf, 300);
    
%     figure;
%     [Q, M, sw, sh, mdl_CB_DxMQ, temp1, temp2]  ...   %temp1 and temp2 have green and blue channels (not needed for single channel)
%                             =  RVQ_FILES_read_codebook_file  ('256_codebook.dcbk'); 
%     DM2_show(mdl_CB_DxMQ, sh, sw, Q, M, 1);
    
%-------------------------------------
%POST-PROCESSING
%-------------------------------------
    