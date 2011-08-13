%% This function computes number of non-terminal (stage) and terminal
%% codevectors in TSVQ
%
% Ks    :   Ks = (M^P-1)/(M-1), number of stage (non-terminal) codevectors.
%           For binary TSVQ, M=2, so Ks=this is M^P-1=K-1
% K     :   number of terminal codevectors
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : April 20, 2011
% Date last modified : July 19, 2011.
%%
function [Ks, K] = TSVQ_find_Ks_and_K(M, P)

    Ks                      =   (M^P-1)/(M-1); 
    K                       =   M^P;                 