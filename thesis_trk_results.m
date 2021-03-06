function OUT =thesis_trk_results()

%----------------------------------------------------
% RVQ (using only decoder codebook)
% i did these experiments thinking i was done for draft 2, 
% but Dr Barnes pointed out that these were wrong since i only used decoder
% codebooks, and i should have used encoder+decoder codebooks.
%----------------------------------------------------
%1. Dudek                       %    maxQ   RofE   nulE   monR
	rvq__1_Dudek___old      =	[    50     6.68   7.96   7.85  ; 	%8x2  %50 means track was lost
									 8.40   8.19   7.22   8.89  ; 	%8x4
									 9.13   7.95   8.67   8.47  ; 	%8x8
									 8.34  10.02   8.18   7.60  ; 	%8x12
									 8.05  10.08   8.10   9.25 ];  	%8x16
								    

%2. davidin300                  %    maxQ   RofE   nulE   monR
	rvq__2_david___old      =   [  	 5.67   6.93   8.72  11.31;  %8x2
									 4.39   5.95   4.59   5   ;  %8x4
									 8.08   6.14   8.50   8.52;  %8x8
									 6.07   5.65   6.70   4.52;  %8x12
									 5.48   5.33   4.60   4.29 ];%8x16

%3. sylv                        %    maxQ   RofE   nulE   monR
	rvq__3_sylv____old      = 	[	 4.26   4.29   4.72   5.61;  %8x2
									 4.69   4.66   4.82   4.70;  %8x4
									 4.66   4.56   4.88   4.95;  %8x8
									 4.19   5.03   4.43   4.96;  %8x12
									 4.89   4.54   4.77   4.69 ];%8x16

%5. fish                        %    maxQ   RofE   nulE   monR
	rvq__5_fish____old      = 	[	 2.73   3.82   3.93   3.32; %8x2
									 2.84   2.97  10.40   2.60; %8x4
									13.09   2.60  13.97  13.29; %8x8
									 5.24   5.37   4.52   4.44; %8x12
									 4.42  12.04   4.87   4.37];%8x16

%6. car4                        %    maxQ   RofE   nulE   monR
    rvq__6_car4____old      =   [    5.08   4.86   5.18   5.93; %8x2
                                     5.0    5.16   5.03   5.51; %8x4
                                     5.12   5.27   5.39   6.35; %8x8
                                     5.11   5.34   4.72   5.84; %8x12
                                     6.47   6.63   5.52   5.28];%8x16
 
 %7. car11                      %    maxQ   RofE   nulE   monR
    rvq__7_car11___old      =   [    2.32   2.23   2.57   2.23; %8x2
                                     2.30   2.06   2.12   2.71; %8x4
                                     2.14   2.48   3.45  12.04; %8x8
                                     2.94   2.90   5.29   50;   %8x12
                                     50     2.78   2.97   2  ]; %8x16 %50 means track was lost
%----------------------------------------------------
% RVQ (using encoder + decoder codebook)
%----------------------------------------------------
%1. Dudek                       %    maxQ   RofE   nulE   monR
	rvq__1_Dudek__          =	[    7.78   7.11   9.65  11.81; %8x2
                                     7.92   8.43   8.19   9.17; %8x4
                                     8.09   8.19   7.97   8.73; %8x8
                                     9.34  11.99   8.98  10.64; %8x12
                                     9.05   7.55   7.86   8.71];%8x16
                                 
%2. davidin300                  %    maxQ   RofE   nulE   monR                               
    rvq__2_david__          =   [    6.84   9.02   7.17   50;   %8x2
                                     4.47   6.21   5.35   5.83; %8x4
                                     9.89   5.74   4.63   4.15; %8x8
                                     7.16   6.67   6.42   5.25; %8x12
                                     7.23   7.31   50     5.58]; %8x16  %50 means track was lost
                                 
%3. sylv                        %    maxQ   RofE   nulE   monR                                
    rvq__3_sylv___          =   [    4      4.12   4.81   4.31; %8x2
                                     4.68   5.54   5.74   4.58; %8x4
                                     4.72   4.83   4.74   5.08; %8x8
                                     5.04   5.03   5.06   4.50; %8x12 %5.03 is old because of small bug in code which is fixed now, need to rerun but ok since i'm not using 8x12
                                     5.01   4.54   4.10   5.12];%8x16 %4.54 is old because of small bug in code which is fixed now, need to rerun but ok since i'm not using 8x16
                                 
