function B = UTIL_sort_matrix_wrt_col(A)
    [Y,I]=sort(A(1,:));
    B=A(:,I);
