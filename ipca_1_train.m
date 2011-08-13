%-------------------------------------------------------------------------
%
%-------------------------------------------------------------------------
function [sIPCA, sIPCA_cond] = ipca_1_train(DM2, sIPCA, sIPCA_cond, sOptions)

    
    if (isfield(sIPCA_cond,'coef'))
        ncoef                                                               =   size(sIPCA_cond.coef,2);
        recon                                                               =   repmat(sIPCA.mean(:),[1,ncoef]) + sIPCA.basis * sIPCA_cond.coef;
        [sIPCA.basis, sIPCA.eigval, sIPCA.mean, sIPCA.Np]   =   sklm(DM2, sIPCA.basis, sIPCA.eigval, sIPCA.mean, sIPCA.Np, sOptions.ff);
        sIPCA_cond.coef                                                  =   sIPCA.basis'*(recon - repmat(sIPCA.mean(:),[1,ncoef]));
    else
        [sIPCA.basis, sIPCA.eigval, sIPCA.mean, sIPCA.Np]   =   sklm(DM2, sIPCA.basis, sIPCA.eigval, sIPCA.mean, sIPCA.Np, sOptions.ff);
    end


    if (size(sIPCA.basis,2) > sOptions.maxbasis)
        %sIPCA.reseig = sOptions.ff^2 * sIPCA.reseig + sum(sIPCA.eigval(sIPCA.maxbasis+1:end).^2);
        sIPCA.reseig                                                    =   sOptions.ff * sIPCA.reseig + sum(sIPCA.eigval(sOptions.maxbasis+1:end));
        sIPCA.basis                                                     =   sIPCA.basis(:,1:sOptions.maxbasis);
        sIPCA.eigval                                                    =   sIPCA.eigval(1:sOptions.maxbasis);
        if (isfield(sIPCA_cond,'coef'))
            sIPCA_cond.coef                                              =   sIPCA_cond.coef(1:sOptions.maxbasis,:);
        end
    end

    %find training error
    sIPCA.trgout_U_DxD                                                =   sIPCA.basis;
    sIPCA.trgout_M_Dx1                                                =   sIPCA.mean(:);
    sIPCA.tstprm_Neig_1x1                                             =   sOptions.maxbasis; 

    sIPCA                                                             =   UTIL_METRICS_compute_training_error_RVQ_style(DM2, sIPCA, 1);   %2 is the algo code