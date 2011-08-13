function UTIL_saveimg_wholeFigure(h, cfn_png)
        
        if (ispc)            
            print(h, '-dpng', '-r150', cfn_png);               
            
        elseif (isunix)
            [pathstr, name, ext]    =   fileparts(cfn_png);
            cfn_pdf                 =   [pathstr '/' name '.pdf'];
                                        UTIL_FILE_save2pdf  (cfn_pdf,      h,     150) ;    
            %unix                (['/usr/bin/gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=png16m -r150 -sOutputFile=' cfn_png ' ' cfn_pdf])
            
        end
 
%alternate        
%for pc           %print(h, '-djpeg', '-r150', cfn_png);        
%for unix: print('-dpdf', '-r300', 'temp.pdf') ;
%for unix: unix(['gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=jpeg -r150 -sOutputFile=' cfn_png ' ' 'temp.pdf'])
        
        
                        

