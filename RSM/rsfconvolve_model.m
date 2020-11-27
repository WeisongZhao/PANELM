function y=rsfconvolve_model(in,LR,SR)
alpha=in(:,1);
beta=in(:,2);
gama1=in(:,3);
gama2=in(:,4);

%% load SR & LR and preprocess
X=SR;
B=LR;
X=imresize(X,[size(B,1),size(B,2)]);
B=B./max(B(:));
X=X./max(X(:));
%% generate kernel
kernel=generate_rsf(gama1,gama2);
%% filter
y=zeros([size(alpha,1),1]);
for i=1:size(alpha,1)
    SR_convolv_rsf=imfilter(alpha(i)*X+beta(i),kernel, 'symmetric');
    y(i)=sum(sum((SR_convolv_rsf-B).^2));
end
