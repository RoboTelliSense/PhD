function avg_trk_err    =   TRK_read_avg_error(cfn, std_experimentalF)

    TRK_ERR             =   csvread(cfn);
    experimentalF       =   size(TRK_ERR,1);  %experimentalF >= std_experimentalF
    avg_trk_err         =   TRK_ERR(std_experimentalF,3);
    
    %if (experimentalF ~= std_experimentalF)
        %sprintf('%s %d %d', cfn, experimentalF, std_experimentalF)
        %sprintf('%d', experimentalF)
    %end