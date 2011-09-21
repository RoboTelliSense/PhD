%% This function computes the rms energy of a signal.
%
% Sig_Dx1: signal vector

% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : March 17, 2011
% Date last modified : July 7, 2011
%%

function rms_value = UTIL_METRICS_compute_rms(Sig_Dx1)

    rms_value               =   sqrt( UTIL_METRICS_compute_power(Sig_Dx1) );
    