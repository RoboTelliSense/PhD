%> @file UTIL_2D_affine_tllptxty_to_abcdtxty.m
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

function abcdtxty = UTIL_2D_affine_tllptxty_to_abcdtxty(tllptxty) %tllptxty: lambda1, lambda2, theta, phi, tx, ty
    
    %input (read tllptxty)
    theta                   =   tllptxty(1,:);  
    lambda1                 =   tllptxty(2,:);  
    lambda2                 =   tllptxty(3,:);  
    phi                     =   tllptxty(4,:);
    tx                      =   tllptxty(5,:);           
    ty                      =   tllptxty(6,:);               

    %intermediate
    ccc                     =   cos(theta)*(cos(phi))^2;   %can be made quicker by prestoring trigonometric values
    ccs                     =   cos(theta)*cos(phi)*sin(phi);  
    css                     =   cos(theta)*(sin(phi))^2;
    scc                     =   sin(theta)*(cos(phi))^2;  
    scs                     =   sin(theta)*cos(phi)*sin(phi);  
    sss                     =   sin(theta)*(sin(phi))^2;

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