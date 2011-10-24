function TRK_draw_results(f, data, CONFIG, trkIPCA, trkBPCA, trkRVQ, trkTSVQ, trkIPCA.FP_1_gt, trkBPCA.FP_1_gt, trkRVQ.FP_1_gt, trkTSVQ.FP_1_gt)

        %h1                      =   figure                  (1);
        %h1_pos                  =   get                     (h1, 'Position');
        %                            set                     (h1, 'Position', [10, 702, h1_pos(3), h1_pos(4)]);
        %IPCADrawOptions  =   drawtrackresult        (IPCADrawOptions, f, I_0t1, IPCA, trkIPCA, trkIPCA.FP_1_gt);



        h2                      =   figure                  (2);                                      
        h2_pos                  =   get                     (h2, 'Position');
                                    set                     (h2, 'Position', [10, 90, h2_pos(3), h2_pos(4)]); 

                                    
    TRK_draw_1_I                (f, data, CONFIG, trkIPCA, trkBPCA, trkRVQ, trkTSVQ, trkIPCA.FP_1_gt, trkBPCA.FP_1_gt, trkRVQ.FP_1_gt, trkTSVQ.FP_1_gt);
    TRK_draw_2_metricstrk_rmse   (         CONFIG, trkIPCA, trkBPCA, trkRVQ, trkTSVQ);
    TRK_draw_3_metrics_trgtst_wrapper;
    TRK_draw_4_recon_reconerr_wrapper;
    TRK_draw_5_PFcandidates_wrapper;
    TRK_draw_6_DM2; 
    TRK_draw_7_CB; 
