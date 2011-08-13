%% This function takes a grayscale or RGB image and creates a posneg image.
%
% Refer to readme.pdf for a description of posneg images.
% 
% Copyright (C) Salman Aslam.  All rights reserved.
% Date created          : Feb 4, 2011
% Date last modified    : July 9, 2011.
%%

function Iposneg = RVQ_FILES_create_posnegImage(I, cfn_Iraw, bView, bSave)

%------------------
%INITIALIZATIONS
%------------------
    sz                      =   size(I);

    h                       =   sz(1);          
    w                       =   sz(2);
    Nc                      =   6;                  %number of channels in raw image
    
%------------------
%PRE-PROCESSING
%------------------ 
%extract planar channels, if grayscale, make all channels the same
    if (length(sz)==3)                              %RGB image
        posR                =   I(:,:,1);
        posG                =   I(:,:,2);
        posB                =   I(:,:,3);
    elseif (length(sz)==2)                          %gray scale image
        posR                =   I;
        posG                =   posR;
        posB                =   posR;
    end

%vectorize (the reason is that we'll be stacking these in planar form)
    posR                    =   posR';
    posG                    =   posG';
    posB                    =   posB';

    posR                    =   posR(:);
    posG                    =   posG(:);
    posB                    =   posB(:);

%create negative channels   
    negR                    =   255-posR;
    negG                    =   255-posG;
    negB                    =   255-posB;

%------------------
%PROCESSING
%------------------        
%create posneg image   
    Iposneg                 =   [posR; posG; posB; negR; negG; negB];    

%------------------
%POST-PROCESSING
%------------------        
%save it
    if (bSave)
        fid                 =   fopen(cfn_Iraw, 'w');
                                fwrite(fid, Iposneg);
                                fclose(fid);
    end
    
%view it
    if (bView)
        M                   =   reshape(Iposneg, w, h*Nc);
                                imshow(M')
                                title(cfn_Iraw);
                                pause
    end