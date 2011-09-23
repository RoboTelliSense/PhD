function [cix_best, ciy_best] = RVQ_3_getBestTargetPositionFromCodebooks(odir, fn_rawimg, cfn_sed, M, T, tgtID, cx, cy, Nsx, Nsy, sw, sh, Iw, Ih, CB_ref, Ww, Wh, Uf)

    %dimensions
        [IiN, Iiw, Iih]             =   RVQ_UTIL_computeInnerPixels(Iw, Ih, sw, sh);            %inner image dimensions
        [Wxl, Wxr, Wyt, Wyb]        =   UTIL_ROI_centerOnPointAndComputeCornerCoordinates(cx, cy, Ww, Wh);
        
    %filenames
        cfn_sed_temp                =   [odir 'temp_snippetExtractionDetails.csv'];
        
    %buffers
        Iphi                        =   zeros(Iih, Iiw);
    
    i=1;
    totalPixelsToTest               =   (Wyb-Wyt+1)*(Wxr-Wxl+1);
    
    %do for every pixel in ROI window
    for cy=Wyt:Wyb
        for cx=Wxl:Wxr
        
            
%                                                         disp('               ----')
%                                                         str = sprintf('               %d of %d: delete %s if it exists', i, totalPixelsToTest, cfn_sed_temp);
%                                                         disp(str);
%                                                         disp('               ----')
                UTIL_FILE_delete     (cfn_sed_temp);
                
%                                                         disp('               ----')
%                                                         str = sprintf('               %d of %d: copy %s to %s', i, totalPixelsToTest, cfn_sed, cfn_sed_temp);
%                                                         disp(str);
%                                                         disp('               ----')
                                                        
                UTIL_copyFile       (cfn_sed, cfn_sed_temp);
                
                                
%                                                         disp('               ----')
%                                                         str = sprintf('               %d of %d: delete oldest snippets from %s', i, totalPixelsToTest, cfn_sed_temp);
%                                                         disp(str);
%                                                         disp('               ----')
                                                        
            
                numFrames_in_cfn_sed_temp = RVQ_0_cleanOutOldestFrameSnippetsFromSEDfile    (cfn_sed_temp, Nsx, Nsy);
                
                
%                                                         disp('               ----')
%                                                         str = sprintf('               %d of %d: add snippets to %s', i, totalPixelsToTest, cfn_sed_temp);
%                                                         disp(str);
%                                                         disp('               ----')
                                                        
                                                        
                [cix, ciy]          =   UTIL_ROI_convert_outer_to_inner_coordinates  (cx, cy, sw, sh);
                
                if (numFrames_in_cfn_sed_temp == 0)
                                        RVQ_0_writeSnippetsExtractionDetailsFile        (fn_rawimg, cfn_sed_temp, tgtID, cx, cy, Nsx, Nsy, Iw, Ih, false);
                else
                                        RVQ_0_writeSnippetsExtractionDetailsFile        (fn_rawimg, cfn_sed_temp, tgtID, cx, cy, Nsx, Nsy, Iw, Ih, true);
                end
                     
                
%                                                         disp('               ----')
%                                                         str = sprintf('               %d of %d: train', i, totalPixelsToTest);
%                                                         disp(str);
%                                                         disp('               ----')
                                                        
                                                        
    
                [CB, CBimg]       =   RVQ_1_Train                                     (odir, cfn_sed_temp, M, T, sw, sh);                 %system('UTIL_binaryFileCompare.exe   reference_5_gen.txt 
                
                                        
    
%                                                         disp('               ----')
%                                                         str = sprintf('               %d of %d: compute distance and save', i, totalPixelsToTest);
%                                                         disp(str);
%                                                         disp('               ----')
                                                        
                f_cbdiff      =   RVQ_0_codebook_distance                         (CB, CB_ref);
                Iphi(ciy, cix) = f_cbdiff;
                
%                                                         disp('               ----')
                                                         str = sprintf('               %3d of %d:   (cix, ciy): (%d, %d)    diff: %.2f', i, totalPixelsToTest, cix, ciy, f_cbdiff);
                                                         disp(str);
%                                                         disp('               ----')
                i=i+1;
        end
    end


    [r, c, maxvalues] = UTIL_ROI_getBestValuesInROI(Iphi, Wxl-(sw-1)/2, Wxr-(sw-1)/2, Wyt-(sh-1)/2, Wyb-(sh-1)/2, false);
    ciy_best = r(1);
    cix_best = c(1);
    maxvalues(1);
    
    clear Iphi;
                