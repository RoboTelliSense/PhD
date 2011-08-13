function B_ll = RVQ_3_getLogLikelihoods(p1, pn, B, M, T, Iih, Iiw, outdir, f_zeropref)
        %analyse SoCs (get log likelihood)
        %------------
            logprob = true;    
            i=1;
            for y=1:Iih
                y;
                for x=1:Iiw        
                    %B_ll(y,x)                           =   RVQ_3_testSoC(p1,    pn,    B(i,:), T, logprob); 
                    B_ll(y,x)                           =   RVQ_3_testSoC2(p1,    pn,    B(i,:), T, logprob, M); 
                    i                                   =   i+1;
                end
            end
            dlmwrite([outdir f_zeropref '_12.ll'], B_ll);
            
            %ll=dlmread('PETS2001_8\00472_12.ll');
            %figure;
            %imagesc(ll);

            %(c) filter
            %B_ll_filt   =   filter2(h,B_ll)/sum(sum(h));



