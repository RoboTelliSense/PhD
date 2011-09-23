        %================================
        %INITIALIZATIONS
        %================================
            %directories
            %-----------
                

            %filenames
            %---------
             [  cfn_I        ...
                cfn_dcbk_fm1 ...
                cfn_dcbk_f   ...
                cfn_nsr      ...
                cfn_stg      ...
                cfn_soc      ...
                cfn_lhood]                      =   RVQ_3_createFileNames(odir, dir_I, ext_I, f);
                
            %thresholds
            %----------
                gamma_SNR                       =   gamma_SNRfrac*SNR_max;
%!!attention: which of the two given should be used? !!                 
                gamma_stg                       =   T;                                          
                                                    %ALTERNATE
                                                    %stghist                            =   hist(double(Istg(:)), [1:T]);      
                                                    %                                       title('histogram of number of stages for all snippet reconstructions'); 
                                                    %[numValues, maxStagesUsed]         =   max(stghist);
                                                    %gamma_stg                         =   maxStagesUsed + stg_threshold_adder;
                                                    
%!!attention: is there a way not to have such a heuristic threshold? !!
                gamma_lglik                     =   -10;

            %dimensions
            %----------
                [IiN, Iiw, Iih]                 =   RVQ_UTIL_computeInnerPixels      (Iw, Ih, sw, sh); 
                sw_half                         =   (sw-1)/2;
                sh_half                         =   (sh-1)/2;

            %buffers
            %-------
%!!attention: is there a way not to have such a heuristic threshold? !!           
                LgLIK_thresholded               =   -200*ones(Iih, Iiw, 3);
                
            %images
            %------
                Ii                              =   RVQ_UTIL_output_centeredImage  (cfn_I, sw, sh);
                
            %strings
            %-------
                titlestr_f                      =   num2str(f);
                titlestr_M                      =   num2str(M);        
                titlestr_Nsx                    =   num2str(N_sx);
                titlestr_Nsy                    =   num2str(N_sy);
                titlestrs_Nict                  =   num2str(N_ict);
                
        %================================
        %TRAINING FILES
        %================================                
            %read
            %----
            if exist(cfn_dcbk_fm1,'file')  %if codebook at fm1 exists
                CB_fm1                     =   RVQ_FILES_read_dcbk_file                (cfn_dcbk_fm1, M, T, sw, sh);
                CB_fm1                     =   RVQ_FILES_scaleCodebooks                (CB_fm1, scalingType);
                CBimg_fm1                  =   RVQ_3_create_image_from_codebooks   (CB_fm1,     M, T, sw, sh);                    
                                     
            else
                CBimg_fm1                      =   zeros(Iih, Iiw, 3);
            end
                    
               
        %================================
        %TEST FILES
        %================================
        [x_temp, y_temp]    =   UTIL_ROI_convert_outer_to_inner_coordinates(CX(f_idx)-(sw-1)/2, CY(f_idx)-(sh-1)/2, sw, sh);
        R_tgt               =   [x_temp y_temp sw sh];
        
        [x_temp, y_temp]    =   UTIL_ROI_convert_outer_to_inner_coordinates(CX(f_idx)-(ww-1)/2, CY(f_idx)-(wh-1)/2, sw, sh);
        W                   =   [x_temp y_temp ww wh];
        
        
if (bGenerateSNRstg)                
            %read
            %----
