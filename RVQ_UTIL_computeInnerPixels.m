function [total_inner_pixels, inner_width, inner_height] = RVQ_UTIL_computeInnerPixels(img_width, img_height, snp_width, snp_height)
 
    numPixels                   =   img_width*img_height;
    horizontal_border_pixels    =   2*img_width*(snp_height-1)/2;
    vertical_border_pixels      =   2 * (img_height - 2*(snp_height-1)/2) * (snp_width-1)/2;
    total_border_pixels         =   horizontal_border_pixels + vertical_border_pixels;
    total_inner_pixels          =   numPixels - total_border_pixels;
    
    inner_width                 =   img_width-(snp_width-1);
    inner_height                =   img_height-(snp_height-1);
    total_inner_pixels2         =   inner_width * inner_height;  %should be equal to total_inner_pixels