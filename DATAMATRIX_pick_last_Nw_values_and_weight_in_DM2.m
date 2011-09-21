%Nw: a window on training examples, so keep last Nw training examples
%bWeighting: weighting or not?

function DM2_weighted = DATAMATRIX_pick_last_Nw_values_and_weight_in_DM2(DM2, Nw, bWeighting)


    [D, N] = size(DM2);

    if (Nw < N) %if Nw > N, then DM2 does not change
        first   =   N - Nw + 1; %say N=100, Nict=5, you want to go from 96 to 100, so start = 96;
        last    =   N;
        DM2 = DM2(:, first:last);
    end


    [D, N]  = size(DM2);  %N is now the new number of training examples, either it's the old N, or it's Nw
    DM2_weighted = [];
    if (bWeighting==1)
        for n=1:N %by now, the number of training examples are Nw
            for r = 1:n %2^(n-1)
                DM2_weighted =  [DM2_weighted DM2(:,n)];
            end
        end
    else
        DM2_weighted = DM2;
    end
