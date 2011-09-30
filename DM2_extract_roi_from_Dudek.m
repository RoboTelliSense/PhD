function [DM2,sw,sh] =  DM2_extract_roi_from_Dudek(start, stop, bRandomize)

    load Dudek;
    
    %position of ground truth feature points on canonical box (a box
    %centered around origin that is sh x sw), this should not change for dudek 
    fp_gt_can_2xG           =   [-11.0275    0.2407   11.4563   -6.2122    0.5895    8.2183    0.6912; ...
                                  -3.9535   -4.7745   -3.6580    9.0161    8.0800    8.2949   12.8408 ];                                
    [temp1 G]               =   size(fp_gt_can_2xG);                         
    sw                      =   33;
    sh                      =   33;
    
    idx=0;
    for f=start:stop
        %input
        I_ui8               =   data(:,:,f);
        fp_gt_roi_2xG       =   truepts(:,:,f);

        %output
        idx                 =   idx+1;   
        Iroi_shxsw          =   UTIL_2D_affine_extractROI_using_fp(I_ui8, sw, sh, fp_gt_roi_2xG, fp_gt_can_2xG, bRandomize);
        DM2(:,idx)          =   Iroi_shxsw(:);
        f;
    end

    % figure;
    % f=546
    % imshow(data(:,:,f))
    % hold on;
    % x=truepts(1,:,f)
    % y=truepts(2,:,f)
    % plot(x,y, 'o')
    % impixelinfo
    % title(num2str(f))

    