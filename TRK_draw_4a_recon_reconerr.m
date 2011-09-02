function TRK_draw_4a_recon_reconerr(recon, err_0t1, out_num_rows,out_num_cols,CONST.plot_row2, CONST.plot_row3, CONST.plot_title_fontsz, algo_code)

        if      (algo_code==1)  str='iPCA';     color = 'r';    
        elseif  (algo_code==2)  str='bPCA';     color = 'm';
        elseif  (algo_code==3)  str='RVQ';      color = 'g';
        elseif  (algo_code==4)  str='TSVQ';     color = 'b';
        end
    
    %reconstruction
        row_idx = CONST.plot_row2;
        if      (algo_code==1)  subplot(out_num_rows,out_num_cols,out_num_cols*row_idx+1);     
        elseif  (algo_code==2)  subplot(out_num_rows,out_num_cols,out_num_cols*row_idx+2);    
        elseif  (algo_code==3)  subplot(out_num_rows,out_num_cols,out_num_cols*row_idx+3);    
        elseif  (algo_code==4)  subplot(out_num_rows,out_num_cols,out_num_cols*row_idx+4);    
        end

        colormap('gray')
        imagesc(recon);
        set(gca, 'FontSize', 8);
        UTIL_makeTitle([str ', reconstruction'], color, CONST.plot_title_fontsz);
        axis equal
        axis tight

    %reconstruction err_0t1or
        row_idx = CONST.plot_row3;
        if      (algo_code==1)  subplot(out_num_rows,out_num_cols,out_num_cols*row_idx+1);    
        elseif  (algo_code==2)  subplot(out_num_rows,out_num_cols,out_num_cols*row_idx+2);    
        elseif  (algo_code==3)  subplot(out_num_rows,out_num_cols,out_num_cols*row_idx+3);    
        elseif  (algo_code==4)  subplot(out_num_rows,out_num_cols,out_num_cols*row_idx+4);    
        end          

        colormap('gray')
        imagesc(err_0t1);
        set(gca, 'FontSize', 8);
        UTIL_makeTitle([str ', recon. error'], color, CONST.plot_title_fontsz);
        axis equal
        axis tight