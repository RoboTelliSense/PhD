%% This function creates simple test data and demonstrates particle filter
%% resampling
%
% Copyright (C) Salman Aslam
% Date created       : June 26, 2011
% Date last modified : July 14, 2011
%%
clear;
clc;
close all;

%--------------------------
%INITIALIZATIONS
%--------------------------
    pdf_ref_1xNp            =   [0.1     0.13    0.11    0.11    0.1     0.09    0.14    0.07    0.07    0.08];
    cdf_ref_1xNp            =   [0.10    0.23    0.34    0.45    0.55    0.64    0.78    0.85    0.92    1.00]; %or use cdf_ref_1xNp=cumsum(pdf_ref_1xNp)
    
    pdf_data_Npx1           =   [0.02    0       0       0.38    0.02    0       0.18    0.01    0.39    0];
    cdf_data_Npx1           =   [0.02    0.02    0.02    0.40    0.42    0.42    0.60    0.61    1.00    1.00];
                            %     1       2       3       4       5       6       7       8       9       10                           
                            %very strong?                yes                     yes             yes
                             

%--------------------------
%PROCESSING
%--------------------------
    [idx, resampled_density_Npx1] ...
                            =   TRK_particle_filter_resampling(cdf_ref_1xNp, cdf_data_Npx1', pdf_data_Npx1);
    
%--------------------------
%POST-PROCESSING
%--------------------------
    
%plots
    h                       =   figure(1);
                                clf;
                                stem(pdf_ref_1xNp, 'r')
                                hold on;
                                stem(pdf_data_Npx1, '.')
                                grid on;
                                axis([1 10 0 0.4])
                                legend('ref pdf', 'test pdf', 'Location', 'NorthWest') 
                                UTIL_FILE_save2pdf('particle_filter_pdfs.pdf', h, 300);
      
                                h=figure(2);
                                clf;
                                plot(cdf_ref_1xNp, 'r')
                                hold on;
                                plot(cdf_data_Npx1)
                                grid on;
                                UTIL_FILE_save2pdf('particle_filter_cdfs.pdf', h, 300);

                                h=figure(3);
                                clf;
                                stem(idx);
                                grid on;
                                UTIL_FILE_save2pdf('particle_filter_particles.pdf', h, 300);
                                
                                h=figure(4);
                                clf;
                                stem(resampled_density_Npx1, '.');
                                grid on;
                                axis([1 10 0 0.4])
                                UTIL_FILE_save2pdf('particle_filter_resampled_density.pdf', h, 300);                                
                                