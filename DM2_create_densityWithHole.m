function    DM2             =   DM2_create_densityWithHole(D, N, limits, code) 

%     DM2_temp                =   randn(D,N);
%     idx                     =   0;
%     DM2                     =   [];
%     for n=1:N
%         numGreater          =   sum(  abs( DM2_temp(:,n))  > limits     );
%         if  (numGreater==D)
%             idx             =   idx+1;
%             DM2(:,idx)      =   DM2_temp(:,n);
%         end
%     end

    if      (strcmp(code, 'uniform'))   DM2_temp =   rand  (D,N)-repmat(0.5*ones(D,1), 1, N);
    elseif  (strcmp(code, 'Gaussian'))  DM2_temp =   randn (D,N);
    end
    
    DM2                     =   [];
    idx                     =   0;
    
    for n=1:N
        if (UTIL_METRICS_compute_rms(DM2_temp(:,n)) > limits)
            idx             =   idx+1;
            DM2(:,idx)      =   DM2_temp(:,n);
        end
    end
    