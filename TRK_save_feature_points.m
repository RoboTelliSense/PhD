%     if (exist('pts'))
%         mypts = int16(pts);
%         if (size(pts,3) > 1)  
%             fid_truepts         =   fopen               (cfn_truepts, 'a');
%                                     UTIL_FILE_checkFileOpen  (fid_truepts, cfn_truepts);
%                                     fprintf             (fid_truepts, '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n', f, mypts(1,1,2), mypts(1,2,2), mypts(1,3,2), mypts(1,4,2), mypts(1,5,2), mypts(1,6,2), mypts(1,7,2), mypts(2,1,2), mypts(2,2,2), mypts(2,3,2), mypts(2,4,2), mypts(2,5,2), mypts(2,6,2), mypts(2,7,2));
%                                     fclose              (fid_truepts);
%         end;
%         if (size(pts,3) > 2)  
%             fid_trackpts        =   fopen               (cfn_trackpts, 'a');
%                                     UTIL_FILE_checkFileOpen  (fid_trackpts, cfn_trackpts);
%                                     fprintf             (fid_trackpts, '%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n', f, mypts(1,1,3), mypts(1,2,3), mypts(1,3,3), mypts(1,4,3), mypts(1,5,3), mypts(1,6,3), mypts(1,7,3), mypts(2,1,3), mypts(2,2,3), mypts(2,3,3), mypts(2,4,3), mypts(2,5,3), mypts(2,6,3), mypts(2,7,3));
%                                     fclose              (fid_trackpts);
%         end;
%     end