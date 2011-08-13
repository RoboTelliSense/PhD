%% This function computes the PSNR of an input signal.
%
% Err_Dx1: error (noise) vector
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : March 20, 2011
% Date last modified : July 7, 2011
%%
function psnr_dB = UTIL_METRICS_compute_PSNRdB(max_signal_value, Err_Dx1)
	
    power_noise             =   UTIL_METRICS_compute_power(Err_Dx1);
    psnr_dB                 =   10*log10(max_signal_value^2 / power_noise);	