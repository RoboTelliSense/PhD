%% This file shows how to use RVQ training using a .sml file 
%
% I like to rename the .sml file to 
% 
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : April 20, 2011
% Date last modified : July 19, 2011.
%%
%-------------------------------
% INITIALIZATIONS
%-------------------------------
    clear;
    clc;
    close all;

%-------------------------------
% PRE-PROCESSING
%-------------------------------
    UTIL_FILE_delete('referenceRVQ\F1.ecbk');
    UTIL_FILE_delete('referenceRVQ\F1.dcbk');
    
%-------------------------------
% PROCESSING
%-------------------------------
    system(['RVQ__training_gen8.exe referenceRVQ\F1.sml referenceRVQ\F1.ecbk referenceRVQ\F1.dcbk 3 -S1000 -i0.0005 -j0.0005']);
    
%-------------------------------
% POST-PROCESSING
%-------------------------------
% read codebook
    [actualP, M_check, sw_check, sh_check, mdl_3_EC_DxMQ, mdl_CBg_DxMP, mdl_CBb_DxMP, CBn_r, CBn_g, CBn_b]  ...
                            =  RVQ_FILES_read_codebook_file  ('referenceRVQ\F1.ecbk'); 
    
%display codebook                        
    DM2_show(mdl_3_EC_DxMQ, 41, 11, actualP, M_check); %the snippets are wxh=11x41