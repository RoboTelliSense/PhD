if (Ntrg_snp             >=  CONFIG.trg_B)
                    ipca_fig_CB = figure(30);     DATAMATRIX_display_DM2_as_image(IPCA.U_DxB,              sh, sw, 8, 8);      UTIL_saveimg_wholeFigure(ipca_fig_CB, [dir_out 'CB_ipca_' str_f '.png']);
    if (bUseBPCA )   bpca_fig_CB = figure(31);     DATAMATRIX_display_DM2_as_image(BPCA.mdl_2_U_DxN,       sh, sw, 8, 8);      UTIL_saveimg_wholeFigure(bpca_fig_CB, [dir_out 'CB_bpca_' str_f '.png']);end
    if (bUseRVQ)    rvq__fig_CB = figure(32);     DATAMATRIX_display_DM2_as_image(RVQ.mdl_2_CB_DxMP,              sh, sw, 8, 8);      UTIL_saveimg_wholeFigure(rvq__fig_CB, [dir_out 'CB_rvq__' str_f '.png']);end
    if (bUseTSVQ)   tsvq_fig_CB = figure(33);     DATAMATRIX_display_DM2_as_image(TSVQ.mdl_3_CB_DxK,            sh, sw, 8, 8);      UTIL_saveimg_wholeFigure(tsvq_fig_CB, [dir_out 'CB_tsvq_' str_f '.png']);end   
end

