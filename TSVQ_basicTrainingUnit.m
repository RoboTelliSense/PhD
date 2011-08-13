function [mu1, mu2, out1, out2] = TSVQ_basicTrainingUnit(DM2)
    j=1;
    k=1;
    
    [D, N]          =   size(DM2);

    if (N == 1) %i.e. singleton
        out1        =   DM2;
        out2        =   DM2;
        mu1         =   DM2;
        mu2         =   DM2;
    else
        DM          =   DM2';
        [idx, mu]   =   kmeans(DM, 2, 'emptyaction', 'singleton'); %the 2 means you want 2 clusters
        mu1         =   mu(1,:);
        mu2         =   mu(2,:);
        mu1         =   mu1';
        mu2         =   mu2';
        
        %bizarre case
        if (  isinf(mu1(1)) || ...  %we're checking only the first element
              isnan(mu1(1)) || ...
              isinf(mu2(1)) || ...
              isnan(mu2(1)) )
            if      (  isinf(mu1(1)) || isnan(mu1(1)) )
                mu1 = mu2;
            elseif  (  isinf(mu2(1)) || isnan(mu2(1)) )
                mu2 = mu1;
            end
            out1 = DM2;
            out2 = DM2;
            
        %normal case (i have used this extensively and it works great.  the
        %bizarre case above comes about, in my extensive experiments, ONLY when
        %input data is repeated.  so the part below is as it is from
        %extensive tesing.
        else
			for i=1:N
				if (idx(i) == 1)
					out1(:,j) = DM2(:,i);
					j=j+1;
				elseif (idx(i)==2)
					out2(:,k) = DM2(:,i);
					k=k+1;
				end
			end
		end
	end
    
    