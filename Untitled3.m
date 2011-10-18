clear;
clc;
close all;

t=0:1:570;
x=0.2*sin(t);
y=0.2*cos(t);

plot(t,x, 'b')
hold on;
plot(t,y, 'r')

plot(t(I),x(I),'bo')


legend('hi', 'bye');


%             plot(6:570,rvq(:,9), 'r')  %5: instantaneous tracking error, 6: average tracking error
%             I=UTIL_sampled_vals(6:570);
%             plot(I, rvq(I,9), 'ro')
            