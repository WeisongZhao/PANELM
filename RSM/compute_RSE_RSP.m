function [RSE,RSP,RSSIM,RSM]=compute_RSE_RSP(LR,SR_con)

RSM=mean(abs(LR-SR_con),3);
for i=1:size(LR,3)
    RSSIM(i) = ssim(SR_con(:,:,i),LR(:,:,i));
    %% compute RSE RSP
    RSE(i)=sqrt(mean(mean((LR(:,:,i)-SR_con(:,:,i)).^2)));
    a=LR(:,:,i)-mean(mean(LR(:,:,i)));
    b=SR_con(:,:,i)-mean(mean(SR_con(:,:,i)));
    c=mean(mean(a.*b));
    d=sqrt(mean(mean(a.^2))*mean(mean(b.^2)));
    RSP(i)=c/d;
end
RSE=mean(RSE);
RSP=mean(RSP);
RSSIM=mean(RSSIM);