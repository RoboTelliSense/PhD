%% This function reads Linker or Explorer generated .idx files which have
%% training or test XDR's respectively
% 
% usage   
% RVQ_read_IDX('C:\salman\work\software\RVQ\Data Warehouses\ECE8833a\F1.idx', 8, true)
% explorer and linker .idx files have different format
% to read linker style, set bLinkerNotExplorerStyle_idx = true
%
% maxP is maximum number of stages in RVQ, currently either 8 or 16
% M is number of codevectors per stage
%
% explorer .idx file has values from 0 to M+1. 
% i add 1 so that it goes from 1 to M+2. 
% then, I replace all M+2's with M+1
% the reason for this replacement is that in discussions with Dr Barnes, it
% wasn't clear why M+1 and M+2 are used (M and M+1 in original), but what is
% clear is that they both signal early termination.  Better to have only one
% value then that signals early termination.
%
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : February 15, 2011
% Date last modified : July 29, 2011
%%

function XDRs = RVQ_FILES_read_idx_file(cfn_idx, maxP, M, bLinkerNotExplorerStyle_idx) %notice maxP rather than P
                %this is because the idx file, whether created by Linker or
                %Explorer has entries according to maxP

%-----------------------
%INITIALIZATIONS
%-----------------------
                     
    %read .data file (could be linker, or explorer generated)
    fid                     =   fopen(cfn_idx);
                                UTIL_FILE_checkFileOpen(fid, cfn_idx);
            
    data                    =   fread(fid, 'uint8');
                                fclose(fid);
                                        
    %make XDRs's start from 1
    data                    =   data+1;  %- after this addition, the alphabet for training XDRs's is from 1 to M
                                         %and the alphabet for test XDRs's is from 1 to M+2
                                         %- for test XDRs's, M+1 and M+2 are fillers.  after discussions with Dr
                                         %Barnes, we were not able to distinguish between them.  
        
    %get number of observations from file size
    %notice that I know maxP, and so I can find N, since the number of
    %bytes in the file is NT
    N                       =   length(data)/maxP;  %number of training examples (observations)
                                                                                                         
%-----------------------
%PROCESSING
%-----------------------

    if (bLinkerNotExplorerStyle_idx) 
        
        %Linker generated idx file
        temp                =   reshape(data,N, maxP);     %training XDRs matrix
        trg_XDRs_PxN         =   temp';
        XDRs                =   trg_XDRs_PxN;            %this is what will be returned from the function

    
    else
        %Explorer generated idx file (replace M+2 with M+1)
        for n =1:N*maxP
            if (data(n) == M+2)                                 %Dr Barnes and I could never figure out why explorer using M+2, but we agreed that it's probably some form of early termination which is indicated by M+1, so we're changing this to M+1
                data(n)     = M+1;
            end
        end
        tst_XDRs_PxNii      =   reshape(data,maxP, N);             %NIii: number of pixels in inner part of image that is tested           
        XDRs                =   tst_XDRs_PxNii;                 %test XDRs matrix                  
    end       
    
    