function min_norm = RVQ_0_codebook_distance(CB_ref, CB)

    [M, T, sw, sh] = RVQ_FILES_getCodebookParameters(CB);

%     t=1;
%     diff1           =   CB_ref{1}{t} - CB{1}{t} ;
%     diff2           =   CB_ref{1}{t} - CB{2}{t} ;
%     diff3           =   CB_ref{2}{t} - CB{1}{t} ;
%     diff4           =   CB_ref{2}{t} - CB{2}{t} ;
% 
%     norm1           =   norm(diff1(:),2)/sqrt(sh*sw);
%     norm2           =   norm(diff2(:),2)/sqrt(sh*sw);
%     norm3           =   norm(diff3(:),2)/sqrt(sh*sw);
%     norm4           =   norm(diff4(:),2)/sqrt(sh*sw);
    
    i=1;
    mynorm=[];
    for t=1:1
        for m1=1:1
            for m2=1:1
                %diff           =   CB_ref{m1}{t} - CB{m2}{t} ;
                hsv1            =   rgb2hsv(CB{m2}{t});
                hsv_ref         =   rgb2hsv(CB_ref{m1}{t});
                diff            =   360*(hsv1(:,:,1) - hsv_ref(:,:,1)) ;
                mynorm          =   [mynorm norm(diff(:),2)/sqrt(sh*sw)];
            end
        end
    end
    
    mynorm;
    min_norm = sum(mynorm)/length(mynorm);
    
   %min_norm = min(mynorm);


    %method 1
    %diff            =   (norm1 + norm2 +norm3 + norm4)/4;
    
    %method 2
    %diff            =   (min(norm1, norm2) + min(norm3, norm4))/2;
    %diff            =   (min(min(min(norm1, norm2),norm3),norm4));
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%HOW DOES MATLAB COMPUTE NORM?
%
%1 channel example of norm
%-------------------------
%>> a=[1 2;3 4]
%
%>> norm(a(:),2)
%ans =
%   5.4772
%
%>> sqrt(1+4+9+16)
%ans =
%    5.4772




%3 channel example of norm
%-------------------------
% >> a(:,:,1)=[1 2;3 -4]
% >> a(:,:,2)=[2 2;3 -4]
% >> a(:,:,3)=[2 2;4 -4]
%
% >> norm(a(:))
%ans =
%   10.1489
%
%sqrt(1+4+9+16+4+4+9+16+4+4+16+16)
%ans =
%   10.1489
%
%sqrt(sum(sum(sum(a.^2))))
%ans =
%   10.1489
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
