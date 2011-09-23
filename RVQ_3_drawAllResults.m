function RVQ_3_drawAllResults(bCompute, bUseMyPCA, bUseRVQ, bUseTSVQ, datasetCode)
 %clear;
 %clc;
 %close all;

% if (ispc)
%     setenv('MAGICK_HOME', 'C:\Program Files\ImageMagick-6.6.8-Q16')
%     setenv('MAGICK_HOME', 'C:\Progra~1\ImageMag~1')
% elseif (isunix)
%     setenv('MAGICK_HOME', '/cluster/users/gtg629v/salman/portable/RVQ_xplatform1/imagemagick/ImageMagick-6.6.8-9');
% end
ridx = datasetCode;


iptsetpref('ImshowAxesVisible', 'off');

ext_I                   =   '.png';

%global
%R                       =   [1,2,3,4,5,6,7];
R_names                 =   {'Dudek', 'davidin300', 'sylv', 'trellis70', 'fish', 'car4', 'car11'}
sw                      =   33;
sh                      =   33;

%RVQ
M_rvq                   =   [2, 4, 8, 16];
Tmax_rvq                =   [8, 16];                
Nict                    =   -1;
if (Nict == -1)
    str_Nict            =   'all'
else
     str_Nict           =   num2str(Nict);
end

%PCA
pca_maxBasis            =   16;

%particle filter
Np                      =   600;
%RVQaffine_1x6         =   [];
%PCAaffine_1x6         =   [];

                h           =   figure;
                w         =   0.2;
                diff      =   0.22;
                x(1)      =   0.05;
                x(2)      =   x(1) + diff;
                x(3)      =   x(2) + diff;
                x(4)      =   x(3) + diff;

                
                y(1)     =   0.65;
                y(2)     =   0.35;

                
                
