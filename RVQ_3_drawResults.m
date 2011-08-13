
clear;
clc;
close all;

bUsePCA=1;
bUseMyPCA=0;
bUseRVQ=0;
bUseTSVQ=1;

%load dudek
%load davidin300
%load sylv
%load trellis70
%load fish
load car4
%load car11


%dir_I               =   'img/Dudek/720x480/'
dir_out                 ='test_out/'
ext_I               =   '.png';
sw                  =   33;
sh                  =   33;


%file names
    cfn_truepts         =   [dir_out 'truepts.csv'];

    cfn_RVQtrackpts     =   [dir_out 'RVQtrackpts.csv'];
    cfn_PCAtrackpts     =   [dir_out 'PCAtrackpts.csv'];
    cfn_myPCAtrackpts   =   [dir_out 'myPCAtrackpts.csv'];
    cfn_TSVQtrackpts    =   [dir_out 'TSVQtrackpts.csv'];

    cfn_RVQaffineParams     =   [dir_out 'RVQaffine.csv'];
    cfn_PCAaffineParams     =   [dir_out 'PCAaffine.csv'];
    cfn_myPCAaffineParams   =   [dir_out 'myPCAaffine.csv'];
    cfn_TSVQaffineParams    =   [dir_out 'TSVQaffine.csv'];

%ground truth    
%     if exist(cfn_truepts,'file')
%         truepts = csvread(cfn_truepts);
%         RVQtrackpts = csvread(cfn_RVQtrackpts);
%         mypts=[];
%     end

%affine parameters    
    %if exist(cfn_PCAaffineParams,'file')    bUsePCA=1;      end
    %if exist(cfn_myPCAaffineParams,'file')  bUseMyPCA=1;    end
    %if exist(cfn_RVQaffineParams,'file')    bUseRVQ=1;      end
    %if exist(cfn_TSVQaffineParams,'file')   bUseTSVQ=1;     end
    
    if (bUsePCA)    PCAaffineParams     =   csvread(cfn_PCAaffineParams); end
    if (bUseMyPCA)  myPCAaffineParams   =   csvread(cfn_myPCAaffineParams); end
    if (bUseRVQ)    RVQaffineParams     =   csvread(cfn_RVQaffineParams); end
    if (bUseTSVQ)   TSVQaffineParams    =   csvread(cfn_TSVQaffineParams); end

    [F, temp] = size(PCAaffineParams);


for f=1:F
    str_f           =   UTIL_GetZeroPrefixedFileNumber(f);
%    cfn_I           =   [dir_I   str_f  ext_I];
    I               =   data(:,:,f);
    imshow(uint8(I));
    hold on;
%     if exist(cfn_truepts,'file')
%         
%         a = truepts(f,:);
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
    if (bUsePCA)    drawbox([sh sw], PCAaffineParams(f, 2:7), 'Color','r', 'LineWidth',2.5);    end
    if (bUseMyPCA)  drawbox([sh sw], myPCAaffineParams(f, 2:7), 'Color','y', 'LineWidth',2.5);  end
    if (bUseRVQ)    drawbox([sh sw], RVQaffineParams(f, 2:7), 'Color','g', 'LineWidth',2.5);   end
    if (bUseTSVQ)   drawbox([sh sw], TSVQaffineParams(f, 2:7), 'Color','b', 'LineWidth',2.5);   end
    %pause
    hold off;
    title(str_f);
    drawnow
    
end


                                                        
%imshow(I);
%hold on;
%
%drawbox([33 33], param.affineParam, 'Color','r', 'LineWidth',2.5);