    %--------------------------------
    %draw
    %--------------------------------

            if (bUsebPCA || bUseRVQ || bUseTSVQ)
                hh              =   figure(2);
                                    UTIL_suptitle(dir_out_wo_slash, 8);
                colormap('gray');
                I               =   uint8(data(:,:,f));
                                    subplot(out_num_rows,out_num_cols,1);
                                    set(gca, 'FontSize', 8);
                                    imagesc (I);
                                    axis equal
                                    axis tight
                                    title(str_f);
                                    hold on
                                    UTIL_drawQuadFrom6affineParams(sz, sIPCA_cond.best_vecAff_1x6, 'Color','r', 'LineWidth',1.0);            
                                    
            end
                      if (size(ipca_pts,3) > 1)  plot(ipca_pts(1,:,2),ipca_pts(2,:,2),'yx','MarkerSize',10);  end;
                      if (size(ipca_pts,3) > 2)  plot(ipca_pts(1,:,3),ipca_pts(2,:,3),'rx','MarkerSize',10);  end;
                      

                      
            if (bUsebPCA)
                if (exist('bpca_pts'))
                      if (size(bpca_pts,3) > 1)  plot(bpca_pts(1,:,2),bpca_pts(2,:,2),'yx','MarkerSize',10);  end;
                      if (size(bpca_pts,3) > 2)  plot(bpca_pts(1,:,3),bpca_pts(2,:,3),'mx','MarkerSize',10);  end;
                      UTIL_drawQuadFrom6affineParams(sz, sBPCA_cond.best_vecAff_1x6, 'Color','m', 'LineWidth',1.0);
                end
            end 

                       
            
            if (bUseTSVQ)
                if (exist('tsvq_pts'))
                      if (size(tsvq_pts,3) > 1)  plot(tsvq_pts(1,:,2),tsvq_pts(2,:,2),'yx','MarkerSize',10);  end;
                      if (size(tsvq_pts,3) > 2)  plot(tsvq_pts(1,:,3),tsvq_pts(2,:,3),'bx','MarkerSize',10);  end;
                      UTIL_drawQuadFrom6affineParams(sz, sTSVQ_cond.best_vecAff_1x6, 'Color','b', 'LineWidth',1.0);
                end
            end 
            
            
            if (bUseRVQ)
                if (exist('rvq__pts'))
                    if (size(rvq__pts,3) > 1)  plot(rvq__pts(1,:,2),rvq__pts(2,:,2),'yx','MarkerSize',10);  end;
                    if (size(rvq__pts,3) > 2)  plot(rvq__pts(1,:,3),rvq__pts(2,:,3),'gx','MarkerSize',10);  end;
                    UTIL_drawQuadFrom6affineParams(sz, sRVQ__cond.best_vecAff_1x6, 'Color','g', 'LineWidth',1.0);                                            
                end
            end
          
            hold off;
         

