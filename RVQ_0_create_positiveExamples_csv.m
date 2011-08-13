function RVQ_0_create_positiveExamples_csv(cfn_Iraw, cfn_poscsv, rect, Nsx, Nsy, iw, ih, bAppend)

        
    %get all snippet centers that need to be written
        %[sX, sY]            =   UTIL_getNeighborhoodPoints(cx, cy, Nsx, Nsy);
        
       
        
    %open file        
        fid                 =   fopen(cfn_poscsv, 'a');
                                                          %error checking
                                                          UTIL_FILE_checkFileOpen(fid, cfn_poscsv);       
        
    %write
        if (bAppend)
            fprintf(fid, '\n');           
        end
      
            %if (i==Nsx && j == Nsy)
                    fprintf(fid, '%s, %d, %d, %d, %d, %d, %d',   cfn_Iraw, iw, ih, rect(1), rect(2), rect(3), rect(4)); %write to snippetExtractionDetails.csv
            %else
            %        fprintf(fid, '%s, %d, %d, %d, %d, %d, %d\n', cfn_Iraw, iw, ih, rect(1), rect(2), rect(3), rect(4));
            %end
                
%         for i=1:Nsx
%             for j=1:Nsy
%                 
%                 if (i==Nsx && j == Nsy)
%                     fprintf(fid, '%s, %d, %d, %d, %d, %d, %d',   cfn_Iraw, iw, ih, sX(i), sY(j), sw, sh); %write to snippetExtractionDetails.csv
%                 else
%                     fprintf(fid, '%s, %d, %d, %d, %d, %d, %d\n', cfn_Iraw, iw, ih, sX(i), sY(j), sw, sh);
%                 end
%                 
%             end
%         end
        
            
    %close
    fclose(fid);        
                
                
                
    
          
            