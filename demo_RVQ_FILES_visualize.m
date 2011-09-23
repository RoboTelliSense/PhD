        %================================
        %INITIALIZATIONS
        %================================
            clear;
            clc;
            clf;
            %close all;
            if (ispc)
                cd c:\salman\portable\RVQ_xplatform1
                path(path, 'C:\salman\portable\Matlab_common');
            elseif (isunix)
                cd /cluster/users/gtg629v/salman/portable/RVQ_xplatform1
                path(path, '/cluster/users/gtg629v/salman/portable/Matlab_common');
            end
            

            %parameters
            %----------
                T               =   8;
                M               =   2;
                Iw              =   240;%640;
                Ih              =   160;%480;
                sw              =   33;%11;
                sh              =   33;%41;
                ww              =   9;
                wh              =   5;
                N_sx            =   1;%3;
                N_sy            =   1;%3;
                dir_I           =   'img/Dudek/';%'img/PETS2001_640x480/';
                ext_I           =   '.png';%'.jpg'
                prefix          =   ['test_out']; %['trk_RVQ_PETS2001_' num2str(N_ict)];
                odir         =   [prefix '/']; %[prefix '/results_from_GT/'];
                fn_out_prefix   =   [prefix '_'];
                N_ict           =   'all previous';
                cfn_trk         =   [odir 'tracks.csv'];
                [F, CIX, CIY, CX, CY]   =   textread(cfn_trk, '%d   %d %d   %d %d', 'delimiter', ',');
                fI              =   F(1);
                Nf              =   length(F);
                fF              =   fI + Nf - 1;



            %thresholds
                SNR_max         =   255;
                stg_add_thresh  =   3;
                gamma_SNRfrac   =   0.8;

            %flags    
                bPlotCodebooks  =   true;
                bSave           =   true;
                bGenerateSNRstg =   true;
                bCreateVideo    =   true;
                scalingType     =   3;
                
                




            
        %================================
        %OPERATIONS
        %================================
            %Nf          =   fF - fI + 1;
            f_idx       =   1;
            h_fig       =   figure(1);
            
            for f=fI:fF
                clf;
                str_f       =   UTIL_GetZeroPrefixedFileNumber(f);
                str_fm1     =   UTIL_GetZeroPrefixedFileNumber(f-1);
                str_fidx    =   UTIL_GetZeroPrefixedFileNumber(f_idx);
                
                cfn_out     =   [odir fn_out_prefix str_fidx '.jpg'];

                                RVQ_FILES_visualize

                f_idx       =   f_idx+1;
                f
%                f_tst       =   f_tst+1;             %frame 472 is treated as f_tst=0, f_tst=1 for f=473
               
            end
            
            if (bCreateVideo)
                system(['c:\salman_programs\ffmpeg -r 5 -i '  odir fn_out_prefix '%05d.jpg -vcodec libxvid -qscale 1 -y ' odir prefix '.mp4']);
            end