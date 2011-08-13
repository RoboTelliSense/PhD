function RVQ_0_create_poscsv(dir_out, cfn_poscsv, f, iw, ih, batchsize, bWeighted)

    str_f               =   UTIL_GetZeroPrefixedFileNumber(f);
    Rrect               =   [1 1 iw ih];
    cfn_Rraw            =   [dir_out   str_f   '_' num2str(Rrect(3)) 'x' num2str(Rrect(4)) '.raw'];  

                            %RVQ_FILES_create_posnegImage                           (I, cfn_Rraw, false);
                            
                            
    if (f==1)
                            RVQ_0_create_positiveExamples_csv               (cfn_Rraw, cfn_poscsv, Rrect, 1, 1, iw, ih, false);     
    else
        if (bWeighted)
            for i=1:f
                            RVQ_0_create_positiveExamples_csv       (cfn_Rraw, cfn_poscsv, Rrect, 1, 1, iw, ih, true);     
            end
        else
                            RVQ_0_create_positiveExamples_csv       (cfn_Rraw, cfn_poscsv, Rrect, 1, 1, iw, ih, true);     
        end
    end
                            %type(cfn_poscsv);
    