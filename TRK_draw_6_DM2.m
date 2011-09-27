                ipca_fig_DM = figure(10);     DATAMATRIX_display_DM2_as_image(IPCA.DM2, sh, sw, 10, 10);
if (bUseBPCA )   bpca_fig_DM = figure(11);     DATAMATRIX_display_DM2_as_image(BPCA.DM2, sh, sw, 10, 10);    end
if (bUseRVQx)    rvq__fig_DM = figure(12);     DATAMATRIX_display_DM2_as_image(RVQ.DM2, sh, sw, 10, 10);    end
if (bUseTSVQ)   tsvq_fig_DM = figure(13);     DATAMATRIX_display_DM2_as_image(TSVQ.DM2, sh, sw, 10, 10);    end

if (bUseBPCA )   bpca_fig_DM_new = figure(21);     DATAMATRIX_display_DM2_as_image(BPCA.DM2_weighted, sh, sw, 10, 10);    end
if (bUseRVQx)    rvq__fig_DM_new = figure(22);     DATAMATRIX_display_DM2_as_image(RVQ.DM2_weighted, sh, sw, 10, 10);    end
if (bUseTSVQ)   tsvq_fig_DM_new = figure(23);     DATAMATRIX_display_DM2_as_image(TSVQ.DM2_weighted, sh, sw, 10, 10);    end