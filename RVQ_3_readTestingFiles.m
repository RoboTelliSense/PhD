function [NSR, STG, SOC] = RVQ_3_readTestingFiles(dir_out, f, iw, ih, sw, sh, M, T, bVisualize)

    str_f               =   UTIL_GetZeroPrefixedFileNumber   (f);
    cfn_nsr             =   [dir_out str_f '_9.nsr'];
    cfn_stg             =   [dir_out str_f '_10.stg'];
    cfn_soc             =   [dir_out str_f '_11.soc'];
            
    NSR                 =   RVQ_FILES_read_cor_file         (cfn_nsr, iw, ih, sw, sh);                         
    STG                 =   RVQ_FILES_read_stg_file         (cfn_stg, iw, ih, sw, sh, T);                      
    SOC                 =   RVQ_FILES_read_idx_file         (cfn_soc, iw, ih, sw, sh, T, M, false);
    
    if (bVisualize)
        figure;
        imagesc(NSR);
        impixelinfo;
        title('NSR');

        figure;
        surf(flipud(NSR));
        title('NSR');

        figure;
        imagesc(STG);
        impixelinfo;
        title('stages');
    end
                
            
    %B_ll               =   RVQ_3_getLogLikelihoods     (p1, pn, B, M, T, Iih, Iiw, dir_out, str_f);

                    