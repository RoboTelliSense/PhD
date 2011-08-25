function param = estwarp_grad(frm, tmpl, param, opt)
% function param = estwarp_grad(frm, tmpl, param, opt)
%

%% Copyright (C) Jongwoo Lim and David Ross.
%% All rights reserved.


if (~isfield(opt,'minopt'))
    opt.minopt = optimset;
    opt.minopt.Display='off';
    opt.minopt.LargeScale='off';
end
if isstruct(tmpl)
  sz = size(tmpl.mean);
else
  sz = size(tmpl)
end

if (isfield(opt,'affsig'))
  opt.param0 = affparam2geom(param.tst_bestaffine_1x6);
%disp(cat(1,p0,opt.param0,affparam2mat(opt.param0)));
disp(opt.param0);
end
param.tst_bestaffine_1x6 = fminsearch(@esterrfunc, param.tst_bestaffine_1x6, opt.minopt, frm, tmpl, opt);
%p = lsqnonlin(@esterrfunc, p0, [],[], opt.minopt, frm, tmpl, opt);
param.wimg = warpimg(frm, param.tst_bestaffine_1x6, sz);
[err,afferr,param.recon,param.err] = esterrfunc(param.tst_bestaffine_1x6, frm, tmpl, opt);
disp(sprintf(' %9.5f  %9.5f\n', [err-afferr, afferr]));