%5. fish                        %    maxQ   RofE   nulE   monR                                
    rvq__5_fish___          =   [   11.50   2.96   4.03   2.89; %8x2
                                     2.78  12.22   2.48   3.62; %8x4
                                    12.15   2.73  10.71  11.94; %8x8
                                     5.30   5.03   5.18   4.90; %8x12
                                     4.61  11.33   4.72   4.18];%8x16
                                
%6. car4                        %    maxQ   RofE   nulE   monR                                 
    rvq__6_car4___          =   [    4.67   4.93   5.28   5.07; %8x2
                                     6.38   5.14   5.84   5.18; %8x4
                                     5.09   5.50   6.19   4.71; %8x8
                                     5.58   5.17   5.86   5.62; %8x12
                                     3.97   5.86   5.48   5.24];%8x16
                                 
%7. car11                       %    maxQ   RofE   nulE   monR                                
    rvq__7_car11__          =   [    2.17   2.47   2.59   2.47; %8x2
                                     2.36   2.33   2.52   2.72; %8x4
                                     3.57   2.68   2.96   2.55; %8x8
                                     3.23   3.28   8.25  13.81; %8x12
                                     2.97   4.31   2.62   6.87];%8x16
  
    OUT.maxP                =   [   rvq__1_Dudek__(1:3,1)' ;    %8x 2,4,8,neglect, 12,16 so that I have 3 configurations for every algo
                                    rvq__2_david__(1:3,1)' ;    %"
                                    rvq__3_sylv___(1:3,1)' ;    %"
                                    rvq__5_fish___(1:3,1)' ;    %"
                                    rvq__6_car4___(1:3,1)' ;    %"
                                    rvq__7_car11__(1:3,1)' ];   %"
                                
    OUT.RofE                =   [   rvq__1_Dudek__(1:3,2)' ;    %"
                                    rvq__2_david__(1:3,2)' ;    %"
                                    rvq__3_sylv___(1:3,2)' ;    %"
                                    rvq__5_fish___(1:3,2)' ;    %"
                                    rvq__6_car4___(1:3,2)' ;    %"
                                    rvq__7_car11__(1:3,2)' ];   %"
                                
    OUT.nulE                =   [   rvq__1_Dudek__(1:3,3)' ; %"
                                    rvq__2_david__(1:3,3)' ; %"
                                    rvq__3_sylv___(1:3,3)' ; %"
                                    rvq__5_fish___(1:3,3)' ; %"
                                    rvq__6_car4___(1:3,3)' ; %"
                                    rvq__7_car11__(1:3,3)' ];%"
                                
    OUT.monR                =   [   rvq__1_Dudek__(1:3,4)' ; %"
                                    rvq__2_david__(1:3,4)' ; %"
                                    rvq__3_sylv___(1:3,4)' ; %"
                                    rvq__5_fish___(1:3,4)' ; %"
                                    rvq__6_car4___(1:3,4)' ; %"
                                    rvq__7_car11__(1:3,4)' ];%" 
                                
%---------------------------------------------------
% PCA
%----------------------------------------------------
    OUT.pca                 =   [   7.44  7.81  8.54    ; %1_Dudek__: 8, 16, 32
                                    8.36  4.60  6.93    ; %2_david__: 8, 16, 32
                                    4.34  5.47  5.72    ; %3_sylv___: 8, 16, 32
                                    9.75  2.17  7.98    ; %5_fish___: 8, 16, 32
                                    4.79  4.60  5.52    ; %6_car4___: 8, 16, 32
                                    2.21  2.13  2.39   ]; %7_car11__: 8, 16, 32

%----------------------------------------------------
% TSVQ
%----------------------------------------------------

    OUT.tsvq                =   [    8.62  11.87   9.71   ; %1_Dudek__: 3, 4, 5
                                    12.88   6.29   5.93   ; %2_david__: 3, 4, 5
                                     4.70   4.80   4.61   ; %3_sylv___: 3, 4, 5       
                                    10.07   4.59   5.47   ; %5_fish___: 3, 4, 5
                                     5.11   6.79   5.80   ; %6_car4___: 3, 4, 5
                                     2.21   5.28   2.94  ]; %7_car11__: 3, 4, 5