function MT_SIG_create2Dgaussian(x, y)

    mux                     =   mean(x);
    muy                     =   mean(y);
    [X,Y]                   =   meshgrid(x,y);
    S                       =   [1.0 0;0 1.0]; %covariance matrix
    detS                    =   det(S)
    g1                      =   1/(2*pi*detS)*exp(-(X.^2)/10);
    g2                      =   1/(2*pi*detS)*exp(-(Y.^2)/10);
    z                       =   g1.*g2;
    zn                      =   z+ 0.001*randn(size(z));
    surf(x,y,-zn)


