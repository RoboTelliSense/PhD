clear;
clc;
close all;

[R1, D1] = UTIL_SP_GaussianRDfunction(1);
[R2, D2] = UTIL_SP_GaussianRDfunction(2);
plot(D1, R1)
hold on;
plot(D2, R2, 'r')
grid on;

legend('\sigma^2=1', '\sigma^2=2')
xlabel('distortion (D)');
ylabel('rate R(D)');

