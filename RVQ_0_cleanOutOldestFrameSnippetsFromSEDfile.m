function numFramesInOutput = RVQ_0_cleanOutOldestFrameSnippetsFromSEDfile(cfn_sed, Nsx, Nsy)

        firstLineNumberToWrite              =   Nsx*Nsy + 1;

    %1. read the contents of the .sed file
        [tgtID, cfn_rawimg, Iw , Ih, sX, sY]=   textread(cfn_sed, '%d %s %d %d %d %d', 'delimiter', ',');
        
    %2. parameters
        numFramesRead                       =   length(tgtID)/(Nsx*Nsy);
        numFramesInOutput                   =   numFramesRead-1;
        numLinesToWrite                     =   (numFramesInOutput)*Nsx*Nsy;
        lastLineNumberToWrite               =   firstLineNumberToWrite + numLinesToWrite - 1;
        
                                                %2. delete the .sed file
                                                UTIL_FILE_deleteFile(cfn_sed);

    %3. open file for writing (discard existing contents, if any.
        fid                                 =   fopen(cfn_sed, 'w');
        
                                                           %error checking
                                                           UTIL_FILE_checkFileOpen(fid, cfn_sed);        
  
    %4. write .sed file
        j=1;
        for i=firstLineNumberToWrite : lastLineNumberToWrite
            
            if (j ==  numLinesToWrite)
                str = sprintf('%d, %s, %d, %d, %d, %d',      tgtID(i), cell2mat(cfn_rawimg(i)), Iw(i), Ih(i), sX(i), sY(i)); 
            else
                str = sprintf('%d, %s, %d, %d, %d, %d\n',    tgtID(i), cell2mat(cfn_rawimg(i)), Iw(i), Ih(i), sX(i), sY(i)); %write to snippetExtractionDetails.csv
            end
            fprintf(fid,  str); %write to snippetExtractionDetails.csv
            j=j+1;
            
        end
        
    %5. close file
        fclose(fid);
 
      