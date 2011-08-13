%% This function reads and displays Explorer generated .stg file which has number
%% of stages information for every pixel. 
% 
% Iw: image width
% Ih: image height
% IiN: total inner number of pixels
% Iiw: image inner width
% Iih: image inner height
%
% - this file contains the number of stages for reconstruction under the monotonic PSNR increase condition.
% - as such, it should be populated by numbers that go from 1 to P, where P is the total number of stages.
% - however, this file also has values of P+1, what are these?
% - certainly, it cannot mean early termination, since then a value less than P should be used.  so, P+1 does not mean early termination.  so, a value of P should be used since there is no early termination.  here is when P is used and when P+1 is used.
% - P: full stages used and target SNR achieved
% - P+1: full stages used and target SNR not achieved.
% - for a target SNR of 1000 dB, which is almost impossible to achieve, chances are you will not have any P's.  Instead all P's will be P+1s.
%    
% this function gives number of stages in range of 1 to P
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : February 4, 2011
% Date last modified : July 20, 2011
%%
function STG = RVQ_FILES_read_stg_file(stg_filename, Iw, Ih, sw, sh, P)
        
        [IiN, Iiw, Iih] = RVQ_UTIL_computeInnerPixels(Iw, Ih, sw, sh);    
        
        fid             =   fopen(stg_filename);
        STG             =   uint8(fread(fid, double(IiN)));  
        status          =   fclose(fid);
        
        STG             =   reshape(STG, Iiw, Iih);
        STG             =   STG';
        
 
        %h_hist1         =   figure;                             
        %hist(double(STG(:)), [1:P+1])    
        for r = 1:Iih              
           for c = 1:Iiw                %P:   full P stages used, and target SNR achieved
               if (STG(r,c)==P+1)       %P+1: full P stages used, and target SNR not achieved
                   STG(r,c)=P;          %P and P+1 therefore both represent P stages used, the only difference is whether target SNR was achieved or not
               end                      %since I'm not interested in whether target SNR was achieved (and it probably never will since I normally use targetSNR=1000), I    
           end                          %will replace P+1 with P
        end                             %practically, in my files, there are 0 pixels with value P, and all values that have full stages are P+1
        %figure;imagesc(STG);colorbar;
        