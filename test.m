clear;
clc;
close all;

 
pattern_str     =   'S\w+=(\d+.\d+)';    %the stuff inside () represents a token
test_str        =   'dSNR=30.21';
idx             =   regexp(test_str, pattern_str) %idx=2, since that's the matching index
tkn             =   regexp(test_str, pattern_str, 'tokens');    %double(str2num(char(tkn{1}))) = 30.2100
double(str2num(char(tkn{1})))