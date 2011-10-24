clear;
clc;
close all;

%============================================    
% PRE-PROCESSING    
%============================================
%RVQ    
    rvq__maxQ               =   8;
    rvq__M                  =   8;
    rvq__tstI               =   1; %1, 2, 3, or 4    
    rvq__tSNR               =   1000;
    rvq__lmbd               =   0;
    rvq__type               =   'uint8';
    
%PARAM
    ds_code                 =   5;
    [PARAM.ds_2_name, PARAM.ds_3_name] ...
                            =    UTIL_DATASET_getName3(ds_code);
    PARAM.tgt_sw            =   33;
    PARAM.tgt_sh            =   33;
    
%USE RVQ and PARAM    
    [aRVQx trkaRVQx]        =   RVQx_config(PARAM, [], rvq__maxQ, rvq__M, rvq__tSNR, rvq__tstI, rvq__lmbd, rvq__type);    

%============================================    
% PROCESSING    
%============================================
    rvq                     =   textread(['results2\' trkaRVQx.config_str '.txt']);

%============================================    
% POST-PROCESSING    
%============================================    