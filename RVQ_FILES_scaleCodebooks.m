%scalingType = 0; %no scaling
%scalingType = 1; %global scaling
%scalingType = 2; %stage-wise scaling
%scalingType = 3; %codevector-wise scaling

function CB_scaled = RVQ_FILES_scaleCodebooks(CB, scalingType)

        [M, T, sw, sh] = RVQ_FILES_getCodebookParameters(CB);
    
        

if      (scalingType ==0)
            CB_scaled = CB;
            
elseif  (scalingType == 1)        
            codebook_max  =   -100000000000;
            codebook_min  =   -codebook_max;
            
            %find global max amd min value of all codebooks so that they're
            %all scaled exactly the same
            for t=1:T
                for m=1:M
                    mx = max(max(max(CB{m}{t})));
                    mn = min(min(min(CB{m}{t})));
                    if (mx>codebook_max)
                        codebook_max = mx;
                    end
                    if (mn < codebook_min)
                        codebook_min = mn;
                    end
                end
            end
            
            for t=1:T
                for m=1:M
                    CB_scaled{m}{t}(:,:,1) = UTIL_scale(  CB{m}{t} (:,:,1), 255, codebook_max, codebook_min  );      
                    CB_scaled{m}{t}(:,:,2) = UTIL_scale(  CB{m}{t} (:,:,2), 255, codebook_max, codebook_min  );
                    CB_scaled{m}{t}(:,:,3) = UTIL_scale(  CB{m}{t} (:,:,3), 255, codebook_max, codebook_min  );
                end
            end
            
%stage wise            
elseif  (scalingType == 2)        

            for t=1:T
                stage_max  =   -100000000000;
                stage_min  =   -stage_max;                
                for m=1:M
                    mx = max(max(max(CB{m}{t})));
                    mn = min(min(min(CB{m}{t})));
                    if (mx>stage_max)
                        stage_max = mx;
                    end
                    if (mn < stage_min)
                        stage_min = mn;
                    end
                end
                for m=1:M
                    CB_scaled{m}{t}(:,:,1) = UTIL_scale(  CB{m}{t}(:,:,1), 255, stage_max, stage_min  );      
                    CB_scaled{m}{t}(:,:,2) = UTIL_scale(  CB{m}{t}(:,:,2), 255, stage_max, stage_min  );
                    CB_scaled{m}{t}(:,:,3) = UTIL_scale(  CB{m}{t}(:,:,3), 255, stage_max, stage_min  );                    
                end
            end
            
            
%codevector wise            
elseif  (scalingType == 3)     
    
     for t=1:T
        for m=1:M
            codevector_max = max(max(max(CB{m}{t})));
            codevector_min = min(min(min(CB{m}{t})));

            CB_scaled{m}{t}(:,:,1) = UTIL_scale(  CB{m}{t}(:,:,1), 255, codevector_max, codevector_min);
            CB_scaled{m}{t}(:,:,2) = UTIL_scale(  CB{m}{t}(:,:,2), 255, codevector_max, codevector_min);
            CB_scaled{m}{t}(:,:,3) = UTIL_scale(  CB{m}{t}(:,:,3), 255, codevector_max, codevector_min);
        end
     end
end

