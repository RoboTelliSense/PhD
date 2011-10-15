function rmse_out = UTIL_RVQ_repeat_SNR(rmse)

    rmse_out = rmse;
    for i=2:length(rmse)
        if (rmse(i)==-9999)
            rmse_out(i) = rmse_out(i-1);
        end
    end