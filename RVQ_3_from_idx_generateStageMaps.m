%usage
%RVQ_generateStageMaps(8, 2, 640, 480, 11, 41);
function RVQ_3_generateStageMaps(T, M, Uw, Uh, sw, sh)

    %----------------
    %INITIALIZATIONS
    %----------------

            S{1}=[];
            S{2}=[];
            S{3}=[];
            S{4}=[];
            S{5}=[];
            S{6}=[];
            S{7}=[];
            S{8}=[];



            [total_inner_pixels, Iiw, Iih]  =   RVQ_UTIL_computeInnerPixels(Uw, Uh, sw, sh);
            imginp_inner                    =   RVQ_output_1_centeredImage('C:\salman\work\software\RVQ\Data Warehouses\PETS2001\00472.jpg', sw, sh);
            B                               =   RVQ_read_IDX('C:\salman\work\software\RVQ\Data Warehouses\PETS2001\STT1\00472_640x480_F1.idx', T, M, false, Iiw, Iih);

    %----------------
    %OPERATIONS
    %----------------
            
        %create one image for every stage
            i=1;
            for y=1:Iih
                y
                for x=1:Iiw     
                    for t=1:T
                        temp                =   B(i,t);                              
                        S{t}(y,x)         =   temp; 
                    end
                    i                                           =   i+1;
                end
            end  
            
    %----------------
    %RESULTS
    %----------------
        %stage maps
            for t=1:T

                h2=subplot(4,2,t);
                iptsetpref('ImshowAxesVisible', 'on');
                imagesc(imginp_inner);
                axis equal;
                axis([0 Iiw 0 Iih]);
                hold on;

                g=imagesc(S{t});
                hold off
                set(g, 'AlphaData', 0.8);
                axis equal;
                axis([0 Iiw 0 Iih]);
                title(['stage ' num2str(t)]);

                j=colorbar;
                set(j, 'YLim',  [1 3]);
                caxis([1 3]);
            end  
            suptitle('RVQ (2x8), SNIPPETS (3x3, w,h=11x41), EARLY TERMINATION (M=3)');

            
        %histograms
        %----------
            
            figure;
            for t=1:T
                h2=subplot(4,2,t);
                title(['stage ' num2str(t)]);
                hist(S{t}(:))
                axis([1 3 0 4*10^5])
                title(['stage ' num2str(t)]);
            end
                              
                  