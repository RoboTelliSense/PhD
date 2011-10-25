%this function takes a matrix DM2, and computes along the first or the
%second dimension (convention is same as matlab, so dim=1 means you average
%columns to get a row mean vector, dim=2 means you average rows to get a
%col mean vector.  if an element is greater than or equal to code, it is not included in
%the mean computations.

function m = DM2_filtered_mean(DM2, code, dim) 

    [D,N]                   =   size(DM2);

    if (dim==1)
        for n=1:N
            col_Dx1         =   DM2(:,n);
            j               =   find(col_Dx1<code);
            m(n)            =   mean(col_Dx1(j));
        end
    elseif (dim==2)
        for d=1:D
            row_1xN         =   DM2(d,:);
            j               =   find(row_1xN~=code);
            m(d)            =   mean(row_1xN(j));
        end
        m=m';
    end