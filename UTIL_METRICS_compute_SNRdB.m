%% This function computes SNR in dB given a signal and an error signal.
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : March 20, 2011
% Date last modified : July 7, 2011
%%

function SNRdB = UTIL_METRICS_compute_SNRdB(Sig_Dx1, Err_Dx1)  %although shown as column vectors, they can be row vectors as well
    
    SNR                     =   UTIL_METRICS_compute_SNR (Sig_Dx1, Err_Dx1);
    SNRdB                   =   10*log10            (SNR);