%> @file     RVQ_RULES_DECODE_STOPPING_RoE.m
%> @brief    This function tests to see if a test XDR is in the realm of experience
%>           set, i.e., is it part of the training set XDR's
%> 
%> ======================================================================
%> 
%> tst_XDR_parPx1: normally, you would have tst_1_featr_PxN, the P showing full
%> stages.  Here, I have parPx1, the parP showing partial stages.
%>
%> Copyright (C) Salman Aslam.  All rights reserved.
%> Date created       : July 29, 2011.
%> Date last modified : July 29, 2011.

function continue_decoding = RVQ_RULES_DECODE_STOPPING_realm_of_experience(featr_PxN, tst_XDR_parPx1)
    
    [P, N]                  =   size(featr_PxN);
    parP                    =   length(tst_XDR_parPx1);
    continue_decoding       =   false;
    
    for n=1:N  %go over all training XDRs
        trg_XDR_parPx1      =   featr_PxN(1:parP, n);
        if (sum(tst_XDR_parPx1 - trg_XDR_parPx1)==0)
            continue_decoding   ...
                            =   true;
            break;
        end
    end