%-------------------------------------------------------------------------
%
%-------------------------------------------------------------------------
function IPCA = ipca_1_train(DM2, IPCA)

    
    if (isfield(IPCA,'trg_descr_PxN'))
        N                   =   size(IPCA.trg_descr_PxN,2);
        recon               =   repmat(IPCA.mdl_2_mu_Dx1(:),[1,N]) + IPCA.mdl_2_U_DxB * IPCA.trg_descr_PxN;
        [IPCA.mdl_2_U_DxB, IPCA.mdl_4_S_Bx1, IPCA.mdl_2_mu_Dx1, IPCA.Np] ...
                            =   sklm2(DM2, IPCA.mdl_2_U_DxB, IPCA.mdl_4_S_Bx1, IPCA.mdl_2_mu_Dx1, IPCA.Np, IPCA.ff);
        
        %update projection scalars (only place where an assignment to projScalars takes place)
        IPCA.trg_descr_PxN =   IPCA.mdl_2_U_DxB'*(recon - repmat(IPCA.mdl_2_mu_Dx1(:),[1,N]));
    else
        [IPCA.mdl_2_U_DxB, IPCA.mdl_4_S_Bx1, IPCA.mdl_2_mu_Dx1, IPCA.Np] ...
                            =   sklm2(DM2, IPCA.mdl_2_U_DxB, IPCA.mdl_4_S_Bx1, IPCA.mdl_2_mu_Dx1, IPCA.Np, IPCA.ff);
    end

%------------------------------------------------------
% POST-PROCESSING
%------------------------------------------------------
%limit to P
    if (size(IPCA.mdl_2_U_DxB,2) > IPCA.mdl_1_P__1x1)
        %IPCA.reseig         = IPCA.ff^2 *IPCA.reseig + sum(IPCA.mdl_4_S_Bx1(IPCA.maxbasis+1:end).^2);
        IPCA.reseig         =   IPCA.ff * IPCA.reseig + sum(IPCA.mdl_4_S_Bx1(IPCA.mdl_1_P__1x1+1:end));
        IPCA.mdl_2_U_DxB          =   IPCA.mdl_2_U_DxB(:,1:IPCA.mdl_1_P__1x1);
        IPCA.mdl_4_S_Bx1              =   IPCA.mdl_4_S_Bx1(1:IPCA.mdl_1_P__1x1);
        if (isfield(IPCA,'projScalars'))
            IPCA.trg_descr_PxN    =   IPCA.trg_descr_PxN(1:IPCA.mdl_1_P__1x1,:);
        end
    end

    