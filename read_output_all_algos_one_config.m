j=0;
k=0;
avg_trk_err = -1*zeros(4,4);

    [CONST.ds_2_name, CONST.ds_3_longName, F] = dataset_getName(datasetCode);
    

        
            for c=1:size(config, 1)
                ipca_Neig       =   config(c,1);
                bpca_Neig       =   ipca_Neig;
                rvq_maxT        =   config(c,2);
                rvq_S           =   config(c,3);
                rvq_targetSNR   =   config(c,4);
                tsvq_T          =   config(c,5);
                j               =   j+1;
                [txt_overall_config dir_out_wo_slash dir_out]         =   UTIL_DATASET_makeName(CONST.ds_3_longName, bUseBPCA , bUseTSVQ, bUseRVQ1, bUseRVQ2, Np, Nw, w, ipca_Neig, bpca_Neig, rvq_maxT, rvq_S, rvq_targetSNR, tsvq_T);
                cfn             =   [dir_out 'FPerr_3_ipca.csv'];
                if (exist(cfn,'file'))
                    a               =   csvread(cfn);
                    f               =   size(a,1);  %last frame number
                    if (f ~= F)
                        disp('no')
                    end
                        avg_trk_err(c,1)=   a(f,3);
                        k=k+1;
                    
                end
                cfn             =   [dir_out 'FPerr_3_bpca.csv'];
                if (exist(cfn,'file'))
                    a               =   csvread(cfn);
                    f               =   size(a,1);  %last frame number
                    avg_trk_err(c,2)=   a(f,3);
                    k=k+1;
                end
                cfn             =   [dir_out 'FPerr_3_rvq.csv'];
                if (exist(cfn,'file'))
                    a               =   csvread(cfn);
                    f               =   size(a,1);  %last frame number
                    avg_trk_err(c,3)=   a(f,3);
                    k=k+1;
                end
                cfn             =   [dir_out 'FPerr_3_tsvq.csv'];
                if (exist(cfn,'file'))
                    a               =   csvread(cfn);
                    f               =   size(a,1);  %last frame number
                    avg_trk_err(c,4)=   a(f,3);
                    k=k+1;
                end
                
            end
 
                        h=figure;
            bar(avg_trk_err);
            UTIL_FILE_save2pdf  ('test.pdf',      h,     150) ;
            set(gca,'XTick',[1:4])
            set(gca,'XTickLabel',{'16, 16, 8x2, 3';   ...
                                  '32, 32, 8x4, 4';   ...
                                  '64, 64, 8x8, 5';   ...
                                  '128, 128, 8x16, 6';})
                              colormap jet
            set(gca, 'FontSize', 8);                  
            xlabel('iPCA, bPCA, RVQ, TSVQ configurations');
            ylabel('Tracking error');
            legend('iPCA', 'bPCA', 'RVQ', 'TSVQ')
            grid
            axis([0 5 0 15])
            title(txt_overall_config, 'Interpreter','None')
            UTIL_FILE_save2pdf  ([txt_overall_config '.pdf'],      h,     300); 
