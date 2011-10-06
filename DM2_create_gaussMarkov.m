%creates 0 mean, unit variance, Gauss Markov process
function DM2_create_gaussMarkov(D,N,rho)

%---------------------------------------    
%PRE-PROCESSING    
%---------------------------------------
    DM2                     =   zeros(D,N);
    w                       =   randn(D,N);
    DM2(:,1)                =   zeros(D,1);


%---------------------------------------    
%PROCESSING    
%---------------------------------------
    for n=2:N
        DM2(:,n)            =   rho*DM2(:,n-1) + w(:,n); %rho is the correlation between samples
        DM2(:,n)            =   DM2(:,n)/sqrt(var(DM2(:,n)));
    end

%---------------------------------------    
%POST-PROCESSING    
%---------------------------------------
%     for n=2:N
%         plot(DM2(:,n));
%         hold on;
%     end
    
    