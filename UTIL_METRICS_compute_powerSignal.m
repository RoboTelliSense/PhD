%% This function computes the power signal of an input signal.
%
% Sig_Dx1: signal vector
% Pow_Dx1: power vector (normalized since we assume resistance R=1)

% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : April 15, 2011
% Date last modified : July 7, 2011
%%

function Pow_Dx1 =   UTIL_METRICS_compute_powerSignal(Sig_Dx1)

    Pow_Dx1                 =   Sig_Dx1.^2;