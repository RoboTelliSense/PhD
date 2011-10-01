function [trkaIPCA.FP_2_est, BPCA.FP_2_est, RVQ.FP_2_est, TSVQ.FP_2_est] = TRK_draw_2_metricstrk_rmse(CONFIG, trkaIPCA, trkaBPCA, trkaRVQx, trkaTSVQ)

    
                                        figure(2);
                                        
                                        
                                        
                                        
            trkaIPCA.FP_2_est(:,:,f)     =   trkaIPCA.tgt_best_aff_abcdxy_1x6([3,4,1;5,6,2])*[GT.fp_3_refzc_2xG; ones(1,GT.fp_2_G_____1x1)];
            trkaIPCA.FP_1_gt                 =   cat(3, GT.fp_3_refzc_2xG+repmat(sz'/2,[1,GT.fp_2_G_____1x1]), GT(:,:,f), trkaIPCA.FP_2_est(:,:,f));
            PCAidx                  =   find(trkaIPCA.FP_1_gt(1,:,2) > 0);
            if (length(PCAidx) > 0)
                trkaIPCA.FPerr(f)      =   sqrt(mean(sum((trkaIPCA.FP_1_gt(:,PCAidx,2)-trkaIPCA.FP_1_gt(:,PCAidx,3)).^2,1)));
            else
                trkaIPCA.FPerr(f)      =   nan;
            end
            trkaIPCA.FPerr_avg(f)           =   mean(trkaIPCA.FPerr(~isnan(trkaIPCA.FPerr)&(trkaIPCA.FPerr>0)));

                                        
                                        subplot(out_num_rows,out_num_cols,2)
                                        plot(1:f, trkaIPCA.FPerr(1:f),'r');
                                        set(gca, 'FontSize', 8);
                                        if ~isfield(RVQ,'T')
                                            str='tracking error';
                                        else
                                            str=['tracking error, (' num2str(RVQ.tst_6_partP_Nx1) '/' num2str(RVQ.T) ')'];
                                        end
                                        title(str, 'fontsize', PARAM.plot_title_fontsz);
                                        %axis tight
                                        hold on
                                        grid on
                                        
                                        subplot(out_num_rows,out_num_cols,6)
                                        plot(1:f, trkaIPCA.FPerr_avg(1:f),'r');
                                        set(gca, 'FontSize', 8);
                                        title('mean tracking error', 'fontsize', PARAM.plot_title_fontsz);
                                        %axis tight
                                        hold on
                                        grid on
                                        
                                        
                                        
            %h1_pos                  =   get(h1, 'Position');
            %                            set(h1, 'Position', [10, 90, h1_pos(3), h1_pos(4)]);

        if (bUseBPCA )
            BPCA.FP_2_est(:,:,f)      =   trkaBPCA.tgt_best_aff_abcdxy_1x6([3,4,1;5,6,2])*[GT.fp_3_refzc_2xG; ones(1,GT.fp_2_G_____1x1)];
            trkaBPCA.FP_1_gt                  =   cat(3, GT.fp_3_refzc_2xG+repmat(sz'/2,[1,GT.fp_2_G_____1x1]), GT(:,:,f), BPCA.FP_2_est(:,:,f));
            bPCAidx                  =   find(trkaBPCA.FP_1_gt(1,:,2) > 0);
            if (length(bPCAidx) > 0)
              % trkaIPCA.FPerr(f) = mean(sqrt(sum((trkaIPCA.FP_1_gt(:,idx,2)-trkaIPCA.FP_1_gt(:,idx,3)).^2,1)));
                BPCA.FPerr(f)      =   sqrt(mean(sum((trkaBPCA.FP_1_gt(:,bPCAidx,2)-trkaBPCA.FP_1_gt(:,bPCAidx,3)).^2,1)));
            else
                BPCA.FPerr(f)      =   nan;
            end
            BPCA.FPerr_avg(f)           =   mean(BPCA.FPerr(~isnan(BPCA.FPerr)&(BPCA.FPerr>0)));
                                        
                                        subplot(out_num_rows,out_num_cols,2)
                                        plot(1:f, BPCA.FPerr(1:f),'m');
                                        %axis tight
                                        hold on
                                        grid on
                                        
                                        subplot(out_num_rows,out_num_cols,6)
                                        plot(1:f, BPCA.FPerr_avg(1:f),'m');
                                        %axis tight
                                        hold on
                                        grid on                                    
        end        
        

        
               
        if (bUseTSVQ)
            TSVQ.FP_2_est(:,:,f)      =   trkaTSVQ.tgt_best_aff_abcdxy_1x6([3,4,1;5,6,2])*[GT.fp_3_refzc_2xG; ones(1,GT.fp_2_G_____1x1)];
            trkaTSVQ.FP_1_gt                  =   cat(3, GT.fp_3_refzc_2xG+repmat(sz'/2,[1,GT.fp_2_G_____1x1]), GT(:,:,f), TSVQ.FP_2_est(:,:,f));
            TSVQidx                  =   find(trkaTSVQ.FP_1_gt(1,:,2) > 0);
            if (length(TSVQidx) > 0)
              % trkaIPCA.FPerr(f) =
              % mean(sqrt(sum((trkaIPCA.FP_1_gt(:,idx,2)-trkaIPCA.FP_1_gt(:,idx,3)).^2,1)))
              % ;
                TSVQ.FPerr(f)      =   sqrt(mean(sum((trkaTSVQ.FP_1_gt(:,TSVQidx,2)-trkaTSVQ.FP_1_gt(:,TSVQidx,3)).^2,1)));
            else
                TSVQ.FPerr(f)      =   nan;
            end
            TSVQ.FPerr_avg(f)           =   mean(TSVQ.FPerr(~isnan(TSVQ.FPerr)&(TSVQ.FPerr>0)));
                                        
                                        subplot(out_num_rows,out_num_cols,2)
                                        plot(1:f, TSVQ.FPerr(1:f),'b');
                                        %axis tight
                                        hold on
                                        grid on
                                        
                                        subplot(out_num_rows,out_num_cols,6)
                                        plot(1:f, TSVQ.FPerr_avg(1:f),'b');
                                        %axis tight
                                        hold on
                                        grid on
        end
        
        
        
        if (bUseRVQx)
            RVQ.FP_2_est(:,:,f)      =   trkaRVQx.tgt_best_aff_abcdxy_1x6([3,4,1;5,6,2])*[GT.fp_3_refzc_2xG; ones(1,GT.fp_2_G_____1x1)];
            trkaRVQx.FP_1_gt                  =   cat(3, GT.fp_3_refzc_2xG+repmat(sz'/2,[1,GT.fp_2_G_____1x1]), GT(:,:,f), RVQ.FP_2_est(:,:,f));
            RVQidx                  =   find(trkaRVQx.FP_1_gt(1,:,2) > 0);
            if (length(RVQidx) > 0)
                RVQ.FPerr(f)      =   sqrt(mean(sum((trkaRVQx.FP_1_gt(:,RVQidx,2)-trkaRVQx.FP_1_gt(:,RVQidx,3)).^2,1)));
            else
                RVQ.FPerr(f)      =   nan;
            end
            RVQ.FPerr_avg(f)           =   mean(RVQ.FPerr(~isnan(RVQ.FPerr)&(RVQ.FPerr>0)));
                                        
                                        subplot(out_num_rows,out_num_cols,2)
                                        plot(1:f, RVQ.FPerr(1:f),'g');
                                        %axis tight
                                        hold on
                                        grid on
                                        
                                        subplot(out_num_rows,out_num_cols,6)
                                        plot(1:f, RVQ.FPerr_avg(1:f),'g');
                                        %axis tight
                                        hold on
                                        grid on                                       
        end        

  
        

        
        
        
        hold off;
    
