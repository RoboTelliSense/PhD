%% This function computes the rms energy of a signal in R^2.
%
% Sig_2xN                   :   signal vector in R^2, N data points

% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : Sep 19, 2011
% Date last modified : Sep 19, 2011
%%

function rms_value = UTIL_METRICS_compute_rms2_value(Sig_2xN)
    
%square
    Sig_1xN                 =   Sig_2xN(1,:).^2 + Sig_2xN(2,:).^2;  %add 1 first row (dimension) squared to 2nd row (dimension) squared
    
%mean
    mu_1x1                  =   mean(Sig_1xN);
    
%root
    rms_value               =   sqrt(mu_1x1);