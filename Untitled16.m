clear;
clc;
close all;

a = randn(1089,5);
mua = mean(a,2);
az = a-repmat(mua,[1,5]);
aat = az*az';

%[v,d]=eig(aat);
%hg  = v(:,1086:1089)
[u1,s1,v1]=svd(az,0);
[u2,s2,v2]=svd(a,0);
whos u1
whos u2