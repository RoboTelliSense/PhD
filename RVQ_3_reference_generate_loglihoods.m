    %-----------------------
    %INITIALIZATIONS
    %-----------------------

        %matlab
            clear;
            clc;
            close all;

        %RVQ
            T=8;
            M=2;            %number of templates
            newM=M+1;       

        %image
            Iw=640;
            Ih=480;

        %snippets    
            sw=11;
            sh=41;
            [IiN, Iiw, Iih] = RVQ_UTIL_computeInnerPixels(Iw, Ih, sw, sh);

        %target BB    



    

            U_soc=[];

            A           = RVQ_FILES_read_idx_file('C:\salman\work\software\RVQ\Data Warehouses\PETS2001\STT1\F1.idx', Iw, Ih, sw, sh, T, M, true);
            B           = RVQ_FILES_read_idx_file('C:\salman\work\software\RVQ\Data Warehouses\PETS2001\STT1\00472_640x480_F1.idx', Iw, Ih, sw, sh, T, M, false);

            [stage_1_prob,   stages_tm1_to_t_prob]      =   RVQ_3_createCCD(A, newM);

    %-----------------------
    %OPERATIONS
    %-----------------------
    
            logprob = true;    
            i=1;
            for y=1:Iih
                y
                for x=1:Iiw        
                    U_soc(y,x)                          =   RVQ_3_testSoC(stage_1_prob,    stages_tm1_to_t_prob,    B(i,:), T, logprob); 
                    i                                   =   i+1;
                end
            end

    %-----------------------
    %RESULTS
    %-----------------------
    
            close all;
            figure;
            imagesc(U_soc)
            hold on
            %hist(U_soc(:))
            
            
            TGT =  [157 142 8 18    ]*2;
            %TGT =  [180 142 6 21    ]*2;
            TGT         =   uint16([TGT(1)-sw/2 TGT(2)-sh/2 TGT(3) TGT(4)]);
            rectangle('Position', TGT, 'EdgeColor', [1 0 0 ])
            title('log likelihood using the SoC descriptor')
            colorbar;
            
            pause;
            RVQ_ROC