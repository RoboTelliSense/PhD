clear;
clc;
close all;

dir1     =  'results_1___Dudek___________Nw_0004_w_0_Np_0600__iPCA_016__bPCA_016__RVQ__08_02_1000__TSVQ_03\';

fn_rvq                      =  'FPerr_3_rvq.csv';
ref_rvq                     =   csvread(['results_thesis\' dir1 fn_rvq]);
rvq                         =   csvread([dir1 fn_rvq]);
[numFrames, cols]           =   size(rvq)
                                ref_rvq(1:numFrames, :) - rvq

fn_ipca                     =  'FPerr_3_ipca.csv';
ref_ipca                    =   csvread(['results_thesis\' dir1 fn_ipca]);
ipca                        =   csvread([dir1 fn_ipca]);
[numFrames, cols]           =   size(ipca)
                                ref_ipca(1:numFrames, :) - ipca
                                
fn_bpca                     =  'FPerr_3_bpca.csv';
ref_bpca                    =   csvread(['results_thesis\' dir1 fn_bpca]);
bpca                        =   csvread([dir1 fn_bpca]);
[numFrames, cols]           =   size(bpca)
                                ref_bpca(1:numFrames, :) - bpca      
                                
fn_tsvq                     =  'FPerr_3_tsvq.csv';
ref_tsvq                    =   csvread(['results_thesis\' dir1 fn_tsvq]);
tsvq                        =   csvread([dir1 fn_tsvq]);
[numFrames, cols]           =   size(tsvq)
                                ref_tsvq(1:numFrames, :) - tsvq                                  