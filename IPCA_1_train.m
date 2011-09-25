%-------------------------------------------------------------------------
%
%-------------------------------------------------------------------------
function IPCA = IPCA_1_train(DM2, IPCA)
    
    U_DxP   =   IPCA.mdl_3_U__DxP;
    
    if (isfield(IPCA,'trg_featr_PxN'))
        sh                  =   IPCA.in_7__sh__;
        sw                  =   IPCA.in_6__sw__;
        N                   =   size(IPCA.trg_featr_PxN,2);
        recon               =   U_DxP * IPCA.trg_featr_PxN + repmat(IPCA.mdl_2_mu_Dx1,1, N);    %2. recon
        
        %train
        mu_shxsw = reshape(IPCA.mdl_2_mu_Dx1, sh, sw); 
        
        
        [IPCA.mdl_3_U__DxP, IPCA.mdl_4_S_Bx1, out_mu, IPCA.Np] ...
                            =   sklm(DM2, IPCA.mdl_3_U__DxP, IPCA.mdl_4_S_Bx1, mu_shxsw, IPCA.Np, IPCA.in_ff);
        IPCA.mdl_2_mu_Dx1 = out_mu(:);
        %update features (projection scalars, only place where an assignment to features takes place)
        IPCA.trg_featr_PxN =   IPCA.mdl_3_U__DxP'*(recon - repmat(IPCA.mdl_2_mu_Dx1,1,N));
    else
        %just train
        mu_shxsw = reshape(IPCA.mdl_2_mu_Dx1, IPCA.in_7__sh__, IPCA.in_6__sw__);
        [IPCA.mdl_3_U__DxP, IPCA.mdl_4_S_Bx1, out_mu, IPCA.Np] ...
                            =   sklm(DM2, IPCA.mdl_3_U__DxP, IPCA.mdl_4_S_Bx1, mu_shxsw, IPCA.in_Np, IPCA.in_ff);
        IPCA.mdl_2_mu_Dx1 = out_mu(:);
    end

%------------------------------------------------------
% POST-PROCESSING
%------------------------------------------------------
%just pick P eigenvectors
    if (size(IPCA.mdl_3_U__DxP,2) > IPCA.mdl_1_Q__1x1)
        %IPCA.reseig        = IPCA.in_ff^2 *IPCA.reseig + sum(IPCA.mdl_4_S_Bx1(IPCA.maxbasis+1:end).^2);
        IPCA.pf_reseig     =   IPCA.in_ff * IPCA.pf_reseig + sum(IPCA.mdl_4_S_Bx1(IPCA.mdl_1_Q__1x1+1:end));
        IPCA.mdl_3_U__DxP   =   IPCA.mdl_3_U__DxP(:,1:IPCA.mdl_1_Q__1x1);
        IPCA.mdl_4_S_Bx1    =   IPCA.mdl_4_S_Bx1(1:IPCA.mdl_1_Q__1x1);
        if (isfield(IPCA,'trg_featr_PxN'))
            IPCA.trg_featr_PxN    =   IPCA.trg_featr_PxN(1:IPCA.mdl_1_Q__1x1,:);
        end
    end

%test training examples   
    IPCA.in_2__mode           =   'trg';
    IPCA                     =   PCA__2_test(DM2, IPCA);    
    IPCA.in_2__mode           =   'tst';    