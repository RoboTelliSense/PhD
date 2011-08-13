function prob2 = RVQ_3_testSoC2(prior, condP, b, T, logprob, M)        
        %get probability for b(1)
            t=1;
            prob(t) =    log10(prior( b(t)));
            prob2=prob(1);
    
    
        %get probability for rest of elements in test SoC vector, b
            for t=2:T
                if (b(t)<M+1)
                    prob(t) =   log10 (condP( b(t), b(t-1), t-1));
                    
                else
                    prob(t) =   -10;
                end
                prob2   =   prob2 + prob(t);
            end