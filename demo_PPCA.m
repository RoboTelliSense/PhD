    clear;
    clc;
    close all;
    
    D                   =   40;                 %dimensionality of data
    N                   =   50;                 %number of data points
    P                   =   5;                  %number of eigenvectors to retain 
    
    DM2                 =   randn(D,N);         %data matrix
    DM2mu               =   mean(DM2, 2);       %mean: max likelihood estimate
    DM2z                =   DM2-repmat(DM2mu,1,N);
    [U_DxD,L_NxN,V_NxN] =   svd(DM2z);          %U_DxD has eigenvectors of S=DM2*DM2'
                                                %L_NxN has eigenvalues of DM2
                                                %V_NxN has eigenvectors of DM2'*DM2
    U_DxQ               =   U_DxD(:,1:P);       %first P eigenvectors of S                                            
    L_PxP               =   L_NxN(1:P, 1:P).^2; %PxP subset of eigenvalues of S (remember eigenvalues of
                                                %S are equal to squared eigenvalues of DM2
    
    %S                   =   cov(DM2', 1);       %data cov matrix    
    lambda              =   diag(L_NxN).^2;     %data cov matrix: eigenvalues
    
    
    
    sigma2              =   1/(D-P)*sum(lambda(P+1:D));%variance: max likelihood estimate
    
    R_PxP               =   orth(randn(P,P));   %arbitrary orthonormal matrix
    
    W_DxP               =   U_DxQ*sqrt(L_PxP - sigma2*eye(P,P))*R_PxP; %