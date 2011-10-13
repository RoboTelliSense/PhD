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
    [out1_allvals out1]          =   RVQ_FILES_read_from_genstat_file('4_95_verbose.txt', 1); %2 is for eRMSE
    [out2_allvals out2]          =   RVQ_FILES_read_from_genstat_file('4_95_verbose.txt', 3); %4 is for dRMSE
    plot(out1(:,1), out1(:,2), 'ro-');%set(gca, 'XTickLabel', num2cell(num2str(out1_allvals(:,1))));
    hold on;
    plot(out2(:,1), out2(:,2), 'b*-');
    grid on;
    legend('trg (eRMSE)', 'trg (dRMSE)', 'Location', 'Best');
    xlabel('stage #');
    ylabel('rms error');
   

    
    
    