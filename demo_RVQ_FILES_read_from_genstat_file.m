%% This program demonstrates how to read decoder SNR values from gen.exe's chatter file.
% 
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : April 10, 2011
% Date last modified : July 20, 2011
%%

%-------------------------------------
%INITIALIZATIONS
%-------------------------------------
    clear;
    clc;
    close all;
    
%-------------------------------------
%PROCESSING
%-------------------------------------
    out1          =   RVQ_FILES_read_from_genstat_file('temp/4_95_verbose.txt', 2);
    out2          =   RVQ_FILES_read_from_genstat_file('temp/4_95_verbose.txt', 4);
    out3          =   RVQ_FILES_read_from_genstat_file('temp/14_95_verbose.txt', 2);
    out4          =   RVQ_FILES_read_from_genstat_file('temp/14_95_verbose.txt', 4);
    plot(out1(:,2), 'ro-');%set(gca, 'XTickLabel', num2cell(num2str(out1(:,1))));
    hold on;
    plot(out2(:,2), 'bo-');
    plot(out3(:,2), 'mo-');
    plot(out4(:,2), 'ko-');
    
    load Exp1
    plot(22,rmse_tst(3,2), 'rx')    %q=4 (4th stage, i write 3 since m starts with 2), and the 2 means use RofE
    plot(22,rmse_tst(13,2), 'mo')    %q=4 (4th stage, i write 13 since m starts with 2), and the 2 means use RofE

    legend('m=4, dRMSE', 'm=4, eRMSE', 'm=14, dRMSE', 'm=14, eRMSE', 'Location', 'Southwest', 'm=4, dRMSE', 'm=14, dRMSE');
    grid on;
    grid on;axis([1 25 0 7]);
    
    
    
    