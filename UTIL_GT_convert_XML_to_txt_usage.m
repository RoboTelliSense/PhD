clear;
clc;
close all;
path(path, 'C:\salman\portable\Matlab_common');
path(path, 'C:\salman\portable\xml_toolbox');

%USAGE
%the PETS2001 xml file contains ground truth data with the following settings:
%a. image size of 768x576
%b. ground truth data is cartesian (i.e., y increases upwards)

%I want ground truth data for an image size of 320x240, and with y increasing downwards

    %-----------------------------            
    %INITIALIZATIONS
    %-----------------------------
            %odir             =   'img\PETS2001_640x480\'                 %image odirectory
            cfn_xml             =   'GTBB_PETS2001_ObjectXML0.xml'
            cfn_txt             =   'GTBB_PETS2001_640x480_redCoatFemale.txt'
            tgtID               =    1;
            Ih                  =    576;                          %original image height
            Ih_desired          =    480;                          %you want target ground truth for a new (scaled) image height
            bInvert             =    true;                         %you want to invert, so y increasing down becomes opposite, and if y is increasing up, then that becomes opposite

    %-----------------------------            
    %OPERATIONS
    %-----------------------------            
            [fI, fF, GT]       =   UTIL_GT_convert_XML_to_txt  (cfn_xml, cfn_txt, tgtID, Ih, Ih_desired, bInvert); %Ih is image Ih
            
    %-----------------------------            
    %DISPLAY
    %-----------------------------
            %i=1;
            %for f=fI:fF
            %    inp_img  =   imread([odir UTIL_GetZeroPrefixedFileNumber(f) '.jpg']);
                %imshow(inp_img);
                %hold on;
                %rectangle('Position', GT(i,:));
                %hold off;
            %    i=i+1;
                %pause
            %end
            
