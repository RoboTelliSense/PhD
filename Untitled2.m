clear;
clc;
close all;

% a=textread('F:\Dropbox\results\1_Dudek__aBPCA_008__.txt');
% b=textread('F:\Dropbox\results\1_Dudek__aRVQ_08_12_1000_0_nulE__.txt');
% plot(6:570,a(:,6), 'r+--')
% hold on;
% plot(6:570,b(:,6), 'g+--')

k=1024; %Power of 2
t=linspace(0,1,k+1);
x=sin(2*pi*t);

j=round((k-1)/2)+1;
I=find(mod((find(t==t)-1),128)==0); %Power of 2 subset

close all
figure(1)
hold on
plot(t(j),x(j),'b-o')
plot(t,x,'b')
plot(t(I),x(I),'bo')
legend('Just What I Want');
%%%%%%%%%%%%%%%%
% End Snippet %
%%%%%%%%%%%%%%%%
