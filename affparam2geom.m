function q = affparam2geom(p)
% function q = affparam2geom(p)
%
% The functions affparam2geom and affparam2mat convert a 'geometric'
% affine parameter to/from a matrix form (2x3 matrix).
% 
% affparam2geom converts a 2x3 matrix to 6 affine parameters
% (x, y, th, scale, aspect, skew), and affparam2mat does the inverse.
%
%    p(6) : [p(1) p(3) p(4); p(2) p(5) p(6)]
%    q(6) : [dx dy sc th sr phi]
%
% Reference "Multiple View Geometry in Computer Vision" by Richard
% Hartley and Andrew Zisserman. 

% Copyright (C) Jongwoo Lim and David Ross.  All rights reserved.

A = [ p(3), p(4); p(5), p(6) ];
%%  A = USVt = (UVt)(VSVt) = R(th)R(-phi)SR(phi)
[U,S,V] = svd(A);
if (det(U) < 0)             %you want the determinant to be positive so that there's no reflection, just rotation
  U = U(:,2:-1:1);          %switch columns, this changes the parity of the determinant
  V = V(:,2:-1:1);          %same thing
  S = S(2:-1:1,2:-1:1);     %interchange eigenvalues
end

%dx, dy
%------
    q(1) = p(1);  
    q(2) = p(2);
    
%theta
%-----
    q(4) = atan2(U(2,1)*V(1,1)+U(2,2)*V(1,2), U(1,1)*V(1,1)+U(1,2)*V(1,2));

%phi
%---
    phi = atan2(V(1,2),V(1,1));
    
if (phi <= -pi/2) %3rd quadrant
  c = cos(-pi/2); s = sin(-pi/2);
  R = [c -s; s c];  V = V * R;  S = R'*S*R;
end
if (phi >= pi/2) %2nd quadrant
  c = cos(pi/2); s = sin(pi/2);
  R = [c -s; s c];  V = V * R;  S = R'*S*R;
end
q(3) = S(1,1); %sr
q(5) = S(2,2)/S(1,1); %sc
q(6) = atan2(V(1,2),V(1,1)); %phi
q = reshape(q, size(p));