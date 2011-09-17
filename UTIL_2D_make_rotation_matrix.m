function R = UTIL_2D_make_rotation_matrix(theta)
    
    R = [cos(theta) -sin(theta);...
         sin(theta)  cos(theta)];