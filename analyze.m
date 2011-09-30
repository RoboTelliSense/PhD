clear;
clc;
close all;

%PCA
PARAM.in_pca__Q         =   16;         %PCA: number of eigenvectors to retain for PCA

%RVQ
PARAM.in_rvq__maxQ      =   8;                              %aRVQx: max stages
PARAM.in_rvq__M         =   2;                              %aRVQx: templates per stage
PARAM.in_rvq__targetSNRdB=  1000;                           %aRVQx: target SNR
PARAM.in_rvq__tstD      =   RVQ__testing_rule_string(3);    %convert test data's decoding rule from index to string

%TSVQ
PARAM.in_tsvq_maxQ      =   2;                              %aTSVQ: max stages
PARAM.in_tsvq_M         =   2;                              %aTSVQ: templates per stage, 2 for binary aTSVQ

%dataset
PARAM.in_ds_code        =   1;                              %dataset code
PARAM                   =   UTIL_DATASET_getName3(PARAM);
  

%[a b]=textread('test.txt')