clear;
clc;
close all;

dataset_idx             =   4;
Nict                    =   1;
bTrialRuns              =   true;
bGetTargetPositionFromGT=   false;
bProcessFullImage       =   true; 
bVisualize              =   false; 
bVerbose                =   false; 
bSave                   =   true;

%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  
%
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%function RVQ_track(dataset_idx, Nict, bTrialRuns, bGetTargetPositionFromGT, bProcessFullImage, bVisualize, bVerbose, bSave)
                
    %==============================================
    %INITIALIZATIONS
    %==============================================
        %matlab
        %------
            clc;
            %close all;
            format compact;

        %paths
        %-----
            if      (ispc)   
                cd c:\salman\portable\RVQ_xplatform1;                       
                path(path, 'c:\salman\portable\Matlab_common');
            elseif  (isunix) 
                cd /cluster/users/gtg629v/salman/portable/RVQ_xplatform1;   
                path(path, '/cluster/users/gtg629v/salman/portable/Matlab_common');
            end

        %make executable on unix
        %-----------------------
            if (isunix)
                unix('chmod +x RVQ_0_concatenateSnippets.linux');
                unix('chmod +x RVQ_1a_train_gen8.linux');
                unix('chmod +x RVQ_1b_train_bnd_in.linux');
                unix('chmod +x RVQ_2_test.linux');
            end        

        %read configuration file (reads parameters for different datasets/configurations)
        %-----------------------
            if      (dataset_idx==1)        RVQ_config_PETS2001;
            elseif  (dataset_idx==2)        RVQ_config_AVSS2007;
            elseif  (dataset_idx==3)        RVQ_config_Dudek;     
            elseif  (dataset_idx==4)        RVQ_config_Dudek_120x80;     
            end

            if (bTrialRuns)
                odir_prefix  =       'test_out'; %odir_prefix is set in the config files, but this ovewwrites it
            end

        %timing parameters
        %-----------------
            T_trg = [];
            T_tst = [];

        %full name of output directory
        %-----------------------------
            if (ispc)   
                odir = [odir_prefix '\'];
            elseif (isunix) 
                odir = [odir_prefix '/'];
            end

        %filenames
        %---------
            fn_poscsv               =   'positiveExamples.csv';
            cfn_poscsv              =   [odir fn_poscsv];      %file 1, this is the only file which maintains temporal info
            cfn_poscsv_temp         =   [odir 'temp_positiveExamples.csv'];      
            cfn_out                 =   [odir 'tracks.csv'];

        %dimensions
        %----------
            [IiN, Iiw, Iih]         =   RVQ_UTIL_computeInnerPixels                          (iw, ih, sw, sh);   %inner image dimensions

        %bootsrap
        %--------
                                        UTIL_FILE_delete                                 ('test_out\positiveExamples.csv');
            if (ispc)                   UTIL_FILE_copy                                   (cfn_gt, 'test_out\positiveExamples.csv');
            elseif (isunix)             UTIL_FILE_copy                                   (cfn_gt, 'test_out/positiveExamples.csv');
            end
            CB_trg                 =   RVQ_1_Train                                     (odir, fn_poscsv, M, T, sw, sh);   
            [cix, ciy]              =   UTIL_ROI_convert_outer_to_inner_coordinates     (cx,cy, sw, sh);
            f_idx                   =   1;

    %========================================================
    %OPERATIONS (start tracking)
    %========================================================

        for f=fI : fF                                            
            str_f                   =   UTIL_GetZeroPrefixedFileNumber                       (f);
            cfn_I                   =   [dir_I str_f ext_I];
            cfn_Iraw                =   UTIL_createRawFileName                          (dir_I, f, iw, ih);
            I                       =   imread                                          (cfn_I);

            if (bProcessFullImage)
                                        tic;
                [SNR, STG]          =   RVQ_2_test                                      (odir, cfn_Iraw, f, iw, ih, sw, sh, M, T, bVisualize, bVerbose);    %system('UTIL_binaryFileCompare.exe   reference_9_00472_640x480.cor   00472.cor  ');                    
                 t_temp             =   toc;
                 T_tst              =   [T_tst t_temp];                                           

                [cix, ciy]          =   RVQ_3_getBestTargetPositionFromSNRSTG           (SNR, STG, gamma_SNR, gamma_STG, cix, ciy, riw, rih);
                [cx, cy]            =   UTIL_ROI_convert_inner_to_outer_coordinates     (cix, ciy, sw, sh);
                Trect               =   UTIL_ROI_givenCenterFindRect                    (cx, cy, sw, sh);

            else
                Rrect               =   UTIL_ROI_computeOuterRectAroundInnerRect        (cx, cy, riw, rih, sw, sh);
                R                   =   UTIL_ROI_extractROI                             (I, Rrect);
                rx                  =   Rrect(1);
                ry                  =   Rrect(2);
                rw                  =   Rrect(3);
                rh                  =   Rrect(4);
                cfn_Rraw            =   [dir_I   str_f   '_' num2str(rw) 'x' num2str(rh) '.raw'];     
                                        RVQ_FILES_create_posnegImage                           (R, cfn_Rraw, false);
                                        tic
                [SNR, STG]          =   RVQ_2_test                                      (odir, cfn_Rraw, f, rw, rh, sw, sh, M, T, bVisualize, bVerbose);    %system('UTIL_binaryFileCompare.exe   reference_9_00472_640x480.cor   00472.cor  ');                    
                tst_time            =   toc
                T_tst               =   [T_tst tst_time];
            end                

            %threshold
            SNR_thresholded         =   RVQ_FILES_threshold_SNRandSTG                       (SNR, STG, gamma_SNR, gamma_STG);                         
            bDescending             =   true;                                  %false: ascending values, i.e. pick smallest number
            [r1, c1, maxvalues]     =   UTIL_ROI_getBestValuesInRect                    (SNR_thresholded, [1 1 riw rih], bDescending);%find max in window
            best_wix                =   c1(1);%return highest value
            best_wiy                =   r1(1);    

            if (bProcessFullImage)
                [cx, cy]            =   UTIL_ROI_convert_inner_to_outer_coordinates     (cix, ciy, sw, sh);
            else
                cx                  =   (best_wix - 1) + rx + (sw-1)/2;
                cy                  =   (best_wiy - 1) + ry + (sh-1)/2;
            end

            %target info
            Trect                   =   UTIL_ROI_givenCenterFindRect                    (cx, cy, sw, sh); 
            fid_trk                 =   fopen                                           (cfn_out, 'a');
                                        UTIL_FILE_checkFileOpen                              (fid_trk, cfn_out);
                                        fprintf                                         (fid_trk, '%d,     %d, %d\n', f, cx, cy);
                                        fclose                                          (fid_trk);

            %training
                                        RVQ_0_create_positiveExamples_csv               (cfn_Iraw, cfn_poscsv, Trect, Nsx, Nsy, iw, ih, true);
                                        tic
            CB                     =   RVQ_1_Train                                     (odir, fn_poscsv, M, T, sw, sh);                 
            trg_time                =   toc
            T_trg                   =   [T_trg trg_time];
                                        RVQ_3_backupTrainingFiles                       (odir, str_f);               
            str                     =   sprintf('############################\n f = %d, target= (%d, %d)\n############################\n', f, cx, cy);
                                        disp(str);
                                                        
            %display
            figure(1);
            imshow(I);
            impixelinfo;
            %iptsetpref('ImshowAxesVisible', 'on');
            hold on;
            rectangle('Position', Trect, 'EdgeColor', 'r');
            line([Trect(1) Trect(1)+Trect(3)-1], [Trect(2) Trect(2)+Trect(4)-1], 'Color', 'r')
            line([Trect(1) Trect(1)+Trect(3)-1], [Trect(2)+Trect(4)-1 Trect(2)], 'Color', 'r')
            W = UTIL_ROI_givenCenterFindRect  (cx, cy, riw, rih);
            rectangle('Position', W, 'EdgeColor', [1 1 0]);
            hold off;
            %txt = {'RESULT';['(yellow box is ' num2str(ww) ' x ' num2str(wh) ' search window)']};
            %title(txt);
            title(str_f);
            str_fidx    =   UTIL_GetZeroPrefixedFileNumber(f_idx);
            cfn_out     =   [odir str_fidx '.jpg'];
            if (bSave)
                %tic
                %print('-djpeg', '-r200', cfn_out)
                print('-djpeg', cfn_out)
                %toc
            end

            %indeces
            f_idx = f_idx+1;   
        end

%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        
        
        
        
        
        
        
        
        
        
        
        
   %SNR_thresholded = medfilt2(SNR_thresholded(:,:,1), [3,3]);      
        
        
        
                     %A                   =   RVQ_FILES_read_idx_file         ([odir 'positiveExamples.idx'],         iw, ih, sw, sh, T, M, true);
                    %[p1,   pn]          =   RVQ_3_createCCD             (A, M, lambda);
       
        
%         
%              h                   =   [1 1 1;...      %filter
%                                      1 3 1;...
%                                      1 1 1];       
        
        
        
        
        
     %-----------------------------
    %RESULTS
    %-----------------------------
%             %RVQ outputs
%                 figure(1);imagesc(SNR);colorbar;
%                 figure(2);imagesc(STG);caxis([1 T]);colorbar;
%                 %figure(3);imagesc(B_ll);colorbar;
%                 
%             %bounding box
%                 I                   =   imread(cfn_I);
%                 Ii                  =   RVQ_UTIL_output_centeredImage(cfn_I, sw, sh);
%                 
%                 figure;
%                 imagesc(Ii);colorbar;
%                 title(num2str(f));
%                 hold on;
%                 %rectangle('Position', Wi,                                           'EdgeColor', [1 1 0 ]);
%                 rectangle('Position', RVQ_0_convertTargetCenterInOuterImageToInnerRectangle(cx, cy, sw, sh, Nsx, Nsy),   'EdgeColor', [1 0 0 ], 'FaceColor', 'r');
%                 print('-djpeg', str_f)       
        
            
%             h=[1 1 1 1 1;...
%                1 3 3 3 1;...
%                1 3 9 3 1;...
%                1 3 3 3 1;...
%                1 1 1 1 1;]

           
            
            %a = medfilt2(B_ll);
            %figure;imagesc(a);colorbar;
            
            
        %4. pick best set
            %for x=1:
        
            %caxis([-9 -4.5])
            
            
            
            
            
%                   if (mod(f_tst,Nict)==0)
%                     if      (ispc)      system(['del ' odir 'positiveExamples.csv']);
%                     elseif  (isunix)    unix(['rm ' odir 'positiveExamples.csv']);
%                     end
%                     RVQ_0_create_positiveExamples_csv(odir, tgtID, cx, cy, Nsx, Nsy, cfn_Iraw, iw, ih, false);
%                 else
%                     RVQ_0_create_positiveExamples_csv(odir, tgtID, cx, cy, Nsx, Nsy, cfn_Iraw, iw, ih, true);
%                   end
                
                  
                  
                  
            
            
%             inp_img  =   imread(cfn_Iraw);
%             imshow(inp_img);
%             hold on;
%             rectangle('Position', [cx-1 cy-1, 3, 3], 'EdgeColor', [1 0 0]);
%             rectangle('Position', BB(f1,:));
%             hold off;
%             f1=f1+1;




% for f=f1I+1:f1F
%     inp_img  =   imread([dir_I UTIL_GetZeroPrefixedFileNumber(f) '.png']);
%     imshow(inp_img);
%     hold on;
%     rectangle('Position', BB(f1,:));
%     hold off;
%     f1=f1+1;
%     pause    
%     
% end


%B_ll                =      RVQ_3_getLogLikelihoods(p1, pn, B, M, T, Iih,Iiw, odir, str_f);
% if (bGetTargetPositionFromGT) %if (bGTisComplete)
%                     for i=1:length(GT) %if you have ground truth, use it to create snippet extraction details file, if not, you should have one created manually by now
%                         f1                          =   f-f1I+1;      
%                         [tgtID, Bx,By,Bw,Bh,gx,gy]  =   RVQ_0_readGroundTruth(GT{i}, f1); %get ground truth target center
%                         [cix, ciy]                  =   RVQ_3_getBestTargetPositionFromGroundTruth(gx, gy, sw, sh);
%                     end
% 
% else
%                         [cix, ciy]                  =   RVQ_3_getBestTargetPositionFromCodebooks        (odir, cfn_Iraw, cfn_poscsv, M, T, tgtID, cx, cy, Nsx, Nsy, sw, sh, iw, ih, CB_trg, Ww, Wh, Nict);
% end



                    %if (f_idx > Nict)

%                                            RVQ_0_cleanOutOldestFrameSnippetsFromSEDfile    (cfn_poscsv, Nsx, Nsy);
                    %end
                %[cix, ciy]         =
                %RVQ_3_getBestTargetPositionFromGroundTruth(gx,gy, sw, sh);
                
                
                
                                
                
                 %system('UTIL_binaryFileCompare.exe   reference_5_gen.txt 
                 
                 
                                                             %system('UTIL_binaryFileCompare.exe   reference_5_gen.txt 
                                            %                 %CBimg_trg          =   RVQ_3_display_codebooks                     (CB_trg,          M, T, sw, sh, bViewAllCodevectorsWithSameScale);
                                            %                                         RVQ_3_backupTrainingFiles                   (odir, str_f);
                                            %                 A                   =   RVQ_FILES_read_idx_file                         ([odir 'snippets.idx'],         iw, ih, sw, sh, T, M, true);
                                            %                 [p1,   pn]          =   RVQ_3_createCCD                             (A, M, lambda);
                                            % 
                                            %             
                                            %             %2. testing
                                            %             %----------
                                            % if (bCompute_SNR_STG_SoC)
                                            %                                        RVQ_2_test               (cfn_Iraw, odir, str_f, iw, ih, sw, sh, M);     %system('UTIL_binaryFileCompare.exe   reference_9_00472_640x480.cor   00472.cor  ');
                                            %                [SNR, STG, B]       =   RVQ_3_readTestingFiles   (odir, str_f, iw, ih, sw, sh, T, M);
                                            %                B_ll                =   RVQ_3_getLogLikelihoods  (p1, pn, B, M, T, Iih, Iiw, odir, str_f);
                                            % end
                
                                            
                                                                                %delete('test_out/*.*');     %delete
                                    %all files in this directory
                                    %
                                    
        %==============================================
        %TRACKING FRAME 1
        %==============================================
            %0. setup
            %--------
                %a. frame number
%                 f_idx                =   1;
%                 f1                  =   f-f1I+1; %frame index, it is 1 when target 1 enters frame, i.e. when f=f1I 
%                 str_f               =   UTIL_GetZeroPrefixedFileNumber(f);
%                 cfn_Iraw            =   UTIL_createRawFileName(dir_I, f, iw, ih)%raw image name

            %1. training
            %-----------   
%                                             UTIL_FILE_delete(cfn_poscsv_temp);
%                                             UTIL_FILE_delete(cfn_poscsv);
                            %                 for i=1:length(GT) %if you have ground truth, use it to create snippet extraction details file, if not, you should have one created manually by now
                            %                     [tgtID, Bx,By,Bw,Bh,gx,gy] =    RVQ_0_readGroundTruth(GT{i}, f1); %get ground truth target center
                            %                     if (i==1)
                            %                                                     RVQ_0_create_positiveExamples_csv    (cfn_Iraw, cfn_poscsv, tgtID, gx, gy, Nsx, Nsy, iw, ih, false);
                            %                     else
                            %                                                     RVQ_0_create_positiveExamples_csv    (cfn_Iraw, cfn_poscsv, tgtID, gx, gy, Nsx, Nsy, iw, ih, true);
                            %                     end
                            %                 end
                                                                