                ipca_fig_DM = figure(10);     DM2_display(IPCA.DM2, sh, sw, 10, 10);
if (bUseBPCA )   bpca_fig_DM = figure(11);     DM2_display(BPCA.DM2, sh, sw, 10, 10);    end
if (bUseRVQx)    rvq__fig_DM = figure(12);     DM2_display(RVQ.DM2, sh, sw, 10, 10);    end
if (bUseTSVQ)   tsvq_fig_DM = figure(13);     DM2_display(TSVQ.DM2, sh, sw, 10, 10);    end

if (bUseBPCA )   bpca_fig_DM_new = figure(21);     DM2_display(BPCA.DM2_weighted, sh, sw, 10, 10);    end
if (bUseRVQx)    rvq__fig_DM_new = figure(22);     DM2_display(RVQ.DM2_weighted, sh, sw, 10, 10);    end
if (bUseTSVQ)   tsvq_fig_DM_new = figure(23);     DM2_display(TSVQ.DM2_weighted, sh, sw, 10, 10);    end