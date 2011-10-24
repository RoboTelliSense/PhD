%> @file     RVQ_RULES_DECODE_STOPPING_monPSNR.m
%> @brief    This function tests to see if a test XDR is in the realm of experience
%>           set, i.e., is it part of the training set XDR's
%> 
%> ======================================================================
%>
%> Copyright (C) Salman Aslam.  All rights reserved.
%> Date created       : July 29, 2011.
%> Date last modified : July 29, 2011.

function continue_decoding = RVQ_RULES_DECODE_STOPPING_monotonic_PSNR(PSNR_dB, PSNRdB_prev)
    
    if (PSNR_dB > PSNRdB_prev)
        continue_decoding   =   true;
    else
        continue_decoding   =   false;
    end
    
