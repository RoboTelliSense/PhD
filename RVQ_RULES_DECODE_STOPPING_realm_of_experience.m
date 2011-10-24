%> @file     RVQ_RULES_DECODE_STOPPING_RoE.m
%> @brief    This function tests to see if a test XDR is in the realm of experience
%>           set, i.e., is it part of the training set XDR's
%> 
%> ======================================================================
%> 
%> tst_XDR_parQx1: normally, you would have tst_1_featr_QxN, the Q showing full
%> stages.  Here, I have parQx1, the parQ showing partial stages.
%>
%> for training data, this produces the same result as maxQ
%>
%> Copyright (C) Salman Aslam.  All rights reserved.
%> Date created       : July 29, 2011.
%> Date last modified : July 29, 2011.

function continue_decoding = RVQ_RULES_DECODE_STOPPING_realm_of_experience(featr_QxN, tst_XDR_parQx1, q)
    
    [P, N]                  =   size(featr_QxN);
    parQ                    =   length(tst_XDR_parQx1);
    continue_decoding       =   false;
    
    for n=1:N  %go over all training XDRs
        trg_XDR_parQx1      =   featr_QxN(1:parQ, n);
        if (sum(tst_XDR_parQx1 - trg_XDR_parQx1)==0)
            continue_decoding   ...
                            =   true;
            break;
        end
    end
    
    if (continue_decoding  ==   false && q==1) %if first stage, then RofE may not work if M is large, take care of that here
        continue_decoding = true;
    end
    