    close all;
    clc;
    
    %---------------
    %INITIALIZATIONS
    %---------------
        %rectangle('Position', TGT, 'EdgeColor', [1 0 0 ])

        area_positive_region    =   double(TGT(3)*TGT(4));
        area_negative_region    =   (Uih*Uiw) - area_positive_region;
        gamma                   =   9;
        clear HR;
        clear FAR;
        clear FP_2_est;
        clear TN;
        clear TP;
        clear FN;
        
    %---------------
    %OPERATIONS
    %---------------
            jjj=1;
                        
            for (thresh = -9:0.1:-0.4)

                %apply threshold
                J=uint8(zeros(Uih, Uiw,3));
                for y=1:Uih
                    y;
                    for x=1:Uiw
                        if (U_soc(y,x) > thresh)
                            J(y,x,1)=255;
                            J(y,x,2)=255;
                            J(y,x,3)=255;
                        end
                    end
                end
                %figure;imshow(J);
                %count positives in all regions
                cnt_all_positives=0;
                for x=1:Uiw
                    for y=1:Uih
                        if (J(y,x,1) == 255)
                            cnt_all_positives  = cnt_all_positives + 1;  %count total positives (i.e. in whole image)
                        end
                    end
                end
                
                %count positives in positive region (i.e. in BB)
                cnt_positives_in_positive_region=0;
                for x=TGT(1):TGT(1) + TGT(3)
                    for y=TGT(2):TGT(2) + TGT(4)
                        if (J(y,x,1) == 255)
                            cnt_positives_in_positive_region= cnt_positives_in_positive_region + 1;
                        end
                    end
                end                

                if (cnt_positives_in_positive_region > gamma)
                    TP = gamma;
                    FN = 0;
                else
                    TP = cnt_positives_in_positive_region;
                    FN = gamma - cnt_positives_in_positive_region;
                end
                
                                
                %3. FP_2_est, TN 
                FP_2_est = cnt_all_positives - cnt_positives_in_positive_region; %get ones outside BB)                
                TN = area_negative_region - FP_2_est;
                


                HR(jjj) = TP/(TP+FN);
                FAR(jjj) = FP_2_est/(FP_2_est+TN);
                jjj = jjj+1;
                thresh
            end

            stem(FAR, HR)




                
                %cnt_pos_true = TP;
                %if (cnt_pos_true > TP)
                %    cnt_pos_true = TP
                %end
                
                %TN
                


                %HR = TP/cnt_all_positives
                %if (TP>=1)
                %    HR(jjj)=1;
                %else
                %    HR(jjj)=0;
                %end

                %if (cnt_all_positives >0)
                %    FAR(jjj) = (cnt_all_positives - TP)/cnt_all_positives
                %else
                %    FAR(jjj) = 0;
                %end

%extra=40;
%window = uint16([TGT(1)-extra    TGT(2)-extra    TGT(3)+2*extra    TGT(4)+2*extra]);
%rectangle('Position', window, 'EdgeColor', [0 1 0 ])



% 
% 
% figure;hist(I(:))
% 
%     
%        
%        figure;
%        colormap('jet')
%                                          
%        h2=subplot(1,2,2);
%         imginp_inner    =   RVQ_output_1_centeredImage('C:\salman\work\software\RVQ\Data Warehouses\PETS2001\00472.jpg', sw, sh);
% 
%             
%             
%         iptsetpref('ImshowAxesVisible', 'on');
%         imagesc(imginp_inner);
%                                          axis equal;
%                                          axis([0 Uiw 0 Uih]);
%                                          hold on;
%                       
%                                          changex=0.12
%                                          changey = changex*Uiw/Uih
%             g=imshow(J);
%             hold off
%             set(g, 'AlphaData', 0.8);
%             axis equal;
%             axis([0 Uiw 0 Uih]);
%             title('log likelihood thresholded > -5.5');
% 
%             
%             
%             
%             
%             
%                    h1=subplot(1,2,1);
%                    pos1 = get(h1);
%                 pos2 = get(h2);
%                 set(h1, 'Position', [pos1.Position(1)-changex/2 pos1.Position(2)-changey/2 pos2.Position(3)+changex pos2.Position(4)+changey]);       
%                imagesc(I)
%         axis equal;
%         axis([0 Uiw 0 Uih]);
%         title('log likelihood');
% 
%         colorbar 

