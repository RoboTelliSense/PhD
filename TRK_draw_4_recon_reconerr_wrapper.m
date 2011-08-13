                                TRK_draw_4a_recon_reconerr(sIPCA_cond.recon,  sIPCA_cond.err_0to1_sw_x_sh, out_num_rows,  out_num_cols,   row_recon, row_recon_err,   fs, 1);  %notice the minus
   if (bUsebPCA)                TRK_draw_4a_recon_reconerr(sBPCA_cond.recon,  sBPCA_cond.err_0to1_sw_x_sh, out_num_rows,  out_num_cols,   row_recon, row_recon_err,   fs, 2); end
   if (bUseRVQ)                 TRK_draw_4a_recon_reconerr(sRVQ__cond.recon,  sRVQ__cond.err_0to1_sw_x_sh, out_num_rows,  out_num_cols,   row_recon, row_recon_err,   fs, 3); end
   if (bUseTSVQ)                TRK_draw_4a_recon_reconerr(sTSVQ_cond.recon,  sTSVQ_cond.err_0to1_sw_x_sh, out_num_rows,  out_num_cols,   row_recon, row_recon_err,   fs, 4); end
