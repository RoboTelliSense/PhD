function [str1, str2] = UTIL_PLOT_display(I, f, PARAM, GT, trkMEAN, trkIPCA, trkBPCA, trkRVQx, trkTSVQ)
        
    str1=num2str(f);
    str2=num2str(f);
    
    if (f<=PARAM.trg_freq)
        str1 = [str1 ' ' num2str(trkMEAN.trk_2_rmse__Fx1(f))]; 
        str2 = [str2 ' ' num2str(trkMEAN.trk_3_armse_Fx1(f))]; 
    else
        if (PARAM.in_bUseIPCA) str1 = [str1 ' ' num2str(trkIPCA.trk_2_rmse__Fx1(f))]; end
        if (PARAM.in_bUseBPCA) str1 = [str1 ' ' num2str(trkBPCA.trk_2_rmse__Fx1(f))]; end
        if (PARAM.in_bUseRVQx) str1 = [str1 ' ' num2str(trkRVQx.trk_2_rmse__Fx1(f))]; end
        if (PARAM.in_bUseTSVQ) str1 = [str1 ' ' num2str(trkTSVQ.trk_2_rmse__Fx1(f))]; end    

        if (PARAM.in_bUseIPCA) str2 = [str2 ' ' num2str(trkIPCA.trk_3_armse_Fx1(f))]; end
        if (PARAM.in_bUseBPCA) str2 = [str2 ' ' num2str(trkBPCA.trk_3_armse_Fx1(f))]; end
        if (PARAM.in_bUseRVQx) str2 = [str2 ' ' num2str(trkRVQx.trk_3_armse_Fx1(f))]; end
        if (PARAM.in_bUseTSVQ) str2 = [str2 ' ' num2str(trkTSVQ.trk_3_armse_Fx1(f))]; end   
    end
    %console
    str2
    
    %display
    if (ispc)
        imagesc(uint8(I));
        colormap(gray)
        hold on;
        
        %ground truth
        fpt_1_truth_2xG     =   GT.fpt_1_truth_2xGxF(:,:,f);
        [t1 G ]             =   size(fpt_1_truth_2xG);
        %plot(fpt_1_truth_2xG(1,:), fpt_1_truth_2xG(2,:), 'yx');
        for g=1:G
            UTIL_PLOT_filledCircle( [fpt_1_truth_2xG(1,g), fpt_1_truth_2xG(2,g)],   3,   3000,   'y'); 
        end
                
                

        if (f<=PARAM.trg_freq)
                                   UTIL_2D_affine_drawQuadFrom_Ha_2x3(UTIL_2D_affine_tsrpxy_to_Ha_2x3(trkMEAN.snp_1_tsrpxy_1x6), PARAM.tgt_sh, PARAM.tgt_sw, PARAM.plot_alpha, 'k');
                for g=1:G
                    UTIL_PLOT_filledCircle( [trkMEAN.fpt_2_estim_2xG(1,g), trkMEAN.fpt_2_estim_2xG(2,g)],   2,   3000,   'k'); 
                end
                                   
        else
            
            if (PARAM.in_bUseIPCA) 
                hold on;
                UTIL_2D_affine_drawQuadFrom_Ha_2x3(UTIL_2D_affine_tsrpxy_to_Ha_2x3(trkIPCA.snp_1_tsrpxy_1x6), PARAM.tgt_sh, PARAM.tgt_sw, 0, 'm');
                for g=1:G
                    UTIL_PLOT_filledCircle( [trkIPCA.fpt_2_estim_2xG(1,g), trkIPCA.fpt_2_estim_2xG(2,g)],   2,   3000,   'm'); 
                end
            end
            
            if (PARAM.in_bUseBPCA) 
                hold on;
                UTIL_2D_affine_drawQuadFrom_Ha_2x3(UTIL_2D_affine_tsrpxy_to_Ha_2x3(trkBPCA.snp_1_tsrpxy_1x6), PARAM.tgt_sh, PARAM.tgt_sw, 0, 'r');
                for g=1:G
                    UTIL_PLOT_filledCircle( [trkBPCA.fpt_2_estim_2xG(1,g), trkBPCA.fpt_2_estim_2xG(2,g)],   2,   3000,   'r'); 
                end
                
            end
            if (PARAM.in_bUseTSVQ) 
                hold on;
                UTIL_2D_affine_drawQuadFrom_Ha_2x3(UTIL_2D_affine_tsrpxy_to_Ha_2x3(trkTSVQ.snp_1_tsrpxy_1x6), PARAM.tgt_sh, PARAM.tgt_sw, 0, 'b');
                for g=1:G
                    UTIL_PLOT_filledCircle( [trkTSVQ.fpt_2_estim_2xG(1,g), trkTSVQ.fpt_2_estim_2xG(2,g)],   2,   3000,   'b'); 
                end
                
            end
            
            if (PARAM.in_bUseRVQx)
                hold on;
                UTIL_2D_affine_drawQuadFrom_Ha_2x3(UTIL_2D_affine_tsrpxy_to_Ha_2x3(trkRVQx.snp_1_tsrpxy_1x6), PARAM.tgt_sh, PARAM.tgt_sw, 0, 'g');
                for g=1:G
                    UTIL_PLOT_filledCircle( [trkRVQx.fpt_2_estim_2xG(1,g), trkRVQx.fpt_2_estim_2xG(2,g)],   2,   3000,   'g'); 
                end
                
            end

        end
        title(str1);
        axis equal;
        axis tight;
        drawnow;
        hold off;
        UTIL_FILE_save2png([UTIL_GetZeroPrefixedFileNumber(f) '.png'], gcf);
    end  
   
        
