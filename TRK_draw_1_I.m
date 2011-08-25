function hh=TRK_draw_1_I(f, data, CONFIG, trkIPCA, trkBPCA, trkRVQ, trkTSVQ, ...
                       trkIPCA.FP_gt, trkBPCA.FP_gt, trkRVQ.FP_gt, trkTSVQ.FP_gt)

            if (CONFIG.in_bUseBPCA  || CONFIG.in_bUseRVQ || CONFIG.in_bUseTSVQ)
                figure(2);
                                    UTIL_suptitle(CONFIG.dir_out_wo_slash, 8);
                colormap('gray');
                I               =   uint8(data(:,:,f));
                                    subplot(CONFIG.plot_num_rows, CONFIG.plot_num_cols,1);
                                    set(gca, 'FontSize', 8);
                                    imagesc (I);
                                    axis equal
                                    axis tight
                                    title(CONFIG.str_f);
                                    hold on
                                    UTIL_drawQuadFrom6affine_1x6(CONFIG.sz, trkIPCA.best_affineROI_1x6, 'Color','r', 'LineWidth',1.0);            
                                    
            end
                      if (size(trkIPCA.FP_gt,3) > 1)  plot(trkIPCA.FP_gt(1,:,2),trkIPCA.FP_gt(2,:,2),'yx','MarkerSize',10);  end;
                      if (size(trkIPCA.FP_gt,3) > 2)  plot(trkIPCA.FP_gt(1,:,3),trkIPCA.FP_gt(2,:,3),'rx','MarkerSize',10);  end;
                      

                      
            if (CONFIG.in_bUseBPCA )
                if (exist('trkBPCA.FP_gt'))
                      if (size(trkBPCA.FP_gt,3) > 1)  plot(trkBPCA.FP_gt(1,:,2),trkBPCA.FP_gt(2,:,2),'yx','MarkerSize',10);  end;
                      if (size(trkBPCA.FP_gt,3) > 2)  plot(trkBPCA.FP_gt(1,:,3),trkBPCA.FP_gt(2,:,3),'mx','MarkerSize',10);  end;
                      UTIL_drawQuadFrom6affine_1x6(CONFIG.sz, trkBPCA.best_affineROI_1x6, 'Color','m', 'LineWidth',1.0);
                end
            end 

                       
            
            if (CONFIG.in_bUseTSVQ)
                if (exist('trkTSVQ.FP_gt'))
                      if (size(trkTSVQ.FP_gt,3) > 1)  plot(trkTSVQ.FP_gt(1,:,2),trkTSVQ.FP_gt(2,:,2),'yx','MarkerSize',10);  end;
                      if (size(trkTSVQ.FP_gt,3) > 2)  plot(trkTSVQ.FP_gt(1,:,3),trkTSVQ.FP_gt(2,:,3),'bx','MarkerSize',10);  end;
                      UTIL_drawQuadFrom6affine_1x6(CONFIG.sz, trkTSVQ.best_affineROI_1x6, 'Color','b', 'LineWidth',1.0);
                end
            end 
            
            
            if (CONFIG.in_bUseRVQ)
                if (exist('trkRVQ.FP_gt'))
                    if (size(trkRVQ.FP_gt,3) > 1)  plot(trkRVQ.FP_gt(1,:,2),trkRVQ.FP_gt(2,:,2),'yx','MarkerSize',10);  end;
                    if (size(trkRVQ.FP_gt,3) > 2)  plot(trkRVQ.FP_gt(1,:,3),trkRVQ.FP_gt(2,:,3),'gx','MarkerSize',10);  end;
                    UTIL_drawQuadFrom6affine_1x6(CONFIG.sz, trkRVQ.best_affineROI_1x6, 'Color','g', 'LineWidth',1.0);                                            
                end
            end
          
            hold off;
         

