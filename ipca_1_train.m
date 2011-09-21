%-------------------------------------------------------------------------
%
%-------------------------------------------------------------------------
function IPCA = ipca_1_train(DM2, IPCA)

    
    if (isfield(IPCA,'trg_descr_PxN'))
        N                   =   size(IPCA.trg_descr_PxN,2);
        recon               =   IPCA.mdl_3_U_DxP * IPCA.trg_descr_PxN + repmat(IPCA.mdl_2_mu_Dx1,1, N);
        mu_shxsw = reshape(IPCA.mdl_2_mu_Dx1, IPCA.in_7_sh__, IPCA.in_6_sw__);
        
        [IPCA.mdl_3_U_DxP, IPCA.mdl_4_S_Bx1, out_mu, IPCA.Np] ...
                            =   sklm(DM2, IPCA.mdl_3_U_DxP, IPCA.mdl_4_S_Bx1, mu_shxsw, IPCA.Np, IPCA.ff);
        IPCA.mdl_2_mu_Dx1 = out_mu(:);
        %update projection scalars (only place where an assignment to projScalars takes place)
        IPCA.trg_descr_PxN =   IPCA.mdl_3_U_DxP'*(recon - repmat(IPCA.mdl_2_mu_Dx1,1,N));
    else
        mu_shxsw = reshape(IPCA.mdl_2_mu_Dx1, IPCA.in_7_sh__, IPCA.in_6_sw__);
        [IPCA.mdl_3_U_DxP, IPCA.mdl_4_S_Bx1, out_mu, IPCA.Np] ...
                            =   sklm(DM2, IPCA.mdl_3_U_DxP, IPCA.mdl_4_S_Bx1, mu_shxsw, IPCA.in_Np, IPCA.in_ff);
        IPCA.mdl_2_mu_Dx1 = out_mu(:);
    end

%------------------------------------------------------
% POST-PROCESSING
%------------------------------------------------------
%limit to P
    if (size(IPCA.mdl_3_U_DxP,2) > IPCA.mdl_1_P__1x1)
        %IPCA.reseig        = IPCA.ff^2 *IPCA.reseig + sum(IPCA.mdl_4_S_Bx1(IPCA.maxbasis+1:end).^2);
        IPCA.reseig         =   IPCA.ff * IPCA.reseig + sum(IPCA.mdl_4_S_Bx1(IPCA.mdl_1_P__1x1+1:end));
        IPCA.mdl_3_U_DxP    =   IPCA.mdl_3_U_DxP(:,1:IPCA.mdl_1_P__1x1);
        IPCA.mdl_4_S_Bx1    =   IPCA.mdl_4_S_Bx1(1:IPCA.mdl_1_P__1x1);
        if (isfield(IPCA,'projScalars'))
            IPCA.trg_descr_PxN    =   IPCA.trg_descr_PxN(1:IPCA.mdl_1_P__1x1,:);
        end
    end

    