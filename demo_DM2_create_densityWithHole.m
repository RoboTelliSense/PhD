clear;
clc;
close all;

%sDM2 = DM2_create_gaussianWithHole(2, 1000, .1, 'uniform'); 
%DM2 = DM2_create_gaussianWithHole(2, 1000, .5, 'Gaussian');
%DM2 = DM2_create_densityWithHole(3, 1000, .3, 'uniform'); 
%DM2 = DM2_create_densityWithHole(3, 1000, 1, 'Gaussian'); 
DM2=randn(3,1000);
x=DM2(1,:);
y=DM2(2,:);
z=DM2(3,:);
%plot(x,y, '.');
plot3(x,y,z, '.');
grid on;
