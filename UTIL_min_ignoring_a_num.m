function min2 = UTIL_min_ignoring_a_num(A, num)

    A                       =   A(:);
    idx                     =   find(A~=num);
    min2                    =   min(A(idx));