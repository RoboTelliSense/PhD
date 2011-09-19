%% This function computes the power of a signal.
%
% Sig_Dx1: signal vector

% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : March 17, 2011
% Date last modified : July 7, 2011
%%
function power_1x1 = UTIL_METRICS_compute_power(Sig_Dx1)

    power_1x1                   =   UTIL_METRICS_compute_energy(Sig_Dx1) / length(Sig_Dx1);    %norm(s,2) is the same as sqrt(sum(s.^2)), or square root of energy
    
    
