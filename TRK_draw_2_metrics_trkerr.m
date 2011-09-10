function [trkIPCA.FP_2_est, BPCA.FP_2_est, RVQ.FP_2_est, TSVQ.FP_2_est] = TRK_draw_2_metricstrk_rmse(CONFIG, trkIPCA, trkBPCA, trkRVQ, trkTSVQ)

    
                                        figure(2);
                                        
                                        
                                        
                                        
            trkIPCA.FP_2_est(:,:,f)     =   trkIPCA.tgt_best_affine2_1x6([3,4,1;5,6,2])*[INP.gt_3_initial_fp; ones(1,INP.gt_2_num_fp)];
            trkIPCA.FP_1_gt                 =   cat(3, INP.gt_3_initial_fp+repmat(sz'/2,[1,INP.gt_2_num_fp]), GT(:,:,f), trkIPCA.FP_2_est(:,:,f));
            PCAidx                  =   find(trkIPCA.FP_1_gt(1,:,2) > 0);
            if (length(PCAidx) > 0)
                trkIPCA.FPerr(f)      =   sqrt(mean(sum((trkIPCA.FP_1_gt(:,PCAidx,2)-trkIPCA.FP_1_gt(:,PCAidx,3)).^2,1)));
            else
                trkIPCA.FPerr(f)      =   nan;
            end
            trkIPCA.FPerr_avg(f)           =   mean(trkIPCA.FPerr(~isnan(trkIPCA.FPerr)&(trkIPCA.FPerr>0)));

                                        
                                        subplot(out_num_rows,out_num_cols,2)
                                        plot(1:f, trkIPCA.FPerr(1:f),'r');
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
                                        plot(1:f, trkIPCA.FPerr_avg(1:f),'r');
                                        set(gca, 'FontSize', 8);
                                        title('mean tracking error', 'fontsize', PARAM.plot_title_fontsz);
                                        %axis tight
                                        hold on
                                        grid on
                                        
                                        
                                        
            %h1_pos                  =   get(h1, 'Position');
            %                            set(h1, 'Position', [10, 90, h1_pos(3), h1_pos(4)]);

        if (bUseBPCA )
            BPCA.FP_2_est(:,:,f)      =   trkBPCA.tgt_best_affine2_1x6([3,4,1;5,6,2])*[INP.gt_3_initial_fp; ones(1,INP.gt_2_num_fp)];
            trkBPCA.FP_1_gt                  =   cat(3, INP.gt_3_initial_fp+repmat(sz'/2,[1,INP.gt_2_num_fp]), GT(:,:,f), BPCA.FP_2_est(:,:,f));
            bPCAidx                  =   find(trkBPCA.FP_1_gt(1,:,2) > 0);
            if (length(bPCAidx) > 0)
              % trkIPCA.FPerr(f) = mean(sqrt(sum((trkIPCA.FP_1_gt(:,idx,2)-trkIPCA.FP_1_gt(:,idx,3)).^2,1)));
                BPCA.FPerr(f)      =   sqrt(mean(sum((trkBPCA.FP_1_gt(:,bPCAidx,2)-trkBPCA.FP_1_gt(:,bPCAidx,3)).^2,1)));
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
            TSVQ.FP_2_est(:,:,f)      =   trkTSVQ.tgt_best_affine2_1x6([3,4,1;5,6,2])*[INP.gt_3_initial_fp; ones(1,INP.gt_2_num_fp)];
            trkTSVQ.FP_1_gt                  =   cat(3, INP.gt_3_initial_fp+repmat(sz'/2,[1,INP.gt_2_num_fp]), GT(:,:,f), TSVQ.FP_2_est(:,:,f));
            TSVQidx                  =   find(trkTSVQ.FP_1_gt(1,:,2) > 0);
            if (length(TSVQidx) > 0)
              % trkIPCA.FPerr(f) =
              % mean(sqrt(sum((trkIPCA.FP_1_gt(:,idx,2)-trkIPCA.FP_1_gt(:,idx,3)).^2,1)))
              % ;
                TSVQ.FPerr(f)      =   sqrt(mean(sum((trkTSVQ.FP_1_gt(:,TSVQidx,2)-trkTSVQ.FP_1_gt(:,TSVQidx,3)).^2,1)));
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
        
        
        
        if (bUseRVQ)
            RVQ.FP_2_est(:,:,f)      =   trkRVQ.tgt_best_affine2_1x6([3,4,1;5,6,2])*[INP.gt_3_initial_fp; ones(1,INP.gt_2_num_fp)];
            trkRVQ.FP_1_gt                  =   cat(3, INP.gt_3_initial_fp+repmat(sz'/2,[1,INP.gt_2_num_fp]), GT(:,:,f), RVQ.FP_2_est(:,:,f));
            RVQidx                  =   find(trkRVQ.FP_1_gt(1,:,2) > 0);
            if (length(RVQidx) > 0)
                RVQ.FPerr(f)      =   sqrt(mean(sum((trkRVQ.FP_1_gt(:,RVQidx,2)-trkRVQ.FP_1_gt(:,RVQidx,3)).^2,1)));
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
    
