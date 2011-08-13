%collI_1c is a collection of 1 channel images
%collI_1c(:,:,1) is the first one channel image, collI_1c(:,:,2) is the
%second and so on
%designMatrix 
function designMatrix = UTIL_convert_collI_1c_to_designMatrix(collI_1c)
    
    [ih,iw,NI] = size(collI_1c);
    
    for i=1:NI
        I                   =   collI_1c(:,:,i);                            %extract i'th image
        designMatrix(i,:)   =   UTIL_IP_image_to_rowWiseVectorized(I);
    end