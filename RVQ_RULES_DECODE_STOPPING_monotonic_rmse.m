%> @file     RVQ_RULES_DECODE_STOPPING_monotonic_rmse.m
%> @brief    This function tests to see if a test XDR monotonically decreases rmse
%> 
%> ======================================================================
%>
%> Copyright (C) Salman Aslam.  All rights reserved.
%> Date created       : July 29, 2011.
%> Date last modified : Sep 21, 2011.

function continue_decoding = RVQ_RULES_DECODE_STOPPING_monotonic_rmse(rmse, rmse_prev)
    
    if (abs(rmse) < abs(rmse_prev))
        continue_decoding   =   true;
    else
        continue_decoding   =   false;
    end
    
