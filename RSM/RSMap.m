function SR_convolv_fit_rsf = RSMap(stackLR,stackSR)

% tic
for frame=1:size(stackLR,3)
    LR=stackLR(:,:,frame);
    SR=stackSR(:,:,frame);
    h=@(in)rsfconvolve_model(in,LR,SR);
    % options = optimoptions('particleswarm','SwarmSize',400,'HybridFcn',@fmincon);
    % [pso_out,~,~,~] = particleswarm(h,4,[eps -1 eps eps],[10 1 25 25],options);
%      options = optimoptions('patternsearch','Cache','on','UseParallel',true,'UseCompletePoll',true,'UseVectorized',true);
%      options = optimoptions('patternsearch','UseVectorized',true);
%     [pso_out,~,~,~]=patternsearch(h,[1 0 eps eps],[],[],[],[],[eps -1 eps eps],[18 1 25 25],options);
    [pso_out,~,~,~]=patternsearch(h,[1 0 eps eps],[],[],[],[],[eps -1 eps eps],[18 1 25 25]);
    fit_fine_kernel=generate_rsf(pso_out(3),pso_out(4));
    fprintf(['RSM estimated para.: \n' ...
        'Intensity1: ' num2str(pso_out(1)) '\n'...
        'Intensity2: ' num2str(pso_out(2)) '\n'...
        'Sigmax: ' num2str(pso_out(3)) '\n'...
        'Sigmay: ' num2str(pso_out(4)) '\n']);
    SR_convolv_fit_rsf(:,:,frame)=imfilter( pso_out(1) * SR + pso_out(2),...
        fit_fine_kernel, 'symmetric');
end
% toc
