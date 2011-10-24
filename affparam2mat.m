function q = affparam2mat(p)
% function q = affparam2mat(p)
%
% The functions affparam2geom and affparam2mat convert a 'geometric'
% affine parameter to/from a matrix form (2x3 matrix).
% 
% affparam2geom converts a 2x3 matrix to 6 affine parameters
% (x, y, th, scale, aspect, skew), and affparam2mat does the inverse.
%
%    p(6,n) : [dx dy sc th sr phi]'
%    q(6,n) : [q(1) q(3) q(4); q(2) q(5) q(6)]
%
% Reference "Multiple View Geometry in Computer Vision" by Richard
% Hartley and Andrew Zisserman. 

% Copyright (C) Jongwoo Lim and David Ross.  All rights reserved.


sz = size(p);
if (length(p(:)) == 6)
  p = p(:);
end
s = p(3,:);  th = p(4,:);  r = p(5,:);  phi = p(6,:);
cth = cos(th);  
sth = sin(th);  
cph = cos(phi);  
sph = sin(phi);
ccc = cth.*cph.*cph;  ccs = cth.*cph.*sph;  css = cth.*sph.*sph;
scc = sth.*cph.*cph;  scs = sth.*cph.*sph;  sss = sth.*sph.*sph;

%a = css - scs;
%b = ccc + scs;
%c = ccs + sss;
%d = ccs - scc;


%q(3,:) = s.*(r.*a + b);    %a_{11}
%q(4,:) = s.*(r.*d - c);    %a_{12}
%q(5,:) = s.*(r.*c - d );   %a_{21}
%q(6,:) = s.*(r.*b + a);    %a_{22}


q(1,:) = p(1,:);  
q(2,:) = p(2,:);

q(3,:) = s.*(ccc +scs +r.*(css -scs));  %a_{11}
q(4,:) = s.*(r.*(ccs -scc) -ccs -sss);  %a_{12}

q(5,:) = s.*(scc -ccs +r.*(ccs +sss));  %a_{21}
q(6,:) = s.*(r.*(ccc +scs) -scs +css);  %a_{22}

q = reshape(q, sz);