%!!attention: snr file, dB or not?  how to invert so that red color shows high magnitude?!!      

                if exist(cfn_nsr,'file')     Isnr                        =   RVQ_3_read_snr_file(cfn_nsr, Iw, Ih, sw, sh);
                else                         Isnr                        =   zeros(Iih, Iiw);
                end
               
                if exist(cfn_stg,'file')     Istg                        =   RVQ_FILES_read_stg_file(cfn_stg, Iw, Ih, sw, sh, T);%NOTE: correction has been applied, stages should now go from 1:T rather than 1:T+1
                else                        Istg                         =   zeros(Iih, Iiw);
                end
                
                if exist(cfn_lhood,'file')   Ilglik                      =   dlmread(cfn_lhood);
                else                         Ilglik                      =   zeros(Iih, Iiw);
                end
                       
            %apply thersholds
            %----------------
                thresholded_SNRSTG              =   RVQ_FILES_threshold_SNRandSTG(Isnr, Istg, gamma_SNR, gamma_stg);  %thresholded_SNRSTG = medfilt2(thresholded_SNRSTG(:,:,1), [3,3]);
                
            %get global max values
            %---------------------
                Nbest                           =   7;
                %[r1, c1, maxvalues]             =   UTIL_ROI_getBestValuesInROI (thresholded_SNRSTG(:,:,1), 1, Iiw, 1, Iih, true);
                [r1, c1, maxvalues]             =   UTIL_ROI_getBestValuesInRect(thresholded_SNRSTG(:,:,1), [1 1 Iiw Iih], true);
                r1                              =   r1(1:7);
                c1                              =   c1(1:7);
                

            %compute threshold for log likelihood
            %-------------------------------------
                %h_hist2            =   figure;                    ;         
                %llhist             =   hist(double(Ilglik(:)));      %correction has been applied, stages should now go from 1:T rather than 1:T+1
                %[numValues,maxLLUsed] = max(llhist);



            %apply thresholds on log likelihoods
            %-----------------------------------
                for r = 1:Iih
                    for c = 1:Iiw
                        if (Ilglik(r,c)>=gamma_lglik)
                            LgLIK_thresholded(r,c,1) = Ilglik(r,c);
                            LgLIK_thresholded(r,c,2) = Ilglik(r,c);
                            LgLIK_thresholded(r,c,3) = Ilglik(r,c);
                        end
                    end
                end
    %             
                b=LgLIK_thresholded(:,:,1);
                b=b';
                [maxvalues indeces] = sort(b(:), 'descend');
                for i=1:7
                    r2(i) = idivide(indeces(i), uint32(Iiw), 'floor')+1;
                    c2(i) = mod(indeces(i), uint32(Iiw));            
                end


                                                %save (to text file)
                                                %-------------------
                                                    %if strcmp(ext, '.cor')
                                                    %    dlmwrite([filename '.csv'], inp, 'precision', '%5.2f');
                                                    %elseif strcmp(ext, '.stg')
                                                    %    dlmwrite([filename '.csv'], inp, 'precision', '%3d');
                                                    %end

end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %PLOTS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                w       =   0.2;
                h       =   w;

                x_1      =   0.05;
                x_2      =   0.4;
                x_3      =   0.75;

                y_1     =   0.65;
                y_2     =   0.35;
                y_3     =   0.05;
                

                
                
                %codebooks
if (bPlotCodebooks)                
                axes('position',[x_1  y_1  w  w]);
                imagesc(uint8(CBimg_fm1));
                %txt = {'codebooks from frame f-1';['made from last ' num2str(N_ict) ' frame(s)']};
                if      (scalingType == 0)      txt = {'codebook from previous frame';'no scaling'};
                elseif  (scalingType == 1)      txt = {'codebook from previous frame';'same scaling for whole codebook'};
                elseif  (scalingType == 2)      txt = {'codebook from previous frame';'one scaling for one stage'};
                elseif  (scalingType == 3)      txt = {'codebook from previous frame';'each codevector scaled separately'};
                end
                
                set(gca,'XTick',[1 sw])
                set(gca,'YTick',[1 sh])
                set(gca, 'FontSize', 8);
                title(txt);
                axis equal
%                 XTickLabel_start = (idivide(472,int32(10))+1)*10;
%                 XTick_start = 10 - mod(fI,10);
%                 
%                 axes('position',[x_1  y_3  w  w]);
%                 set(gca, 'FontSize', 8);
%                 plot(d_cb_f_trg);
%                 %axis([1 Nf 100 200]);
%                 axis([1 Nf 0 200]);
%                 grid;
%                 set(gca, 'XTick', [XTick_start:20:Nf]);
%                 set(gca, 'XTickLabel', [XTickLabel_start:20:fF]);
%                 title('codebook distance f-1, f_{trg}') %title('d_{cb_{f\_{f-1}}}');
%                 
%                 axes('position',[x_2  y_3  w  w]);
%                 set(gca, 'FontSize', 8);
%                 plot(d_cb_f_fm1);
%                 %axis([1 Nf 100 200]);
%                 axis([1 Nf 0 200]);
%                 grid;
%                 set(gca, 'XTick', [XTick_start:20:Nf]);
%                 set(gca, 'XTickLabel', [XTickLabel_start:20:fF]);
%                 title('codebook distance f-1, f-2');
                
                
end

