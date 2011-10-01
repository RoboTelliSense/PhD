%-----------------------------------
%INITIALIZATIONS
%-----------------------------------


    clear;
    clc;
    close all;

    iw                      =   640;
    ih                      =   480;
    sw                      =   11;
    sh                      =   41;
    inner_image_dims        =   RVQ_UTIL_computeInnerPixels2(iw, ih, sw, sh);
    
    RVQ.in_3__maxQ               =   8;                                          %number of stages  
    RVQ.in_4__M___                  =   2;                                          %number of codevectors/stage
    RVQ.in_5__tSNR          =   1000;
    RVQ.in_6__sw__                 =   sw;                                         %snippet width
    RVQ.in_7__sh__                 =   sh;                                         %snippet height
    RVQ.odir            =   '';
    RVQ.trg_1_featr_PxN =   [];
    RVQ.tst_1_featr_PxN  =   [];

    %test image
    I                       =   imread('referenceRVQ/00472.jpg');
                                imshow(I);
    
%-----------------------------------
%PRE-PROCESSING
%-----------------------------------
        
    [RVQ.P, M_check, sw_check, sh_check, RVQ.mdl_3_CB_DxMP, RVQ.mdl_CBg_DxMP, RVQ.mdl_CBb_DxMP, RVQ.CBn_r, RVQ.CBn_g, RVQ.CBn_b]  ...
                            =   RVQ_FILES_read_dcbk_file  ('referenceRVQ\F1.dcbk'); 
    
                                DM2_show(RVQ.mdl_3_CB_DxMP, sh, sw, RVQ.P, M_check); %the snippets are wxh=11x41    

    Isnr                    =   zeros(inner_image_dims.inner_height, inner_image_dims.inner_width);
    Istg                    =   zeros(inner_image_dims.inner_height, inner_image_dims.inner_width);

    
%-----------------------------------
%PROCESSING
%-----------------------------------
                                
    y_idx                   =   1;
    for y= inner_image_dims.top_y : inner_image_dims.bottom_y
        x_idx               =   1;
        
        for x = inner_image_dims.left_x   :   inner_image_dims.right_x            
            snippet_dims    =   RVQ_UTIL_givenSnippetCenterFindDimensions(x,y, sw, sh);
            snippet         =   I(snippet_dims.top_y : snippet_dims.bottom_y, snippet_dims.left_x : snippet_dims.right_x, 1);
                                %imshow(snippet);
            RVQ            =   RVQ__2_encode(double(snippet(:)), RVQ);
            Isnr(y_idx, x_idx)  ...
                            =   RVQ.tst_4_SNRdB_1x1;
            Istg(y_idx, x_idx)  ...
                            =   RVQ.tst_6_partP_Nx1;
                                sprintf('%d %d:', x, y)
            x_idx           =   x_idx + 1;
        end
        y_idx               =   y_idx + 1;
        
    end
    
%-----------------------------------
%POST-PROCESSING
%-----------------------------------
                                figure;
                                imagesc(Isnr);
                                title('SNR (dB)');
                                impixelinfo;
                                colorbar
                                
                                figure;
                                imagesc(Istg);
                                title('Number of reconstruction stages');
                                impixelinfo;                             
                                colorbar