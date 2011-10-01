%% This function writes input data (training vectors) to a file to be used for training an RVQ codebook.
%
% For all my algorithms, PCA, ESVQ, RVQ, TSVQ, the input data is formatted as a matrix called DM2. 
% Refer to readme.pdf for a config_str of DM2.
% 
% The training routines for PCA, ESVQ and TSVQ take the DM2 as input.
% However, RVQ requires its input to be saved as a file before it can be used for training by RVQ_1a_train_gen8.exe or RVQ_1a_train_gen16.exe.  
% This function takes a DM2 and creates a file in the following manner: (a) 512 byte header, followed by (b) each posneg training vector.
% 
% The file created by this function is what used to be called F1.sml in the original setup.
% 
% Copyright (C) Salman Aslam.  All rights reserved.
% Date created          : March 23, 2011
% Date last modified    : July 9, 2011.
%%

function DM2_saveto_rvq_format(DM2, cfn_trainingFile, sw, sh)  %cfn_trainingFile is the complete filename for the ouput file
                                                                    %this file will contain a header and data in the DM2 matrix
                                                                    %sw is snippet width, sh is snippet height
                                                                    
%------------------
%INITIALIZATIONS
%------------------
    Nc                      =   6;                      %number of channels in a training snippet, i.e., training vector
    [D, N]                  =   size(DM2);              %N is the number of training vectors, 
    shc                     =   sh*Nc;                  %number of rows in a single training snippet (vector)
    headerSize              =   512;                    %number of bytes in header
    numBytes                =   headerSize + sw*shc*N;  %total bytes in entire file

%------------------
%PRE-PROCESSING
%------------------   
% open the file    
    fid                     =   fopen(cfn_trainingFile, 'w');   %if this file exists, it is overwritten, fid is for file ID
                                UTIL_FILE_checkFileOpen(fid, cfn_trainingFile);

%initialize header with all zeros    
    for i=1:headerSize
        fwrite(fid, 0, 'char');                       
    end

%------------------
%PROCESSING
%------------------      
%write header
    TSH                     =   1;
    UCH                     =   1;
    REAL                    =   0;
    
    fseek(fid, 0,  'bof');      fwrite(fid, TSH,        'int32');
    fseek(fid, 4,  'bof');      fwrite(fid, 'abcdefg',  'char' ); 
    fseek(fid, 36, 'bof');      fwrite(fid, num2str(N), 'char' ); 
    fseek(fid, 44, 'bof');      fwrite(fid, sw,         'int32');
    fseek(fid, 48, 'bof');      fwrite(fid, shc,        'int32');
    fseek(fid, 52, 'bof');      fwrite(fid, UCH,        'int32');
    fseek(fid, 56, 'bof');      fwrite(fid, REAL,       'int32');
    fseek(fid, 60, 'bof');       
    
    for i=1:240+212
                                fwrite(fid, 204,        'uint8');
    end
    
%write data
    fseek(fid, 512, 'bof');
    for i=1:N
        I                   =   DM2_extract_image(DM2, i, sw, sh);%this returns an image
        Iposneg             =   RVQ_FILES_create_posnegImage(I, '', false, false);     %this converts the image to posneg format
                                fwrite(fid, Iposneg);                               %write each posneg image one after the other            
    end

%------------------
%POST-PROCESSING
%------------------      
%close file   
    fclose(fid);