if (bGenerateSNRstg)
                Ii              =   UTIL_create_3ch_if_1ch(Ii);
    
                % %reconstruction SNR
                axes('position',[x_2  y_1  w  w]);
                colormap('jet')
                plane           =   0.5*ones(Iih,Iiw);
                img_ud(:,:,1)   =   flipud(Ii(:,:,1));
                img_ud(:,:,2)   =   flipud(Ii(:,:,2));
                img_ud(:,:,3)   =   flipud(Ii(:,:,3));
                surface(plane,img_ud,'FaceColor','texturemap','EdgeColor','none','CDataMapping','direct')
                view(0,10)
                hold on
                mesh(double(flipud(Isnr)))
                g=imagesc(Isnr);          
%                 h_cb=colorbar('North');
%                 axis equal;
%                 axis([0 Iiw 0 Iih]);   
%                 caxis([0 255])
%                 pos = get(h_cb, 'Position');
%                 set(h_cb, 'Position', [pos(1) pos(2)+0.12 pos(3)
%                 pos(4)]);
                set(g, 'AlphaData', 0.5);
                grid
                %xlabel('x')
                %ylabel('y')
                %view(15,70)
                view(22,48)

                
                caxis([0 255])
                axis([0 Iiw 0 Iih 0 255]);
                title('reconstruction SNR')


                %stages
                axes('position',[x_3  y_1  w  w]);
                set(gca, 'FontSize', 8);
                imagesc(Istg);
                h_cb=colorbar('North');
                axis equal;
                axis([0 Iiw 0 Iih]);   
                caxis([1 8])
                pos = get(h_cb, 'Position');
                set(h_cb, 'Position', [pos(1) pos(2)+0.12 pos(3) pos(4)]);
                title('reconstruction stages  for monotonic SNR increase');
%                 %likelihood
                                                %                 axes('position',[x_3  y_1  w  w]);
                                                %                 set(gca, 'FontSize', 8);
                                                %                 imagesc(Ilglik);
                                                %                 h_cb=colorbar('North')
                                                %                 axis equal;
                                                %                 axis([0 Iiw 0 Iih]);   
                                                %                 caxis([-50 0])
                                                %                 pos = get(h_cb, 'Position');
                                                %                 set(h_cb, 'Position', [pos(1) pos(2)+0.12 pos(3) pos(4)]);
                                                %                 title('log likelihood');


                                                


                %thresholded stages + SNR
                axes('position',[x_1  y_2  w  w]);
                set(gca, 'FontSize', 8);
                iptsetpref('ImshowAxesVisible', 'on');
                imagesc(Ii);
                axis equal;
                axis([0 Iiw 0 Iih]);
                hold on;                    
                g=imagesc(uint8(thresholded_SNRSTG));
                rectangle('Position', [c1(7)-sw_half r1(7)-sh_half  sw sh], 'EdgeColor', 'black', 'LineWidth', 0.25)
                rectangle('Position', [c1(6)-sw_half r1(6)-sh_half  sw sh], 'EdgeColor', 'yellow', 'LineWidth', 0.25)
                rectangle('Position', [c1(5)-sw_half r1(5)-sh_half  sw sh], 'EdgeColor', 'magenta', 'LineWidth', 0.25)
                rectangle('Position', [c1(4)-sw_half r1(4)-sh_half  sw sh], 'EdgeColor', 'cyan', 'LineWidth', 0.25)
                rectangle('Position', [c1(3)-sw_half r1(3)-sh_half  sw sh], 'EdgeColor', 'blue', 'LineWidth', 0.25)
                rectangle('Position', [c1(2)-sw_half r1(2)-sh_half  sw sh], 'EdgeColor', 'green', 'LineWidth', 0.25)
                rectangle('Position', [c1(1)-sw_half r1(1)-sh_half  sw sh], 'EdgeColor', 'red', 'LineWidth', 0.25)%[1 0 0]            
                hold off
                set(g, 'AlphaData', 0.5);            
                axis equal;
                axis([0 Iiw 0 Iih]);
                title({['stages = ' num2str(gamma_stg), ', SNR \geq ' num2str(gamma_SNRfrac) '*max=' num2str(gamma_SNR)];'top 7 global matches: RGBCMYK'});

                                            %                 %thresholded ll
                                            %                 axes('position',[x_3  y_2  w  w]);
                                            %                 set(gca, 'FontSize', 8);
                                            %                 iptsetpref('ImshowAxesVisible', 'on');
                                            %                 imagesc(Ii);
                                            %                 axis equal;
                                            %                 axis([0 Iiw 0 Iih]);
                                            %                 hold on;                    
                                            %                 g=imagesc(uint8(LgLIK_thresholded+70));
                                            %                 rectangle('Position', [c2(7)-sw_half r2(7)-sh_half  sw sh], 'EdgeColor', 'black', 'LineWidth', 0.25)
                                            %                 rectangle('Position', [c2(6)-sw_half r2(6)-sh_half  sw sh], 'EdgeColor', 'yellow', 'LineWidth', 0.25)
                                            %                 rectangle('Position', [c2(5)-sw_half r2(5)-sh_half  sw sh], 'EdgeColor', 'magenta', 'LineWidth', 0.25)
                                            %                 rectangle('Position', [c2(4)-sw_half r2(4)-sh_half  sw sh], 'EdgeColor', 'cyan', 'LineWidth', 0.25)
                                            %                 rectangle('Position', [c2(3)-sw_half r2(3)-sh_half  sw sh], 'EdgeColor', 'blue', 'LineWidth', 0.25)
                                            %                 rectangle('Position', [c2(2)-sw_half r2(2)-sh_half  sw sh], 'EdgeColor', 'green', 'LineWidth', 0.25)
                                            %                 rectangle('Position', [c2(1)-sw_half r2(1)-sh_half  sw sh], 'EdgeColor', 'red', 'LineWidth', 0.25)%[1 0 0]            
                                            %                 hold off
                                            %                 set(g, 'AlphaData', 0.8);            
                                            %                 axis equal;
                                            %                 axis([0 Iiw 0 Iih]);
                                            %                 title({'thresholded log likelihood.';'top 7 global matches: RGBCMYK'});
                                            
                %result
                axes('position',[x_2  y_2  w  w]);
                set(gca, 'FontSize', 8);
                iptsetpref('ImshowAxesVisible', 'on');
                imagesc(Ii);
                hold on;
                rectangle('Position', R_tgt, 'EdgeColor', 'r');
                rectangle('Position', W, 'EdgeColor', [1 1 0]);
                hold off;
                axis equal;
                axis([0 Iiw 0 Iih]);
                txt = {'RESULT';['(yellow box is ' num2str(ww) ' x ' num2str(wh) ' search window)']};
                title(txt);


                

