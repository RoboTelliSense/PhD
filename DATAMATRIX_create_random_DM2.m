%% This file generates a DxN matrix of test data.  

% I call this a design matrix DM2 using Andrew Ng's words.  
% A DM is NxD, DM2 is DxN.
% In DM, every D-dimensional vector is in one column.
% In DM2, every D-dimensional vector is in one row.
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : April 18, 2011
% Date last modified : July 7, 2011
%%

function [DM2,sw,sh] = DATAMATRIX_create_random_DM2()    

    D               		=   11;
    X1              		=   [1 5 3 8 15 16 17 28 29 40 45]; %D dimensional data
    X2              		=   X1+0.5*randn(1,D);
    X3              		=   X1+0.7*randn(1,D);
    X4              		=   X1+0.3*randn(1,D);
    DM              		=   [X1; X2; X3; X4];       %create a total of 4 D-dimensional 
                                                        %data points clustered around X1


    for i=1:5
        X1          		=   X1+10*i;     
        X2          		=   X1+0.1*randn(1,D);       %row vector
        X3          		=   X1+0.2*randn(1,D);
        X4          		=   X1+0.3*randn(1,D);
        DM          		=   [DM; X1; X2; X3; X4];   %4 data points centered around X1
                                                        %4 data points centered around X1+50, 
                                                        %4 data points centered around X1+150, 
                                                        %4 data points centered around X1+300, 
                                                        %4 data points centered around X1+500,
                                                        %4 data points centered around X1+750 
                                                        %24 total points
    end

    DM2             		=   DM';
    sw                      =   1;                      %we're saying the snippet width is 1
    sh              		=   D;                      %snippet height is D, so this is a 1D snippet
                                                        %rather than say an image