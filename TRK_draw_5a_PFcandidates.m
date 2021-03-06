function TRK_draw_5_PF_candidates(I, sz, PFcandidates_6xNp, out_num_rows, out_num_cols, PARAM.plot_row4, PARAM.plot_title_fontsz, algo_code)

    if      (algo_code==1)  str='iPCA';     color = 'r';    
    elseif  (algo_code==2)  str='bPCA';     color = 'm';
    elseif  (algo_code==3)  str='RVQ';      color = 'g';
    elseif  (algo_code==4)  str='TSVQ';     color = 'b';
    end
        
    row_idx = PARAM.plot_row4;
    if      (algo_code==1)  subplot(out_num_rows,out_num_cols,out_num_cols*row_idx+1);     
    elseif  (algo_code==2)  subplot(out_num_rows,out_num_cols,out_num_cols*row_idx+2);    
    elseif  (algo_code==3)  subplot(out_num_rows,out_num_cols,out_num_cols*row_idx+3);    
    elseif  (algo_code==4)  subplot(out_num_rows,out_num_cols,out_num_cols*row_idx+4);    
    end
          
    [numaffine_1x6, Np] = size(PFcandidates_6xNp);
    
    
    imagesc (I);
    set(gca, 'FontSize', 8);
    hold on
    
    for i=1:Np
        UTIL_drawQuadFrom6affine_1x6(sz, UTIL_2D_affine_tllpxy_to_abcdxy(PFcandidates_6xNp(:,i)), 'Color', color, 'LineWidth',1); 
    end
    
    UTIL_makeTitle([str ', PF candidates'], color, PARAM.plot_title_fontsz);
    axis equal
    axis tight
    hold off;
