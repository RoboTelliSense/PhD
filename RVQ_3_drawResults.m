
clear;
clc;
close all;

bUsePCA=1;
bUseMyPCA=0;
bUseRVQE=0;
bUseTSVQ=1;

%load dudek
%load davidin300
%load sylv
%load trellis70
%load fish
load car4
%load car11


%dir_I               =   'img/Dudek/720x480/'
odir                 ='test_out/'
ext_I               =   '.png';
sw                  =   33;
sh                  =   33;


%file names
    cfn_truepts         =   [odir 'GT.csv'];

    cfn_RVQtrackpts     =   [odir 'RVQtrackpts.csv'];
    cfn_PCAtrackpts     =   [odir 'PCAtrackpts.csv'];
    cfn_myPCAtrackpts   =   [odir 'myPCAtrackpts.csv'];
    cfn_TSVQtrackpts    =   [odir 'TSVQtrackpts.csv'];

    cfn_RVQaffine_1x6     =   [odir 'RVQaffine.csv'];
    cfn_PCAaffine_1x6     =   [odir 'PCAaffine.csv'];
    cfn_myPCAaffine_1x6   =   [odir 'myPCAaffine.csv'];
    cfn_TSVQaffine_1x6    =   [odir 'TSVQaffine.csv'];

%ground truth    
%     if exist(cfn_truepts,'file')
%         GT = csvread(cfn_truepts);
%         RVQtrackpts = csvread(cfn_RVQtrackpts);
%         mypts=[];
%     end

%affine parameters    
    %if exist(cfn_PCAaffine_1x6,'file')    bUsePCA=1;      end
    %if exist(cfn_myPCAaffine_1x6,'file')  bUseMyPCA=1;    end
    %if exist(cfn_RVQaffine_1x6,'file')    bUseRVQE=1;      end
    %if exist(cfn_TSVQaffine_1x6,'file')   bUseTSVQ=1;     end
    
    if (bUsePCA)    PCAaffine_1x6     =   csvread(cfn_PCAaffine_1x6); end
    if (bUseMyPCA)  myPCAaffine_1x6   =   csvread(cfn_myPCAaffine_1x6); end
    if (bUseRVQE)    RVQaffine_1x6     =   csvread(cfn_RVQaffine_1x6); end
    if (bUseTSVQ)   TSVQaffine_1x6    =   csvread(cfn_TSVQaffine_1x6); end

    [F, temp] = size(PCAaffine_1x6);


for f=1:F
    str_f           =   UTIL_GetZeroPrefixedFileNumber(f);
%    cfn_I           =   [dir_I   str_f  ext_I];
    I               =   data(:,:,f);
    imshow(uint8(I));
    hold on;
%     if exist(cfn_truepts,'file')
%         
%         a = GT(f,:);
%         b = RVQtrackpts(f,:);
%         mypts(1,1:7,2) = a(2:8);
%         mypts(2,1:7,2) = a(9:15);
% 
%         mypts(1,1:7,3) = b(2:8);
%         mypts(2,1:7,3) = b(9:15);    
% 
%         plot(mypts(1,:,2),mypts(2,:,2),'yx','MarkerSize',10);
%         plot(mypts(1,:,3),mypts(2,:,3),'rx','MarkerSize',10);
%     end
    if (bUsePCA)    drawbox([sh sw], PCAaffine_1x6(f, 2:7), 'Color','r', 'LineWidth',2.5);    end
    if (bUseMyPCA)  drawbox([sh sw], myPCAaffine_1x6(f, 2:7), 'Color','y', 'LineWidth',2.5);  end
    if (bUseRVQE)    drawbox([sh sw], RVQaffine_1x6(f, 2:7), 'Color','g', 'LineWidth',2.5);   end
    if (bUseTSVQ)   drawbox([sh sw], TSVQaffine_1x6(f, 2:7), 'Color','b', 'LineWidth',2.5);   end
    %pause
    hold off;
    title(str_f);
    drawnow
    
end


                                                        
%imshow(I);
%hold on;
%
%drawbox([33 33], param.affineParam, 'Color','r', 'LineWidth',2.5);