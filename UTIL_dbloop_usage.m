clear;
clc;
close all;

mmax = 5;
      for n=1:500
          % With no input arguments, this command will allow you
          %   enter debug mode when a "k" is pressed
          UTIL_dbloop
          disp(sprintf('Loop ran %u times.',n))
          % This command will allow you to enter debug 
          %   mode when a "1" is pressed
          UTIL_dbloop 1
          disp(sprintf('Like I said, the loop ran %u times.',n))
          for m=1:mmax
              % Alternatively, this command will allow you to  
              %   enter debug mode when a "2" is pressed
              UTIL_dbloop 2
              disp(sprintf('This second loop ran %u of %u times',m,mmax))
          end
      end
      dbloop close