function hh=TRK_draw_1_I(f, data, CONFIG, trkaIPCA, trkaBPCA, trkaRVQx, trkaTSVQ, ...
                       trkaIPCA.FP_1_gt, trkaBPCA.FP_1_gt, trkaRVQx.FP_1_gt, trkaTSVQ.FP_1_gt)

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
                                    UTIL_drawQuadFrom6affine_1x6(PARAM.sz, trkaIPCA.tgt_best_aff_abcdxy_1x6, 'Color','r', 'LineWidth',1.0);            
                                    
            end
                      if (size(trkaIPCA.FP_1_gt,3) > 1)  plot(trkaIPCA.FP_1_gt(1,:,2),trkaIPCA.FP_1_gt(2,:,2),'yx','MarkerSize',10);  end;
                      if (size(trkaIPCA.FP_1_gt,3) > 2)  plot(trkaIPCA.FP_1_gt(1,:,3),trkaIPCA.FP_1_gt(2,:,3),'rx','MarkerSize',10);  end;
                      

                      
            if (PARAM.in_bUseBPCA )
                if (exist('trkaBPCA.FP_1_gt'))
                      if (size(trkaBPCA.FP_1_gt,3) > 1)  plot(trkaBPCA.FP_1_gt(1,:,2),trkaBPCA.FP_1_gt(2,:,2),'yx','MarkerSize',10);  end;
                      if (size(trkaBPCA.FP_1_gt,3) > 2)  plot(trkaBPCA.FP_1_gt(1,:,3),trkaBPCA.FP_1_gt(2,:,3),'mx','MarkerSize',10);  end;
                      UTIL_drawQuadFrom6affine_1x6(PARAM.sz, trkaBPCA.tgt_best_aff_abcdxy_1x6, 'Color','m', 'LineWidth',1.0);
                end
            end 

                       
            
            if (PARAM.in_bUseTSVQ)
                if (exist('trkaTSVQ.FP_1_gt'))
                      if (size(trkaTSVQ.FP_1_gt,3) > 1)  plot(trkaTSVQ.FP_1_gt(1,:,2),trkaTSVQ.FP_1_gt(2,:,2),'yx','MarkerSize',10);  end;
                      if (size(trkaTSVQ.FP_1_gt,3) > 2)  plot(trkaTSVQ.FP_1_gt(1,:,3),trkaTSVQ.FP_1_gt(2,:,3),'bx','MarkerSize',10);  end;
                      UTIL_drawQuadFrom6affine_1x6(PARAM.sz, trkaTSVQ.tgt_best_aff_abcdxy_1x6, 'Color','b', 'LineWidth',1.0);
                end
            end 
            
            
            if (PARAM.in_bUseRVQx)
                if (exist('trkaRVQx.FP_1_gt'))
                    if (size(trkaRVQx.FP_1_gt,3) > 1)  plot(trkaRVQx.FP_1_gt(1,:,2),trkaRVQx.FP_1_gt(2,:,2),'yx','MarkerSize',10);  end;
                    if (size(trkaRVQx.FP_1_gt,3) > 2)  plot(trkaRVQx.FP_1_gt(1,:,3),trkaRVQx.FP_1_gt(2,:,3),'gx','MarkerSize',10);  end;
                    UTIL_drawQuadFrom6affine_1x6(PARAM.sz, trkaRVQx.tgt_best_aff_abcdxy_1x6, 'Color','g', 'LineWidth',1.0);                                            
                end
            end
          
            hold off;
         

