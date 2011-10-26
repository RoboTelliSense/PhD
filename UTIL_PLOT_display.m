function    UTIL_PLOT_display(  f, ...
                                fpt_1_truth_2xG, ...
                                fpt_2_estim_2xG, ...
                                snp_1_tsrpxy_1x6, ...
                                sh, sw, colorstr)
    
         
    [t1 G ]                 =   size(fpt_1_truth_2xG);
    alpha                   =   0;        %transparency for target bounding regions

    hold on;
    for g=1:G
    %    UTIL_PLOT_filledCircle( [fpt_1_truth_2xG(1,g), fpt_1_truth_2xG(2,g)],   3,   3000,   'y');      %yellow color
    %    UTIL_PLOT_filledCircle( [fpt_2_estim_2xG(1,g), fpt_2_estim_2xG(2,g)],   2,   3000,   colorstr); %user defined color
    end
    UTIL_2D_affine_drawQuadFrom_Ha_2x3(UTIL_2D_affine_tsrpxy_to_Ha_2x3(snp_1_tsrpxy_1x6), sh, sw, alpha, colorstr);
    axis equal;
    axis tight;
    drawnow;
    hold off;    