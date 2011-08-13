close all;
clear;
clc;
inp = [4 6 8 10 20 22 24 26;...
1 3 5 7 30 32 34 36];
x=[ 6 8 22 24   6 8 22 24; ...
    3 5 32 34   3 5 32 34];
[u_x,v_x] = eig(x*x')

y=[ 1 3 1 3   -3 -1 -3 -1; ...
    1 3 1 3   -3 -1 -3 -1];
[u_y,v_y] = eig(y*y')


plot(inp(1,:), inp(2,:), 'g.')
hold on;
plot([7 23],[4 33], 'x')
plot([-2 2],[-2 2], 'rx')
line([0 40*u_x(1,2)], [0 40*u_x(2,2)])
line([0 10*u_y(1,2)], [0 10*u_y(2,2)], 'Color', 'r')


plot(x(1,:), x(2,:), 'o')
plot(y(1,:), y(2,:), 'ro')
axis equal
axis([-10 40 -10 40])

title('')
legend('input', '\phi (stage 1)', '\phi (stage 2)','PC (stage 1)', 'PC (stage 2)', 'input to stage 1', 'input to stage 2', 'Location', 'SouthEast');
grid