clear;
clc;
clf;
hold off;

%plot input data
%---------------
    figure(1)
    x= -5:.1:5;
    y = 10*randn(1,length(x))
    plot(x,y,'o')

    X=-10:.1:10;
    Y = 10*randn(1,length(X))
    for i=1:length(X)
        if (X(i)>=-8 && X(i)<8)
            if (Y(i) <= 0)
                Y(i) = Y(i)-40
            else
                Y(i) = Y(i)+40
            end
        else
        end
    end
    hold on
    h=figure(1);
    plot(X,Y,'ro');
    
    grid
    hold off
    UTIL_FILE_save2pdf('out1.pdf', h, 300);

%plot 3D kernel
%--------------
    x1 = x.^2;
    x2 = sqrt(2)*x.*y;
    x3= y.^2;
    h=figure(2);
    plot3(x3,x2,x1, 'o')
    hold on;

    x1 = X.^2;
    x2 = sqrt(2)*X.*Y;
    x3= Y.^2;
    plot3(x3,x2,x1, 'ro')
    grid
    UTIL_FILE_save2pdf('out2.pdf', h, 300);
    