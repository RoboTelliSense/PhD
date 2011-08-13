                                TRK_draw_5a_PFcandidates(I_0t1, sz, sIPCA_cond.affineCandidates_6xNp,    out_num_rows,   out_num_cols,   row_particles,              fs, 1);
    if (bUsebPCA)               TRK_draw_5a_PFcandidates(I_0t1, sz, sBPCA_cond.affineCandidates_6xNp,    out_num_rows,   out_num_cols,   row_particles,              fs, 2); end
    if (bUseRVQ)                TRK_draw_5a_PFcandidates(I_0t1, sz, sRVQ__cond.affineCandidates_6xNp,    out_num_rows,   out_num_cols,   row_particles,              fs, 3); end
    if (bUseTSVQ)               TRK_draw_5a_PFcandidates(I_0t1, sz, sTSVQ_cond.affineCandidates_6xNp,    out_num_rows,   out_num_cols,   row_particles,              fs, 4); end
     