%% This function computes the SNR of a signal in R^2.
%
% Sig_2xN                   :   signal vector in R^2, N data points

% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : Sep 19, 2011
% Date last modified : Sep 19, 2011
%%

function SNRdB = UTIL_METRICS_compute_SNRdB2(Sig_2xN, err_2xN)
    
%square (power signal)
    Sig_1xN                 =   Sig_2xN(1,:).^2 + Sig_2xN(2,:).^2;  %add 1 first row (dimension) squared to 2nd row (dimension) squared
    err_1xN                 =   err_2xN(1,:).^2 + err_2xN(2,:).^2;  %add 1 first row (dimension) squared to 2nd row (dimension) squared
    
%mean (power, or avg energy)
    mu_Sig_1x1              =   mean(Sig_1xN);  %power (Sig_1xN.^2 / N, where Sig_1xN.^2 is energy)
    mu_err_1x1              =   mean(err_1xN);  %power
    
%root
    SNRdB                   =   10*log10(mu_Sig_1x1/mu_err_1x1);