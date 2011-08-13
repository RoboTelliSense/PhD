    if (exist('truepts','var'))
                                        figure(2);
                                        
                                        
                                        
                                        
            ipca_trackpts(:,:,f)     =   sIPCA_cond.best_vecAff_1x6([3,4,1;5,6,2])*[pts0; ones(1,npts)];
            ipca_pts                 =   cat(3, pts0+repmat(sz'/2,[1,npts]), truepts(:,:,f), ipca_trackpts(:,:,f));
            PCAidx                  =   find(ipca_pts(1,:,2) > 0);
            if (length(PCAidx) > 0)
                ipca_trackerr(f)      =   sqrt(mean(sum((ipca_pts(:,PCAidx,2)-ipca_pts(:,PCAidx,3)).^2,1)));
            else
                ipca_trackerr(f)      =   nan;
            end
            ipca_trackerr_mean(f)           =   mean(ipca_trackerr(~isnan(ipca_trackerr)&(ipca_trackerr>0)));
            if (exist('dispstr','var'))  
                                        fprintf(repmat('\b',[1,length(dispstr)]));  
            end;
            %dispstr                 =   sprintf('frame %d, iPCA: %.4f / %.4f\n',f,ipca_trackerr(f),ipca_trackerr_mean(f));
            %                            fprintf(dispstr);
                                        
                                        subplot(out_num_rows,out_num_cols,2)
                                        plot(1:f, ipca_trackerr(1:f),'r');
                                        set(gca, 'FontSize', 8);
                                        if ~isfield(sRVQ,'T')
                                            str='tracking error';
                                        else
                                            str=['tracking error, (' num2str(sRVQ.tst_partialP) '/' num2str(sRVQ.T) ')'];
                                        end
                                        title(str, 'fontsize', fs);
                                        %axis tight
                                        hold on
                                        grid on
                                        
                                        subplot(out_num_rows,out_num_cols,6)
                                        plot(1:f, ipca_trackerr_mean(1:f),'r');
                                        set(gca, 'FontSize', 8);
                                        title('mean tracking error', 'fontsize', fs);
                                        %axis tight
                                        hold on
                                        grid on
                                        
                                        
                                        
            %h1_pos                  =   get(h1, 'Position');
            %                            set(h1, 'Position', [10, 90, h1_pos(3), h1_pos(4)]);

        if (bUsebPCA)
            bpca_trackpts(:,:,f)      =   sBPCA_cond.best_vecAff_1x6([3,4,1;5,6,2])*[pts0; ones(1,npts)];
            bpca_pts                  =   cat(3, pts0+repmat(sz'/2,[1,npts]), truepts(:,:,f), bpca_trackpts(:,:,f));
            bPCAidx                  =   find(bpca_pts(1,:,2) > 0);
            if (length(bPCAidx) > 0)
              % ipca_trackerr(f) = mean(sqrt(sum((ipca_pts(:,idx,2)-ipca_pts(:,idx,3)).^2,1)));
                bpca_trackerr(f)      =   sqrt(mean(sum((bpca_pts(:,bPCAidx,2)-bpca_pts(:,bPCAidx,3)).^2,1)));
            else
                bpca_trackerr(f)      =   nan;
            end
            bpca_trackerr_mean(f)           =   mean(bpca_trackerr(~isnan(bpca_trackerr)&(bpca_trackerr>0)));
            if (exist('dispstr','var'))  
                                        fprintf(repmat('\b',[1,length(dispstr)]));  
            end;
            %dispstr                 =   sprintf('frame %d, bPCA: %.4f / %.4f\n',f,bpca_trackerr(f),bpca_trackerr_mean(f));
            %                            fprintf(dispstr);
                                        
                                        subplot(out_num_rows,out_num_cols,2)
                                        plot(1:f, bpca_trackerr(1:f),'m');
                                        %axis tight
                                        hold on
                                        grid on
                                        
                                        subplot(out_num_rows,out_num_cols,6)
                                        plot(1:f, bpca_trackerr_mean(1:f),'m');
                                        %axis tight
                                        hold on
                                        grid on                                    
        end        
        

        
               
        if (bUseTSVQ)
            tsvq_trackpts(:,:,f)      =   sTSVQ_cond.best_vecAff_1x6([3,4,1;5,6,2])*[pts0; ones(1,npts)];
            tsvq_pts                  =   cat(3, pts0+repmat(sz'/2,[1,npts]), truepts(:,:,f), tsvq_trackpts(:,:,f));
            TSVQidx                  =   find(tsvq_pts(1,:,2) > 0);
            if (length(TSVQidx) > 0)
              % ipca_trackerr(f) =
              % mean(sqrt(sum((ipca_pts(:,idx,2)-ipca_pts(:,idx,3)).^2,1)))
              % ;
                tsvq_trackerr(f)      =   sqrt(mean(sum((tsvq_pts(:,TSVQidx,2)-tsvq_pts(:,TSVQidx,3)).^2,1)));
            else
                tsvq_trackerr(f)      =   nan;
            end
            tsvq_trackerr_mean(f)           =   mean(tsvq_trackerr(~isnan(tsvq_trackerr)&(tsvq_trackerr>0)));
            if (exist('dispstr','var'))  
                                        fprintf(repmat('\b',[1,length(dispstr)]));  
            end;
            %dispstr                 =   sprintf('frame %d, TSVQ: %.4f / %.4f\n',f,tsvq_trackerr(f),tsvq_trackerr_mean(f));
            %                            fprintf(dispstr);
                                        
                                        subplot(out_num_rows,out_num_cols,2)
                                        plot(1:f, tsvq_trackerr(1:f),'b');
                                        %axis tight
                                        hold on
                                        grid on
                                        
                                        subplot(out_num_rows,out_num_cols,6)
                                        plot(1:f, tsvq_trackerr_mean(1:f),'b');
                                        %axis tight
                                        hold on
                                        grid on
        end
        
        
        
        if (bUseRVQ)
            rvq__trackpts(:,:,f)      =   sRVQ__cond.best_vecAff_1x6([3,4,1;5,6,2])*[pts0; ones(1,npts)];
            rvq__pts                  =   cat(3, pts0+repmat(sz'/2,[1,npts]), truepts(:,:,f), rvq__trackpts(:,:,f));
            RVQidx                  =   find(rvq__pts(1,:,2) > 0);
            if (length(RVQidx) > 0)
                rvq__trackerr(f)      =   sqrt(mean(sum((rvq__pts(:,RVQidx,2)-rvq__pts(:,RVQidx,3)).^2,1)));
            else
                rvq__trackerr(f)      =   nan;
            end
            rvq__trackerr_mean(f)           =   mean(rvq__trackerr(~isnan(rvq__trackerr)&(rvq__trackerr>0)));
            if (exist('dispstr','var'))  
                                        fprintf(repmat('\b',[1,length(dispstr)]));  
            end;
            %dispstr                 =   sprintf('frame %d, RVQ : %.4f / %.4f\n',f,rvq__trackerr(f),rvq__trackerr_mean(f));
            %                            fprintf(dispstr);
                                        
                                        subplot(out_num_rows,out_num_cols,2)
                                        plot(1:f, rvq__trackerr(1:f),'g');
                                        %axis tight
                                        hold on
                                        grid on
                                        
                                        subplot(out_num_rows,out_num_cols,6)
                                        plot(1:f, rvq__trackerr_mean(1:f),'g');
                                        %axis tight
                                        hold on
                                        grid on                                       
        end        

  
        

        
        
        
        hold off;
    end
