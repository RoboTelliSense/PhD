                ipca_fig_DM = figure(10);     DATAMATRIX_display_DM2_as_image(ipca_DM2, sh, sw, 10, 10);
if (bUsebPCA)   bpca_fig_DM = figure(11);     DATAMATRIX_display_DM2_as_image(bpca_DM2, sh, sw, 10, 10);    end
if (bUseRVQ)    rvq__fig_DM = figure(12);     DATAMATRIX_display_DM2_as_image(rvq__DM2, sh, sw, 10, 10);    end
if (bUseTSVQ)   tsvq_fig_DM = figure(13);     DATAMATRIX_display_DM2_as_image(tsvq_DM2, sh, sw, 10, 10);    end

if (bUsebPCA)   bpca_fig_DM_new = figure(21);     DATAMATRIX_display_DM2_as_image(bpca_DM2_new, sh, sw, 10, 10);    end
if (bUseRVQ)    rvq__fig_DM_new = figure(22);     DATAMATRIX_display_DM2_as_image(rvq__DM2_new, sh, sw, 10, 10);    end
if (bUseTSVQ)   tsvq_fig_DM_new = figure(23);     DATAMATRIX_display_DM2_as_image(tsvq_DM2_new, sh, sw, 10, 10);    end