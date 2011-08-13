%% This function computes the total energy of an input signal.
%
% Sig_Dx1: signal vector
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : April 15, 2011
% Date last modified : July 7, 2011
%%
function energy = UTIL_METRICS_compute_energy(Sig_Dx1)

    energy                  =	sum (  UTIL_METRICS_compute_powerSignal(Sig_Dx1) );
   
    
    
    