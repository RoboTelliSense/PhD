function UTIL_savecsv_struct(cfn_csv, f, struct)

    %-------------------------------
    %operations
    %-------------------------------
        %open file
            fid     =   fopen               (cfn_csv, 'a');
                        UTIL_FILE_checkFileOpen  (fid, cfn_csv);

    %-------------------------------
    %operations
    %-------------------------------
        %write frame number
            cnt     =   fprintf             (fid, '%d', f);

        %write data
            for i=1:length(struct.data)
               cnt  =   fprintf             (fid, ', %15.2f', struct.data(i)); 
            end

        %write new line    
            cnt     =   fprintf             (fid, '\n');

    %-------------------------------
    %wrap up
    %-------------------------------
        %close file
            fclose(fid);
                                                        