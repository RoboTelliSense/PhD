function xy_2xN             =   UTIL_2D_affine_apply_inverse_transform(Ha_2x3, XY_2xN)

    [temp,N]                =   size(XY_2xN);
    T_2x1                   =   Ha_2x3(:,3);            %tx, ty
    A_2x2                   =   Ha_2x3(1:2,1:2);        %a, b, c, d
     
    %transform
    temp_2xN                =   XY_2xN - repmat(T_2x1, 1, N);   %translate by tx, ty
    xy_2xN                  =   inv(A_2x2) * temp_2xN;          %apply inv a, b, c, d