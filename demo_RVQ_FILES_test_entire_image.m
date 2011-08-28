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
    
    RVQ.maxP               =   8;                                          %number of stages  
    RVQ.M                  =   2;                                          %number of codevectors/stage
    RVQ.targetSNR          =   1000;
    RVQ.sw                 =   sw;                                         %snippet width
    RVQ.sh                 =   sh;                                         %snippet height
    RVQ.dir_out            =   '';
    RVQ.trg_1_descriptors_PxN =   [];
    RVQ.tst_1_descriptor_Px1  =   [];

    %test image
    I                       =   imread('referenceRVQ/00472.jpg');
                                imshow(I);
    
%-----------------------------------
%PRE-PROCESSING
%-----------------------------------
        
    [RVQ.P, M_check, sw_check, sh_check, RVQ.mdl_2_CB_DxMP, RVQ.mdl_CBg_DxMP, RVQ.mdl_CBb_DxMP, RVQ.CBn_r, RVQ.CBn_g, RVQ.CBn_b]  ...
                            =   RVQ_FILES_read_dcbk_file  ('referenceRVQ\F1.dcbk'); 
    
                                DATAMATRIX_display_DM2_as_image(RVQ.mdl_2_CB_DxMP, sh, sw, RVQ.P, M_check); %the snippets are wxh=11x41    

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
            RVQ            =   RVQ__testing_grayscale(double(snippet(:)), RVQ);
            Isnr(y_idx, x_idx)  ...
                            =   RVQ.tst_4_SNRdB;
            Istg(y_idx, x_idx)  ...
                            =   RVQ.tst_6_partialP;
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