%for each row in DM2, finds min value, and updates count of that column's index value
function out_1xN = DM2_cnt_min_row_element(DM2)

    [D, N]                  =   size(DM2);
    out_1xN                 =   zeros(1,N);

    for r=1:D
        [val, idx]          =   min(DM2(r,:));
        out_1xN(idx)        =   out_1xN(idx)+1;
    end
    
    out_1xN = out_1xN*100/sum(out_1xN);