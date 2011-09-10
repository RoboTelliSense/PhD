%> @file UTIL_2D_affine_abcdtxty_to_tllptxty.m
%>
%> Reference "Multiple View Geometry in Computer Vision" by Richard
%> Hartley and Andrew Zisserman and Jongwoo Lim and David Ross
%>
%> Copyright (c) Salman Aslam.  All rights reserved.  

function tllptxty = UTIL_2D_affine_abcdtxty_to_tllptxty(abcdtxty)

    %input
    a                       =   abcdtxty(1);
    b                       =   abcdtxty(2);
    c                       =   abcdtxty(3);
    d                       =   abcdtxty(4);
    tx                      =   abcdtxty(5);
    ty                      =   abcdtxty(6);  
    
    A                       =   [a b; ...
                                 c d];
                             
    %SVD of A
    [U,S,V]                 =   svd(A);
    
    %check on U, S, V
    if (det(U) < 0)                                     %you want the determinant to be positive so that there's no reflection, just rotation
        U                   =   U(:      , 2:-1:1);     %switch columns, this changes the parity of the determinant
        V                   =   V(:      , 2:-1:1);     %same thing
        S                   =   S(2:-1:1 , 2:-1:1);     %interchange eigenvalues
    end

    %theta
    num                     =   U(2,1)*V(1,1)+U(2,2)*V(1,2);    %numerator
    den                     =   U(1,1)*V(1,1)+U(1,2)*V(1,2);    %denominator
    theta                   =   atan2(num, den);
    
    %phi
    phi                     =   atan2(V(1,2),V(1,1));

    if (phi <= -pi/2) %3rd quadrant    taken from Jongwoo Lim and David Ross
        ang                 =   -pi/2;  %rotate clockwise 
        R                   =   UTIL_2D_make_rotation_matrix(ang);
        V                   =   V * R;  
        S                   =   R'*S*R;  
    end
    if (phi >= pi/2) %2nd quadrant
        ang                 =   pi/2;   %rotate counterclockwise
        R                   =   UTIL_2D_make_rotation_matrix(ang);
        V                   =   V * R;  
        S                   =   R'*S*R;         
    end
    
    phi                     =   atan2(V(1,2),V(1,1));
    
    %lambda1, lambda2
    lambda1                 =   S(1,1); 
    lambda2                 =   S(2,2); 
   
    tllptxty                 =   [theta lambda1 lambda2 phi tx ty];