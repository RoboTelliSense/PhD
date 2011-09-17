function [grid_x_hxw, grid_y_hxw] = UTIL_2D_grid_create(w, h, type)

    if (strcmp(type, 'meshgrid_zc')) %0 centered mesh grid
        [grid_x_hxw, grid_y_hxw]=   meshgrid([1:w]-w/2, [1:h]-h/2); %input grid based on w and h centered around 0
        
    elseif (strcmp(type, 'boundary_zc')) %0 centered boundary
        x                   =   [1:w]-w/2;
        y1                  =   (1-h/2)*ones(1,length(x)); %bottom horizontal line
        y2                  =   (h/2)*ones(1,length(x));   %top horizontal line
        
        y                   =   [1:h]-h/2;
        x1                  =   (1-w/2)*ones(1,length(y));
        x2                  =   (w/2)*ones(1,length(y));
        
        grid_x_hxw          =   [x  x  x1 x2];
        grid_y_hxw          =   [y1 y2 y  y];
    end