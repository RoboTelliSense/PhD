%> @file sklm.m 
%> @brief This file computes incremental SVD (Sequential Karhunen-Loeve Transform)
%>
%> [U_DxNt, S_Ntx1, muAB_Dx1, n] = sklm(B_DxN2, U_DxN1, S_N1x1, muA_Dx1, N2, ff)
%> [U_DxNt, S_Ntx1, muAB_Dx1, n] = sklm(B_DxN2, U_DxN1, S_N1x1, muA_Dx1, N2, ff, K)
%>                 sklm(B_DxN2)  %> initialize
%>
%> without muA_Dx1 or muAB_Dx1, B_DxN2 is assumed as zero-mean
%>
%> required input
%> --------------
%> B_DxN2 (D,n)             : initial/additional B_DxN2
%> U_DxN1 (D,N1)            : old basis
%> S_N1x1 (N1,1)            : old singular values
%>
%> optional input
%> --------------
%> muA_Dx1 (D,1)            : old mean
%> N2                       : number of previous B_DxN2
%> ff                       : forgetting factor (def=1.0)
%> K                        : maximum number of basis vectors to retain
%>
%> output
%> ------
%> U_DxNt (D,N1+n)          : new basis
%> S_Ntx1 (N1+n,1)          : new singular values
%> muAB_Dx1 (D,1)           : new mean
%> n                        : new number of B_DxN2
%>
%> based on
%> --------
%> A. Levy & M. Lindenbaum 
%> "Sequential Karhunen-Loeve Basis Extraction and its Application to Image", 
%> IEEE Trans. on Image Processing Vol. 9, No. 8, August 2000.
%>
%> All changes by Salman Aslam are cosmetic, name changes, etc,
%> functionality intact.
%>
%> Copyright (C) 2005 Jongwoo Lim and David Ross.  All rights reserved.  (Changed with permission by Salman Aslam) 
%> Date created:  March 19, 2011
%> Date modified: Aug 13, 201



function [U_DxNt, S_Ntx1, muAB_Dx1, n] = sklm(B_DxN2, U_DxN1, S_N1x1, muA_Dx1, N2, ff, K)

%-----------------------------------------------
%PRE-PROCESSING
%----------------------------------------------
    [D,n]                   =   size(B_DxN2);

%-----------------------------------------------
%PROCESSING
%-----------------------------------------------
  
    %part 1. user has input almost nothing
    if (nargin == 1) || isempty(U_DxN1)
        if (size(B_DxN2,2) == 1)
            muAB_Dx1        =   reshape(B_DxN2(:), size(muA_Dx1));
            U_DxNt          =   zeros(size(B_DxN2)); 
            U_DxNt(1)       =   1; 
            S_Ntx1          =   0;
        else
            muAB_Dx1        =   mean(B_DxN2,2);
            B_DxN2          =   B_DxN2 - repmat(muAB_Dx1,[1,n]);
            [U_DxNt,S_Ntx1,V]   ...
                            =   svd(B_DxN2, 0);
            S_Ntx1          =   diag(S_Ntx1);
            muAB_Dx1        =   reshape(muAB_Dx1, size(muA_Dx1));
        end
        if nargin >= 7
            keep            =   1:min(K,length(S_Ntx1));
            S_Ntx1          =   S_Ntx1(keep);
            U_DxNt          =   U_DxNt(:,keep);
        end
    
        
    %part 2. user has input quite a bit    
    else
        if (nargin < 6)  ff = 1.0;  end
        
        if (nargin < 5)  N2 = n;    end
        
        if (nargin >= 4 & isempty(muA_Dx1) == false)
            %mean center B_DxN2
            muB_Dx1         =   mean(B_DxN2,2);   
            B_DxN2          =   B_DxN2 - repmat(muB_Dx1,[1,n]); 
            weight          =   sqrt(n*N2/(n+N2));
            B_DxN2          =   [B_DxN2, weight*(muA_Dx1(:)-muB_Dx1)];
            muAB_Dx1        =   reshape((ff*N2*muA_Dx1(:) + n*muB_Dx1)/(n+ff*N2), size(muA_Dx1));
            n               =   n+ff*N2;
        end
        S_Ntx1              =   diag(S_N1x1);
        %>[Q,R,E]           =   qr([ ff*U_DxN1*S_Ntx1, B_DxN2 ], 0); %> old way

        data_proj           =   U_DxN1'*B_DxN2; %> new way
        data_res            =   B_DxN2 - U_DxN1*data_proj;
        [q, dummy]          =   qr(data_res, 0);
        Q                   =   [U_DxN1 q];
        R                   =   [ff*diag(S_N1x1) data_proj; zeros([size(B_DxN2,2) length(S_N1x1)]) q'*data_res];

        [U_DxNt,S_Ntx1,V]   =   svd(R, 0);
        S_Ntx1              =   diag(S_Ntx1);

        if nargin < 7
            cutoff          =   sum(S_Ntx1.^2) * 1e-6;
            keep            =   find(S_Ntx1.^2 >= cutoff);
        else
            keep            =   1:min(K,length(S_Ntx1));
        end

        S_Ntx1              =   S_Ntx1(keep);
        U_DxNt              =   Q * U_DxNt(:, keep);
    end

%-----------------------------------------------
%POST-PROCESSING
%-----------------------------------------------
       