%for ridx = 1:length(R)
%for ridx = 1:7
    %r                   =   R(ridx)
    txt1                =   num2str(ridx);
    txt2                =   R_names{ridx}; 
    odir             =   ['results_summary_' txt2];
    odir = UTIL_addSlash(odir);
                            mkdir(odir);
                            load(txt2);
                            
                            
                if (bCompute)
                    for tidx = 1:length(Tmax_rvq)
                        t = Tmax_rvq(tidx);

                        for midx = 1:length(M_rvq)
                            m                                           =   M_rvq(midx);
                            dir_in                                      =   ['results_' txt1 '_maxT_' num2str(t) '_M_' num2str(m) '_Np_' num2str(Np) '_Nict_' num2str(Nict) '_PCA_' num2str(pca_maxBasis) '_' txt2];
                            dir_in                                      =   UTIL_addSlash(dir_in)    ;
                            cfn_PCAaffine_1x6                         =   [dir_in 'PCAaffine.csv'];
                            cfn_RVQaffine_1x6                         =   [dir_in 'RVQaffine.csv'];
                            cfn_myPCAaffine_1x6                       =   [dir_in 'PCAaffine.csv'];
                            cfn_TSVQaffine_1x6                        =   [dir_in 'PCAaffine.csv'];
                            PCAaffine_1x6{tidx}{midx}                 =   csvread(cfn_PCAaffine_1x6);
                            if (bUseMyPCA) RVQaffine_1x6{tidx}{midx}  =   csvread(cfn_myPCAaffine_1x6); end
                            if (bUseRVQ) RVQaffine_1x6{tidx}{midx}    =   csvread(cfn_RVQaffine_1x6); end
                            if (bUseTSVQ) RVQaffine_1x6{tidx}{midx}   =   csvread(cfn_TSVQaffine_1x6); end
                            [F(ridx), temp]                             =   size(PCAaffine_1x6{1}{1});
                        end
                    end


                    for f=1:F(ridx)
                        I                                   =   data(:,:,f);
                        I3c(:,:,1)                          =   I;
                        I3c(:,:,2)                          =   I;
                        I3c(:,:,3)                          =   I;
                        for tidx = 1:length(Tmax_rvq)
                            t = Tmax_rvq(tidx);

                            for midx = 1:length(M_rvq)
                                m                           =   M_rvq(midx);
                                                                axes('position',[x(midx)  y(tidx)  w  w]);

                                dir_in                     =   ['results_' txt1 '_maxT_' num2str(t) '_M_' num2str(m) '_Np_' num2str(Np) '_Nict_' num2str(Nict) '_PCA_' num2str(pca_maxBasis) '_' txt2 '\'];
                                str_f                       =   UTIL_GetZeroPrefixedFileNumber(f);


                                                              imagesc(uint8(I3c));
                                                              set(gca, 'XTickLabel', [])
                                                              set(gca, 'YTickLabel', [])
                                                                hold on;
                                                                drawbox([sh sw], PCAaffine_1x6{tidx}{midx}(f, 2:7), 'Color','r', 'LineWidth',1);
                                                                drawbox([sh sw], RVQaffine_1x6{tidx}{midx}(f, 2:7), 'Color','g', 'LineWidth',1);
                                                                hold off; 
                                                                title(['\color[rgb]{0.0 .7 0}' num2str(m) 'x' num2str(t)]);
                                                                drawnow

                            end
                        end
                        UTIL_suptitle([ '\color{black}'         'sequence:'             txt2                    ', ' ...
                                                                'f='                    num2str(f)              ', ' ...
                                                                's_w='                  num2str(sw)             ', ' ...
                                                                's_h='                  num2str(sh)             ', ' ...
                                        '\color{black}'         'particles (N_p)='      num2str(Np)             ', '...               
                                        '\color[rgb]{0.0 .7 0}' 'MxT RVQ: N_{ict}='     str_Nict                ', '...
                                        '\color{red}'           'PCA: N_{eig}='         num2str(pca_maxBasis)   ...
                                      ], 9);
                                  %pause
                        cfn_out_pdf     =   [odir str_f '.pdf'];
                        cfn_out_jpg     =   [odir str_f '.jpg'];
                        cfn_out_png     =   [odir str_f '.png'];

                        if (ispc)
                            %print('-djpeg', '-r150', cfn_out_jpg);
                            print('-dpng', '-r150', cfn_out_png);
                        elseif (isunix)
                            UTIL_FILE_save2pdf(cfn_out_pdf,      h,     300) ;
                            %print('-dpdf', '-r300', cfn_out_pdf) ;
                            unix(['gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=jpeg -r150 -sOutputFile=' cfn_out_jpg ' ' cfn_out_pdf])
                            %unix(['gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -r150 -sOutputFile=' cfn_out_png ' ' cfn_out_pdf])
                            close all;
                        end
                    end
                end
    
    
    
    
    if (ispc)
        system(['c:\salman_programs\ffmpeg -r 5 -i '  odir '%05d.jpg -vcodec mpeg4 -qscale 1 -y ' odir  'results_' num2str(ridx) '_' txt2 '.mp4']);
    elseif (isunix)
        %unix('setenv LD_LIBRARY_PATH "/cluster/users/gtg629v/salman/portable/RVQ_xplatform1/ffmpeg/ffmpeg-0.6.2/libavformat;/cluster/users/gtg629v/salman/portable/RVQ_xplatform1/ffmpeg/ffmpeg-0.6.2/libavdevice;/cluster/users/gtg629v/salman/portable/RVQ_xplatform1/ffmpeg/ffmpeg-0.6.2/libavcodec;/cluster/users/gtg629v/salman/portable/RVQ_xplatform1/ffmpeg/ffmpeg-0.6.2/libswscale;/cluster/users/gtg629v/salman/portable/RVQ_xplatform1/ffmpeg/ffmpeg-0.6.2/libavutil"');
        %setenv('LD_LIBRARY_PATH', '/cluster/users/gtg629v/salman/portable/RVQ_xplatform1/ffmpeg/ffmpeg-0.6.2/libavformat;/cluster/users/gtg629v/salman/portable/RVQ_xplatform1/ffmpeg/ffmpeg-0.6.2/libavdevice;/cluster/users/gtg629v/salman/portable/RVQ_xplatform1/ffmpeg/ffmpeg-0.6.2/libavcodec;/cluster/users/gtg629v/salman/portable/RVQ_xplatform1/ffmpeg/ffmpeg-0.6.2/libswscale;/cluster/users/gtg629v/salman/portable/RVQ_xplatform1/ffmpeg/ffmpeg-0.6.2/libavutil');    
        
        %unix(['/cluster/users/gtg629v/salman/portable/RVQ_xplatform1/ffmpeg/ffmpeg-0.6.2/ffmpeg -r 5 -i '  odir '%05d.jpg -vcodec libxvid -qscale 1 -y ' odir  'out.mp4']);  %original: compatible with Quicktime and jpg, but not with png images
        %unix(['/cluster/users/gtg629v/salman/portable/RVQ_xplatform1/ffmpe
        %g/ffmpeg-0.6.2/ffmpeg -r 5 -i '  odir '%05d.png -vcodec mpeg4 -vtag libxvid -qscale 1 -y ' odir  'out.mp4']); %not compatible with Quicktime but compatible with jpg and png
        %unix(['/cluster/users/gtg629v/salman/portable/RVQ_xplatform1/ffmpeg/ffmpeg-0.6.2/ffmpeg -r 5 -i '  odir '%05d.png -vcodec mpeg4 -qscale 1 -y ' odir  'out.mp4']);
        unix(['ffmpeg -r 5 -i '  odir '%05d.jpg -vcodec mpeg4 -qscale 1 -y ' odir  'results_' num2str(ridx) '_' txt2 '.mp4'])
    end
%end




%        UTIL_FILE_save2pdf(cfn_out_pdf,      h,     200) ; 
%         if (ispc)
%             system(['"C:\Program Files\ImageMagick-6.6.8-Q16\convert"                                                   -density 300 ' cfn_out_pdf ' ' cfn_out_png]) 
%         elseif (isunix)
%             unix  (['/cluster/users/gtg629v/salman/portable/RVQ_xplatform1/imagemagick/ImageMagick-6.6.8-9/bin/convert  -density 300 ' cfn_out_pdf ' ' cfn_out_png]);
%         end
        %close all;
%        set(h,'PaperPosition',[0,0,position(3:4)]);
        %print('-dpdf', '-r200', cfn_out_jpg) ;