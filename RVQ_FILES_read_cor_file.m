%% This file reads Explorer generated .cor files.  This file contains NSR values, i.e. 1/SNR
% iw: image width
% ih: image height
% iin: total inner number of pixels
% iiw: image inner width
% iih: image inner height
% NSR=1/SNR 
% cfn_nsr: complete filename for nsr file (originally called .cor file)
% !!!CAUTION CAUTION
% THE  MOST BIZARRE BUG I HAVE EVER SEEN
% double(iin) INSTEAD OF iin will correct a problem that doesn't appear if
% this file is called from a simpler file
%
% initially, i thought this file contains SNRs.  Dr Barnes has been using
% the phrase "PSNR map" a lot.  However, on closer inspection of Explorer's
% code and discussions with Dr Barnes, found out that this file actually
% contains NSRs.  Plain simple NSR without any scaling or anything.
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : March 17, 2011
% Date last modified : July 20, 2011
%%

function NSR = RVQ_FILES_read_cor_file(cfn_nsr, iw, ih, sw, sh)

        [iin, iiw, iih]     =   RVQ_UTIL_computeInnerPixels(iw, ih, sw, sh);    

        [fileID, message]   =   fopen(cfn_nsr);
        NSR_1D              =   fread(fileID, double(iin), 'float');
        status              =   fclose(fileID);
        
        NSR                 =   reshape(NSR_1D, iiw, iih); %1D to 2D
        NSR                 =   NSR';
        

%visualize SNR (!!works great!!) 
%-------------------------------
%NSR = RVQ_FILES_read_cor_file('C:\salman\work\software\RVQ\DataWarehouses\PETS2001\00472_640x480_F1.cor', 640, 480, 11, 41);
%figure;imagesc(10*log10(1./NSR))
%colorbar
%impixelinfo    
%title('reconstruction SNR (dB)');