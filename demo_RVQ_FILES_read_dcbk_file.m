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
    [actualP, M_check, sw_check, sh_check, CB_r, CB_g, CB_b, CBn_r, CBn_g, CBn_b]  ...
                            =  RVQ_FILES_read_dcbk_file  ('referenceRVQ\F1.dcbk'); 
%-------------------------------------
%POST-PROCESSING
%-------------------------------------
    DATAMATRIX_display_DM2_as_image(CB_r, 41, 11, actualP, M_check); %the snippets are wxh=11x41