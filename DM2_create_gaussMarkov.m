function DM2_create_gaussMarkov(D,N,rho)

%---------------------------------------    
%PRE-PROCESSING    
%---------------------------------------
    a                       =   zeros(D,N);
    w                       =   randn(D,N);
    a(:,1)                  =   zeros(D,1);


%---------------------------------------    
%PROCESSING    
%---------------------------------------
    for n=2:N
        a(:,n)              =   rho*a(:,n-1) + w(:,n); %rho is the correlation between samples
        a(:,n)              =   a(:,n)/sqrt(var(a(:,n)));
    end

%---------------------------------------    
%POST-PROCESSING    
%---------------------------------------
%     for n=2:N
%         plot(a(:,n));
%         hold on;
%     end
    
    