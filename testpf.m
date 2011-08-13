Np=4
rn1=[0.2 0.4 0.2 0.4]
PFaffineCandidates_2xNp = [1 2 3 4;5 6 7 8]
cumconf                                 =   [0.1;0.3;0.9;1.0];
a                                       =   repmat(rn1,[Np,1]);
b                                       =   repmat(cumconf,[1,Np]);
c                                       =   a > b
d                                       =   sum(c)
e                                       =   floor(d)
idx                                     =   e  +  1
PFaffineCandidates_2xNp_new             =   PFaffineCandidates_2xNp(:,idx);

PFaffineCandidates_2xNp
PFaffineCandidates_2xNp_new