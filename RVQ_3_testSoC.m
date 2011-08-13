%b is test SoC
%-------------------------------------------------------------------------
%
%-------------------------------------------------------------------------
function prob2 = RVQ_test_SoC(prior, condP, b, T, logprob)
    
        %get probability for b(1)
            t=1;
            if (logprob)
                prob(t) =    log10(prior( b(t)));
            else
                prob(t) =    prior( b(t));
            end
            prob2=prob(1);
    
    
        %get probability for rest of elements in test SoC vector, b
            for t=2:T
                if (logprob)
                    prob(t) =   log10 (condP( b(t), b(t-1), t-1));
                    prob2   =   prob2 + prob(t);
                    
                else
                    prob(t) =    condP( b(t), b(t-1), t-1);
                    prob2   =   prob2*prob(t);
                end            
            end