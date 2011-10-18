function out_Dx1 = DM2_compute_rms_of_every_dimension(DM2)

    [D,N]                   =   size(DM2);
    out_Dx1                 =   -1*ones(D,1);
    for d=1:D
        out_Dx1(d)          =   UTIL_METRICS_compute_rms(DM2(d,:));
    end
        