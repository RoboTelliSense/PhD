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
    
    sRVQ.maxP               =   8;                                          %number of stages  
    sRVQ.M                  =   2;                                          %number of codevectors/stage
    sRVQ.targetSNR          =   1000;
    sRVQ.sw                 =   sw;                                         %snippet width
    sRVQ.sh                 =   sh;                                         %snippet height
    sRVQ.dir_out            =   '';
    sRVQ.trg_XDRs_PxN =   [];
    sRVQ.tst_XDR_Px1  =   [];

    %test image
    I                       =   imread('referenceRVQ/00472.jpg');
                                imshow(I);
    
%-----------------------------------
%PRE-PROCESSING
%-----------------------------------
        
    [sRVQ.P, M_check, sw_check, sh_check, sRVQ.CB_r, sRVQ.CB_g, sRVQ.CB_b, sRVQ.CBn_r, sRVQ.CBn_g, sRVQ.CBn_b]  ...
                            =   RVQ_FILES_read_dcbk_file  ('referenceRVQ\F1.dcbk'); 
    
                                DATAMATRIX_display_DM2_as_image(sRVQ.CB_r, sh, sw, sRVQ.P, M_check); %the snippets are wxh=11x41    

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
            sRVQ            =   RVQ__testing_grayscale(double(snippet(:)), sRVQ);
            Isnr(y_idx, x_idx)  ...
                            =   sRVQ.tst_SNRdB;
            Istg(y_idx, x_idx)  ...
                            =   sRVQ.tst_partialP;
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