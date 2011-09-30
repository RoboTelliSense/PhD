if (Ntrg_snp             >=  PARAM.trg_freq)
                    ipca_fig_CB = figure(30);     DM2_show(IPCA.mdl_3_U__DxP,              sh, sw, 8, 8);      UTIL_saveimg_wholeFigure(ipca_fig_CB, [odir 'CB_ipca_' str_f '.png']);
    if (bUseBPCA )   bpca_fig_CB = figure(31);     DM2_show(BPCA.mdl_3_U__DxP,       sh, sw, 8, 8);      UTIL_saveimg_wholeFigure(bpca_fig_CB, [odir 'CB_bpca_' str_f '.png']);end
    if (bUseRVQx)    rvq__fig_CB = figure(32);     DM2_show(RVQ.mdl_3_CB_DxMP,              sh, sw, 8, 8);      UTIL_saveimg_wholeFigure(rvq__fig_CB, [odir 'CB_rvq__' str_f '.png']);end
    if (bUseTSVQ)   tsvq_fig_CB = figure(33);     DM2_show(TSVQ.mdl_4_CB_DxK,            sh, sw, 8, 8);      UTIL_saveimg_wholeFigure(tsvq_fig_CB, [odir 'CB_tsvq_' str_f '.png']);end   
end

