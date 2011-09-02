%-------------------------------------------------------------------------
%
%-------------------------------------------------------------------------
function IPCA = ipca_1_train(DM2, IPCA)

    
    if (isfield(IPCA,'projScalars'))
        num_projScalars     =   size(IPCA.projScalars,2);
        recon               =   repmat(IPCA.mdl_1_mu_Dx1(:),[1,num_projScalars]) + IPCA.mdl_2_U_DxB * IPCA.projScalars;
        [IPCA.mdl_2_U_DxB, IPCA.mdl_3_S_Bx1, IPCA.mdl_1_mu_Dx1, IPCA.Np] ...
                            =   sklm2(DM2, IPCA.mdl_2_U_DxB, IPCA.mdl_3_S_Bx1, IPCA.mdl_1_mu_Dx1, IPCA.Np, IPCA.ff);
        
        %update projection scalars (only place where an assignment to projScalars takes place)
        IPCA.projScalars =   IPCA.mdl_2_U_DxB'*(recon - repmat(IPCA.mdl_1_mu_Dx1(:),[1,num_projScalars]));
    else
        [IPCA.mdl_2_U_DxB, IPCA.mdl_3_S_Bx1, IPCA.mdl_1_mu_Dx1, IPCA.Np] ...
                            =   sklm2(DM2, IPCA.mdl_2_U_DxB, IPCA.mdl_3_S_Bx1, IPCA.mdl_1_mu_Dx1, IPCA.Np, IPCA.ff);
    end

%------------------------------------------------------
% POST-PROCESSING
%------------------------------------------------------
%limit to Q
    if (size(IPCA.mdl_2_U_DxB,2) > IPCA.Q)
        %IPCA.reseig         = IPCA.ff^2 *IPCA.reseig + sum(IPCA.mdl_3_S_Bx1(IPCA.maxbasis+1:end).^2);
        IPCA.reseig         =   IPCA.ff * IPCA.reseig + sum(IPCA.mdl_3_S_Bx1(IPCA.Q+1:end));
        IPCA.mdl_2_U_DxB          =   IPCA.mdl_2_U_DxB(:,1:IPCA.Q);
        IPCA.mdl_3_S_Bx1              =   IPCA.mdl_3_S_Bx1(1:IPCA.Q);
        if (isfield(IPCA,'projScalars'))
            IPCA.projScalars    =   IPCA.projScalars(1:IPCA.Q,:);
        end
    end

    %find training error
    IPCA                    =   UTIL_METRICS_compute_training_error_RVQ_style(DM2, IPCA, 1);   %2 is the algo code
    