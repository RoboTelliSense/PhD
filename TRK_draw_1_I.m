function hh=TRK_draw_1_I(f, data, CONFIG, trkIPCA, trkBPCA, trkRVQx, trkTSVQ, ...
                       trkIPCA.FP_1_gt, trkBPCA.FP_1_gt, trkRVQx.FP_1_gt, trkTSVQ.FP_1_gt)

            if (PARAM.in_bUseBPCA  || PARAM.in_bUseRVQx || PARAM.in_bUseTSVQ)
                figure(2);
                                    UTIL_suptitle(PARAM.config_name, 8);
                colormap('gray');
                I               =   uint8(data(:,:,f));
                                    subplot(PARAM.plot_num_rows, PARAM.plot_num_cols,1);
                                    set(gca, 'FontSize', 8);
                                    imagesc (I);
                                    axis equal
                                    axis tight
                                    title(PARAM.str_f);
                                    hold on
                                    UTIL_drawQuadFrom6affine_1x6(PARAM.sz, trkIPCA.tgt_best_aff_abcdxy_1x6, 'Color','r', 'LineWidth',1.0);            
                                    
            end
                      if (size(trkIPCA.FP_1_gt,3) > 1)  plot(trkIPCA.FP_1_gt(1,:,2),trkIPCA.FP_1_gt(2,:,2),'yx','MarkerSize',10);  end;
                      if (size(trkIPCA.FP_1_gt,3) > 2)  plot(trkIPCA.FP_1_gt(1,:,3),trkIPCA.FP_1_gt(2,:,3),'rx','MarkerSize',10);  end;
                      

                      
            if (PARAM.in_bUseBPCA )
                if (exist('trkBPCA.FP_1_gt'))
                      if (size(trkBPCA.FP_1_gt,3) > 1)  plot(trkBPCA.FP_1_gt(1,:,2),trkBPCA.FP_1_gt(2,:,2),'yx','MarkerSize',10);  end;
                      if (size(trkBPCA.FP_1_gt,3) > 2)  plot(trkBPCA.FP_1_gt(1,:,3),trkBPCA.FP_1_gt(2,:,3),'mx','MarkerSize',10);  end;
                      UTIL_drawQuadFrom6affine_1x6(PARAM.sz, trkBPCA.tgt_best_aff_abcdxy_1x6, 'Color','m', 'LineWidth',1.0);
                end
            end 

                       
            
            if (PARAM.in_bUseTSVQ)
                if (exist('trkTSVQ.FP_1_gt'))
                      if (size(trkTSVQ.FP_1_gt,3) > 1)  plot(trkTSVQ.FP_1_gt(1,:,2),trkTSVQ.FP_1_gt(2,:,2),'yx','MarkerSize',10);  end;
                      if (size(trkTSVQ.FP_1_gt,3) > 2)  plot(trkTSVQ.FP_1_gt(1,:,3),trkTSVQ.FP_1_gt(2,:,3),'bx','MarkerSize',10);  end;
                      UTIL_drawQuadFrom6affine_1x6(PARAM.sz, trkTSVQ.tgt_best_aff_abcdxy_1x6, 'Color','b', 'LineWidth',1.0);
                end
            end 
            
            
            if (PARAM.in_bUseRVQx)
                if (exist('trkRVQx.FP_1_gt'))
                    if (size(trkRVQx.FP_1_gt,3) > 1)  plot(trkRVQx.FP_1_gt(1,:,2),trkRVQx.FP_1_gt(2,:,2),'yx','MarkerSize',10);  end;
                    if (size(trkRVQx.FP_1_gt,3) > 2)  plot(trkRVQx.FP_1_gt(1,:,3),trkRVQx.FP_1_gt(2,:,3),'gx','MarkerSize',10);  end;
                    UTIL_drawQuadFrom6affine_1x6(PARAM.sz, trkRVQx.tgt_best_aff_abcdxy_1x6, 'Color','g', 'LineWidth',1.0);                                            
                end
            end
          
            hold off;
         

