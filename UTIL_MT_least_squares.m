%H*theta=x
function theta = UTIL_MT_least_squares(H, x)

    theta = inv(H'*H)*H'*x;