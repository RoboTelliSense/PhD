function CBimg = PCA_3_create_image_from_codebooks(CB, M, T, sw, sh)

        separation_between_tiles    =   5;


        
         
        %horizontally tile images along t, 1 such image per m          
            CB_horTiled=[];
            
            for m=1:M
                temp=[];
                for t=1:T
                    if (t==1)
                        a =     DATAMATRIX_extract_rowVec_from_DM_convert_to_matrix(CB(t,:), sh, sw);
                        b(:,:,1) = a;
                        b(:,:,2) = a;
                        b(:,:,3) = a;
                        temp = [temp  b];
                    else
                        temp = [temp  255*ones(sh,separation_between_tiles,3) b];
                    end
                end
                CB_horTiled{m}=temp;
            end


        %vertically tile above codebooks
            sz = size(CB_horTiled{1});
            CB_tiled=[]; 
            for m=1:M
                if (m==1)
                    CB_tiled = [CB_tiled ;CB_horTiled{m}];
                else
                    CB_tiled = [CB_tiled ;255*ones(11,sz(2),3); CB_horTiled{m}];
                end
            end
    
            CBimg = uint8(CB_tiled);