end                


                

                UTIL_suptitle(['RVQ tracking' ', MxT=' titlestr_M 'x' num2str(T) ', [s_w,s_h,N_{sx},N_{sy},s_{dx},s_{dy}]= [' num2str(sw) ',' num2str(sh) ',' titlestr_Nsx ',' titlestr_Nsy ',1,1]' ', N_{ict}= '  , titlestrs_Nict ', w_w x w_h=' num2str(ww) 'x' num2str(wh) ', f=' titlestr_f])            

        %-----------------------------------------------------------------
        %save results to file
        %-----------------------------------------------------------------
                if (bSave)                
                    %UTIL_FILE_save2pdf(['Exp_PETS2001_results_RVQ_FN-'         titlestr_f '.pdf'],      h,     600) ; 
                    %saveas(h, [odir 'trk_RVQ_PETS2001_' UTIL_GetZeroPrefixedFileNumber(f_idx) '.jpg']) ; 

                    %print('-djpeg', '-r300', [odir 'trk_RVQ_PETS2001_' UTIL_GetZeroPrefixedFileNumber(f_idx) '.jpg']) ; 
                    print('-djpeg', '-r200', cfn_out) ;         %default is 72, -r250 produces 2000x1500 images
                                                                %-r225 produces 1800x1350, i.e scaling is 8x6                                        
                                                                %-r220 produces 1760x1320, 
                                                                %-r200 produces 1600x1200, pretty good 
                                                                %a box of 1920x1920 for quicktime will be good
                                                                %also, how big you make this makes no difference on output: 
                                                                %set(h_fig, 'Position', [0   100 1280 960]) 
                                                            


                end
                  
                                
                                
        
        
    %Z2=Z1(20-5:20+5, 25-5:25+5);
    %sum(sum(Z2))/121
    
    %PSNR        =   funcComputePSNR(inp);
    %max_psnr    =   max(PSNR);
    %avg_mse     =   sum(inp)/numPixels;
    %mid_pt      =   uint16(length(PSNR)/2);
    %avg_psnr    =   sum(PSNR(mid_pt-5:mid_pt+5))/11;    