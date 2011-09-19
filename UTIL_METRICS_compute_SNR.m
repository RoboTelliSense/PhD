%% This function computes SNR given a signal and an error signal.
%
% Sig_Dx1: signal vector
% Err_Dx1: error (noise) vector 

% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : March 17, 2011
% Date last modified : July 7, 2011
%%

function SNR = UTIL_METRICS_compute_SNR(Sig_Dx1, Err_Dx1)

%signal
    power_signal_1x1        =   UTIL_METRICS_compute_power (Sig_Dx1); %Sig_Dx1 can also be a row vector

%error
    power_noise_1x1         =   UTIL_METRICS_compute_power (Err_Dx1); %Err_Dx1 can also be a row vector  

%SNR
    SNR                     =   power_signal_1x1 / power_noise_1x1;