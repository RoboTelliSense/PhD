clear;
clc;
close all;

odir     =   'test_out/';
dir_I       =   'img/Dudek/120x80/';
ext_I       =   '.png';
%iw          =   45;%240;
%ih          =   45;%160;
sw          =   5;
sh          =   5;
riw         =   1;
rih         =   1;
M           =   2;
T           =   8;
bVisualize  =   false;
bVerbose    =   false;
cx          =   9;
cy          =   9;


for cx=3:3
    for cy=3:3
        cy
        for f=1:1

                str_f               =   UTIL_GetZeroPrefixedFileNumber                       (f);
                cfn_I               =   [dir_I str_f ext_I];
                I                   =   imread(cfn_I);
                %imshow(I);
                %impixelinfo;

                Rrect               =   UTIL_ROI_computeOuterRectAroundInnerRect        (cx, cy, riw, rih, sw, sh);
                R                   =   UTIL_ROI_extractROI                             (I, Rrect);
                Ri                  =   RVQ_UTIL_output_centeredImage                      (R, sw, sh);
                Energy_R            =   sum(sum((3*(double(R).^2) + 3*(double(255-R).^2))));
                rx                  =   Rrect(1);
                ry                  =   Rrect(2);
                rw                  =   Rrect(3);
                rh                  =   Rrect(4);
                cfn_Rraw            =   [dir_I   str_f   '_' num2str(rw) 'x' num2str(rh) '.raw'];     
                                        RVQ_FILES_create_posnegImage                           (R, cfn_Rraw, false);




            %tic
            [NSR, STG]              =   RVQ_2_test           (odir, cfn_Rraw, f, rw, rh, sw, sh, M, T, bVisualize, bVerbose);
            %kk(cx) = SNR;
            %toc
            %f          
        end
    end
end