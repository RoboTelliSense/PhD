function UTIL_2D_affine_drawQuadFrom_Ha_2x3(Ha_2x3, sw, sh, alpha, polycolor)

    corners_zc              =   [-sw/2   sw/2  sw/2 -sw/2  -sw/2; ...
                                 -sh/2  -sh/2  sh/2  sh/2  -sh/2; ...
                                  1      1     1     1      1];             %zero centered corners of rectangle with lengths sw and sh
                  
    corners_zc              =   Ha_2x3 * corners_zc;                        %apply warp (affine transform) to corners
%                                 fill(corners_zc(1,:), corners_zc(2,:), ...
%                                      polycolor, ...                         %fill color
%                                      'FaceAlpha', alpha, ...                %transparency, %make alpha 0 if you want no fill, becomes like drawing a quad then
%                                      'EdgeColor', polycolor, ...            %edge color
%                                      'LineWidth',1.5);      

line(corners_zc(1,:), corners_zc(2,:), 'LineWidth', 2, 'Color', polycolor);

    %center                  =   mean(corners_zc(:,1:4),2);
    %hold on;
    %plot(center(1),center(2));
    %hold off
