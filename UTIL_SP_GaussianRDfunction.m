function [R, D] = UTIL_SP_GaussianRDfunction(sigma_squared)

    D1                      =   0:0.001:sigma_squared;
    R1                      =   0.5 * log2(sigma_squared./D1);
    
    D2                      =   sigma_squared:0.001:sigma_squared+1;
    R2                      =   zeros(size(D2));
    
    D                       =   [D1 D2];
    R                       =   [R1 R2];
    