%function candErrs_0t1_DxNp = ALGO_2_test(cand_snps_0t1_shxswxNp, ALGO, Np)
clear;
clc;
close all;

load conden

%-----------------------------------
%INITIALIZATION
%-----------------------------------
        [sh, sw, Np]        =   size(cand_snps_0t1_shxswxNp);
        D                   =   sh*sw;
        U_DxP               =   ALGO.mdl_3_U__DxP;   
        S_Bx1               =   ALGO.mdl_4_S_Bx1;
        mu_Dx1              =   ALGO.mdl_2_mu_Dx1;
        
        %part 1: error, distance from mean (err vector points to mean)
        cand_snps_zc_0t1_shxswxNp   =   reshape(cand_snps_0t1_shxswxNp,[D,Np]) - repmat(mu_Dx1, 1, Np) ; %distance from mean of candidate snippets
        
        %part 2: error, reduce the part that can be explained by the basis
        candErrs_featr_PxNp =   U_DxP' * cand_snps_zc_0t1_shxswxNp;                 %1. projections
        candErrs_recon_DxNp =   U_DxP  * candErrs_featr_PxNp;               %2. reconstructions (mean removed though)
        candErrs_0t1_DxNp   =   cand_snps_zc_0t1_shxswxNp - candErrs_recon_DxNp;    %3. reconstruction errors (of the candidate errors!), 
                                                                            %   this is DFFS
        candErrs_0t1_DxNp                                                                    
        myDM2 = reshape(cand_snps_0t1_shxswxNp,[D,Np]);                                                                   
        ALGO = PCA__2_encode(myDM2, ALGO);
        
        %compute DIFS for use with ALGO, if not using ALGO, not required
        if (isfield(TRK,'candErrs_featr_PxNp'))
            DIFS            =   (abs(candErrs_featr_PxNp)-abs(TRK.candErrs_featr_PxNp))*PARAM.pf_reseig./repmat(S_Bx1,[1,Np]);
        else
            DIFS            =   candErrs_featr_PxNp                               .*PARAM.pf_reseig./repmat(S_Bx1,[1,Np]);
        end
