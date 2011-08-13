%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%USAGE
%iw   =   640;
%ih  =   480;
%sw   =   9;
%sh  =   9;
%RVQ_readExplorerFile('00000_640x480_F1.stg', iw, ih, sw, sh, 'float')
%RVQ_readExplorerFile('00000_640x480_F1.stg', iw, ih, sw, sh, 'uint8')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function I = RVQ_UTIL_output_centeredImage(I, sw, sh)
    
    %I = imread(filename);
    [ih iw, dim] = size(I);
    
    [IiN, iiw, iih] = RVQ_UTIL_computeInnerPixels(iw, ih, sw, sh);
        
    brd_width    = (sw-1)/2;     %brd: border
    brd_height   = (sh-1)/2;
    %format data
        I         =   I(brd_height+1 : ih-brd_height, ...
                        brd_width+1  : iw -brd_width,  ...
                            :);
        
        
    %save (to image)
        %h           =   figure;
        %imagesc(I);
        %axis equal
        %axis([0 iiw 0 iih]);
        %colorbar
        %UTIL_FILE_save2pdf([filename '.pdf'],h,600)

        
        
        
        
        
        
        
        
    %Z2=Z1(20-5:20+5, 25-5:25+5);
    %sum(sum(Z2))/121
    
    %PSNR        =   funcComputePSNR(inp);
    %max_psnr    =   max(PSNR);
    %avg_mse     =   sum(inp)/numPixels;
    %mid_pt      =   uint16(length(PSNR)/2);
    %avg_psnr    =   sum(PSNR(mid_pt-5:mid_pt+5))/11;    