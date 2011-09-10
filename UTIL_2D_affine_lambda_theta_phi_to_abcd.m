%> @file UTIL_2D_affine_lambda_theta_phi_to_abcd.m
%> @brief 
%> 
%> affine1_6x1 : [a      b        c        d     tx   ty]
%> affine2_6x1 : [theta  lambda1  lambda2  phi   tx   ty]
%> 
%> Reference "Multiple View Geometry in Computer Vision" by Richard
%> Hartley and Andrew Zisserman and Jongwoo Lim and David Ross. 
%>
%> Copyright (c) Salman Aslam.  All rights reserved.
%> Date created             :   around Jan 2011
%> Date modified            :   Sep 10, 2011

function abcdtxty = UTIL_2D_affine_lambda_theta_phi_to_abcd(lltptxty) %lltptxty: lambda1, lambda2, theta, phi, tx, ty
    
    %input (read lltptxty)
    theta                   =   lltptxty(1,:);  
    lambda1                 =   lltptxty(2,:);  
    lambda2                 =   lltptxty(3,:);  
    phi                     =   lltptxty(4,:);
    tx                      =   lltptxty(5,:);           
    ty                      =   lltptxty(6,:);               

    %intermediate
    cos_the                 =   cos(theta);  
    sin_the                 =   sin(theta);  
    cos_phi                 =   cos(phi);  
    sin_phi                 =   sin(phi);
    
    ccc                     =   cos_the*cos_phi*cos_phi;  
    ccs                     =   cos_the*cos_phi*sin_phi;  
    css                     =   cos_the*sin_phi*sin_phi;
    scc                     =   sin_the*cos_phi*cos_phi;  
    scs                     =   sin_the*cos_phi*sin_phi;  
    sss                     =   sin_the*sin_phi*sin_phi;

    p                       =   css - scs;
    q                       =   ccc + scs;
    r                       =   ccs + sss;
    s                       =   ccs - scc;

    %output (create abcdtxty)
    a                       =   lambda2*p + lambda1*q;      
    b                       =   lambda2*s - lambda1*r;
    c                       =   lambda2*r - lambda1*s;
    d                       =   lambda2*q + lambda1*p;
    
    abcdtxty                =   [a b c d tx ty];