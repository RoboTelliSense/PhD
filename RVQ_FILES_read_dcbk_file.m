%% This function reads and displays gen.exe generated .dcbk file which has
%% the decoder codebook
% 
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : February 9, 2011
% Date last modified : July 20, 2011
%%

function [T, S, sw, sh, mdl_3_CB_DxMP, mdl_CBg_DxMP, mdl_CBb_DxMP] = RVQ_FILES_read_dcbk_file(cfn_dcbk)

    %parameters that i've decided to fix
        sc                      =   6;      %number of channels   
        
    %constants
        dblbytes                =   8;
        top_level_header_size   =   1024;
   
    %----------------------------------------
    %READING codebooks.dcbk IN MATLAB (1 based)
    %----------------------------------------
        %read header
             fid                =   fopen(cfn_dcbk);     
                                    UTIL_FILE_checkFileOpen(fid, cfn_dcbk);                   
            temp_data           =   fread(fid, top_level_header_size, 'uchar'); 
                                    fclose(fid);
                                    
            T                   =   temp_data(37);      
            S                   =   temp_data(813)-1;   %S+1 is stored
            sw                  =   temp_data(825);
            sh                  =   temp_data(829)/sc;  %total height is stored, for all channels
            
            total_bytes         =   sw*sh*sc*dblbytes*S;
            total_bytes2        =   sw*sh*sc*dblbytes*(S+1);
            diff                =   total_bytes2 + 512;

        
        %read data
            fid                 =   fopen(cfn_dcbk);     
                                    UTIL_FILE_checkFileOpen(fid, cfn_dcbk);
            data                =   fread(fid, 'double'); 
                                    fclose(fid);
                                    
        
    %----------------------------------------
    %READING codebooks.dcbk IN HEX EDITOR NEO (0 based)
    %----------------------------------------
        %actual data in file
            %batch 1
            start_byte(1)       =   top_level_header_size; 
            end_byte(1)         =   start_byte(1) + total_bytes - 1;
            

            %batch 2
            start_byte(2)       =   start_byte(1) + diff;
            end_byte(2)         =   start_byte(2) + total_bytes - 1;
            

            %batch 3
            start_byte(3)       =   start_byte(2) + diff;
            end_byte(3)         =   start_byte(3) + total_bytes - 1;
            

            %batch 4
            start_byte(4)       =   start_byte(3) + diff;
            end_byte(4)         =   start_byte(4) + total_bytes - 1;
            


            %batch 5
            start_byte(5)       =   start_byte(4) + diff;
            end_byte(5)         =   start_byte(5) + total_bytes - 1;
            

            %batch 6
            start_byte(6)       =   start_byte(5) + diff;
            end_byte(6)         =   start_byte(6) + total_bytes - 1;
            

            %batch 7
            start_byte(7)       =   start_byte(6) + diff;
            end_byte(7)         =   start_byte(7) + total_bytes - 1;
            

            %batch 8
            start_byte(8)       =   start_byte(7) + diff;
            end_byte(8)         =   start_byte(8) + total_bytes - 1;
            
            %batch 9
            start_byte(9)       =   start_byte(8) + diff;
            end_byte(9)         =   start_byte(9) + total_bytes - 1;

            %batch 10
            start_byte(10)       =   start_byte(9) + diff;
            end_byte(10)         =   start_byte(10) + total_bytes - 1;
            
            %batch 11
            start_byte(11)       =   start_byte(10) + diff;
            end_byte(11)         =   start_byte(11) + total_bytes - 1;
            
            %batch 12
            start_byte(12)       =   start_byte(11) + diff;
            end_byte(12)         =   start_byte(12) + total_bytes - 1;
            
            %batch 13
            start_byte(13)       =   start_byte(12) + diff;
            end_byte(13)         =   start_byte(13) + total_bytes - 1;
            
            %batch 14
            start_byte(14)       =   start_byte(13) + diff;
            end_byte(14)         =   start_byte(14) + total_bytes - 1;
            
            %batch 15
            start_byte(15)       =   start_byte(14) + diff;
            end_byte(15)         =   start_byte(15) + total_bytes - 1;
            
            %batch 16
            start_byte(16)       =   start_byte(15) + diff;
            end_byte(16)         =   start_byte(16) + total_bytes - 1;  
            
        %extract codebook data from the file
            for t=1:T
                first_idx(t)        =   (start_byte(t)/dblbytes + 1);                %we add 1 because matlab is 1 one based
                last_idx(t)         =   ((end_byte(t)-(dblbytes-1))/dblbytes + 1);   %we subtract (dblbytes-1) so that we get to the index of the first byte in this double value
                level{t}            =   data(first_idx(t):last_idx(t));            
            end

        %extract channels from codebook data
            for t=1:T
                i=0;
                for m=1:S
                    R{t}{m}             =   reshape(level{t}(sw*sh*i + 1   :   sw*sh*(i+1)),   sw, sh);
                    i=i+1;
                    G{t}{m}             =   reshape(level{t}(sw*sh*i + 1   :   sw*sh*(i+1)),   sw, sh);
                    i=i+1;
                    B{t}{m}             =   reshape(level{t}(sw*sh*i + 1   :   sw*sh*(i+1)),   sw, sh);
                    i=i+1;
                    Rn{t}{m}            =   reshape(level{t}(sw*sh*i + 1   :   sw*sh*(i+1)),   sw, sh);
                    i=i+1;
                    Gn{t}{m}            =   reshape(level{t}(sw*sh*i + 1   :   sw*sh*(i+1)),   sw, sh);
                    i=i+1;
                    Bn{t}{m}            =   reshape(level{t}(sw*sh*i + 1   :   sw*sh*(i+1)),   sw, sh);
                    i=i+1;
                end
            end
        
            for m=1:S
                for t=1:T
                    R{t}{m} = R{t}{m}';
                    G{t}{m} = G{t}{m}';
                    B{t}{m} = B{t}{m}';
                    Rn{t}{m} = Rn{t}{m}';
                    Gn{t}{m} = Gn{t}{m}';
                    Bn{t}{m} = Bn{t}{m}';        
                end
            end
                    
            mdl_3_CB_DxMP=[];
            mdl_CBg_DxMP=[];
            mdl_CBb_DxMP=[];
        %create 3 channel codebooks (CB)
        %--------------------------------
            for t=1:T
                for m=1:S
%                     CB{t}{m}(:,:,1)    =   R{t}{m};
%                     CB{t}{m}(:,:,2)    =   G{t}{m};
%                     CB{t}{m}(:,:,3)    =   B{t}{m};
%                     
%                     CBn{t}{m}(:,:,1)    =   Rn{t}{m};
%                     CBn{t}{m}(:,:,2)    =   Gn{t}{m};
%                     CBn{t}{m}(:,:,3)    =   Bn{t}{m};
                    
                    idx                 =   UTIL_xy_to_idx(m, t, S);
                    mdl_3_CB_DxMP(:,idx)        =   R{t}{m}(:);
                    mdl_CBg_DxMP(:,idx)        =   G{t}{m}(:);
                    mdl_CBb_DxMP(:,idx)        =   B{t}{m}(:);
                    CBn_r(:,idx)       =   Rn{t}{m}(:);
                    CBn_g(:,idx)       =   Gn{t}{m}(:);
                    CBn_b(:,idx)       =   Bn{t}{m}(:);                    
                end
            end         
            
            