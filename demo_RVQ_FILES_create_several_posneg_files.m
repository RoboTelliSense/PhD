%% This function creates posneg files from numbered images in a directory.
% 
% Copyright (C) Salman Aslam.  All rights reserved.
% Data created       : February 11, 2011
% Date last modified : July 20, 2011
%%

%-------------------------------------
%INITIALIZATIONS
%-------------------------------------
    clear;
    clc;
    close all;

%-------------------------------------
%PRE-PROCESSING
%-------------------------------------
    % dir_I                 =   'img\PETS2001_640x480\';
    % iw                    =   640;
    % ih                    =   480;
    % ext_I                 =   '.jpg'
    % fI                    =   0;
    % fF                    =   2688;

    % dir_I                 =   'img\AVSS2007iLids_360x288\';
    % iw                    =   360;
    % ih                    =   288;
    % ext_I                 =   '.png';
    % fI                    =   1;
    % fF                    =   5291;

    dir_I                   =   'img\Dudek\720x480\';
    ext_I                   =   '.png';
    iw                      =   720;    %image width
    ih                      =   480;    %image height
    fI                      =   1;      %start image
    fF                      =   573;    %end image


    % dir_I                 =   'img\Dudek\120x80\';
    % ext_I                 =   '.png';
    % iw                    =   120;
    % ih                    =   80;
    % fI                    =   1;
    % fF                    =   573;


%-------------------------------------
%PROCESSING
%-------------------------------------
    for f=fI:fF
        str_f               =   UTIL_GetZeroPrefixedFileNumber(f);
        cfn_I               =   [dir_I   str_f   ext_I];
        cfn_Iraw            =   [dir_I   str_f   '_' num2str(iw) 'x' num2str(ih) '.raw'];   
        I                   =   imread(cfn_I);
                                RVQ_FILES_create_posnegImage(I, cfn_Iraw, false);
        f
    end