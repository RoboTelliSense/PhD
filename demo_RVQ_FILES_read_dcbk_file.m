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
                            =  RVQ_FILES_read_dcbk_file  ('256_codebook.ecbk'); 
    DM2_show(mdl_CB_DxMQ, sh, sw, Q, M, 1);
    
    
    figure;
    [Q, M, sw, sh, mdl_CB_DxMQ, temp1, temp2]  ...   %temp1 and temp2 have green and blue channels (not needed for single channel)
                            =  RVQ_FILES_read_dcbk_file  ('256_codebook.dcbk'); 
    DM2_show(mdl_CB_DxMQ, sh, sw, Q, M, 1);
    
%-------------------------------------
%POST-PROCESSING
%-------------------------------------
    