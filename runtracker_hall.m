% script: runtracker.m
% requires:
%   data(h,w,nf)
%   param0
%   opt.tmplsize [h,w]
%      .numsample
%      .affsig [6,1]
%      .condenssig

%% Copyright (C) Jongwoo Lim and David Ross.
%% All rights reserved.


% initialize variables
rand('state',0);  randn('state',0);
frame = double(data(:,:,1))/256;

if ~exist('opt','var')  opt = [];  end
if ~isfield(opt,'tmplsize')   opt.tmplsize = [32,32];  end
if ~isfield(opt,'numsample')  opt.numsample = 400;  end
if ~isfield(opt,'affsig')     opt.affsig = [4,4,.02,.02,.005,.001];  end
if ~isfield(opt,'condenssig') opt.condenssig = 0.01;  end

if ~isfield(opt,'maxbasis')   opt.maxbasis = 16;  end
if ~isfield(opt,'batchsize')  opt.batchsize = 5;  end
if ~isfield(opt,'errfunc')    opt.errfunc = 'L2';  end
if ~isfield(opt,'ff')         opt.ff = 1.0;  end
if ~isfield(opt,'minopt')
  opt.minopt = optimset; opt.minopt.MaxIter = 25; opt.minopt.Display='off';
end

tmpl.mean = warpimg(frame, param0, opt.tmplsize);
tmpl.basis = [];
tmpl.eigval = [];
tmpl.numsample = 0;
tmpl.reseig = 0;
sz = size(tmpl.mean);  N = sz(1)*sz(2);

param = [];
param.tst_bestaffine_1x6 = param0;
param.wimg = tmpl.mean;
if (exist('GT','var'))
  numFP = size(GT,2);
  CONFIG.initial_affineROI_1x6 = affparaminv(param.tst_bestaffine_1x6);
  initial_FP_gt = CONFIG.initial_affineROI_1x6([3,4,1;5,6,2]) * [GT(:,:,1); ones(1,numFP)];
  pts = cat(3, initial_FP_gt + repmat(sz'/2,[1,numFP]), GT(:,:,1));
  trackpts = zeros(size(GT));
  trackerr = zeros(1,numFP); meanerr = zeros(1,numFP);
else
  pts = [];
end

% draw initial track window
drawopt = drawtrackresult([], 0, frame, tmpl, param, pts);
disp('resize the window as necessary, then press any key..'); pause;
drawopt.showcondens = 0;  drawopt.thcondens = 1/opt.numsample;

wimgs = [];
if (isfield(opt,'dump') && opt.dump > 0)
  imwrite(frame2im(getframe(gcf)),sprintf('dump/%s.0000.png',title));
  save(sprintf('dump/opt.%s.mat',title),'opt');
end


% track the sequence from frame 2 onward
duration = 0; tic;
if (exist('dispstr','var'))  dispstr='';  end
for f = 1:size(data,3)
  frame = double(data(:,:,f))/256;
  
  % do tracking
%  param = estwarp_grad(frame, tmpl, param, opt);
  param = estwarp_condens(frame, tmpl, param, opt);

  % do update
  wimgs = [wimgs, param.wimg(:)];
  if (size(wimgs,2) >= opt.batchsize)
    if (isfield(param,'coef'))
      num_projScalars = size(param.coef,2);
      recon = repmat(tmpl.mean(:),[1,num_projScalars]) + tmpl.basis * param.coef;
      [tmpl.basis, tmpl.eigval, tmpl.mean, tmpl.numsample] = ...
        hall(wimgs, tmpl.basis, tmpl.eigval, tmpl.mean, tmpl.numsample, opt.ff);
      param.coef = tmpl.basis'*(recon - repmat(tmpl.mean(:),[1,num_projScalars]));
    else
      [tmpl.basis, tmpl.eigval, tmpl.mean, tmpl.numsample] = ...
        hall(wimgs, tmpl.basis, tmpl.eigval, tmpl.mean, tmpl.numsample, opt.ff);
    end
%    wimgs = wimgs(:,2:end);
    wimgs = [];
    
    if (size(tmpl.basis,2) > opt.maxbasis)
      %tmpl.reseig = opt.ff^2 * tmpl.reseig + sum(tmpl.eigval(tmpl.maxbasis+1:end).^2);
      tmpl.reseig = opt.ff * tmpl.reseig + sum(tmpl.eigval(opt.maxbasis+1:end));
      tmpl.basis  = tmpl.basis(:,1:opt.maxbasis);
      tmpl.eigval = tmpl.eigval(1:opt.maxbasis);
      if (isfield(param,'coef'))
        param.coef = param.coef(1:opt.maxbasis,:);
      end
    end
  end
  
  duration = duration + toc;
  % draw result
  if (exist('GT','var'))
    trackpts(:,:,f) = param.tst_bestaffine_1x6([3,4,1;5,6,2])*[initial_FP_gt; ones(1,numFP)];
    pts = cat(3, initial_FP_gt+repmat(sz'/2,[1,numFP]), GT(:,:,f), trackpts(:,:,f));
    idx = find(pts(1,:,2) > 0);
    if (length(idx) > 0)
      % trackerr(f) = mean(sqrt(sum((pts(:,idx,2)-pts(:,idx,3)).^2,1)));
      trackerr(f) = sqrt(mean(sum((pts(:,idx,2)-pts(:,idx,3)).^2,1)));
    else
      trackerr(f) = nan;
    end
    meanerr(f) = mean(trackerr(~isnan(trackerr)&(trackerr>0)));
    if (exist('dispstr','var'))  fprintf(repmat('\b',[1,length(dispstr)]));  end;
    dispstr = sprintf('%d: %.4f / %.4f',f,trackerr(f),meanerr(f));
    fprintf(dispstr);
    figure(2);  plot(trackerr,'r.-');
    figure(1);
  end
  drawopt = drawtrackresult(drawopt, f, frame, tmpl, param, pts);
  %%% UNCOMMENT THIS TO SAVE THE RESULTS (uses a lot of memory)
  %%% saved_params{f} = param;
  if (isfield(opt,'dump') && opt.dump > 0)
    imwrite(frame2im(getframe(gcf)),sprintf('dump/%s.%04d.png',title,f));
  end
  tic;
end
duration = duration + toc;
fprintf('%d frames took %.3f seconds : %.3fps\n',f,duration,f/duration);

