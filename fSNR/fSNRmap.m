function [xv,yv,v] = fSNRmap(stackraw,params)

[ox,oy,~] = size(stackraw);
bsize = params.blocksize;
if mod(bsize,2)~=0
    bsize = bsize + 1;
end

if params.IF_adaptive_boundary && params.boundary
    background(:,:,1) = background_estimation(stackraw(:,:,1));
    background(:,:,2) = background_estimation(stackraw(:,:,2));
    background(background < 0) = 0;
    background = background./max(background(:));
    background = (params.boundaryintensity * 4/255) * background;
else
    background = ones(size(stackraw)) * params.boundaryintensity * 2/255;
end

stackraw = padarray(stackraw,[bsize/2,bsize/2,0],'symmetric');
background = padarray(background,[bsize/2,bsize/2,0],'symmetric');
flage = 1;

% tflage=1;
% total=length(1:params.skip:ox)*length(1:params.skip:oy);

v(1) = 0;
xv(1) = 1;
yv(1) = 1;
center = params.skip - 1;
tic
iindex = 1:params.skip:ox;
jindex = 1:params.skip:oy;
fSNR_values = zeros(length(iindex),length(jindex));
fSNR_i = fSNR_values;
fSNR_j = fSNR_values;
for i_= 1:length(iindex)
    i = iindex(i_);
    for j_ = 1:length(jindex)
        j = jindex(j_);
        minres = 0;
        a = stackraw(i:i+bsize-1,j:j+bsize-1,1);
        b = stackraw(i:i+bsize-1,j:j+bsize-1,2);
        % aboundary=a( bsize/2-center: bsize/2+center,bsize/2-center: bsize/2+center);
        % bboundary=b( bsize/2-center: bsize/2+center,bsize/2-center: bsize/2+center);
        aboundary = a(bsize/2: bsize/2 + center,bsize/2: bsize/2 + center);
        bboundary = b(bsize/2: bsize/2 + center,bsize/2: bsize/2 + center);
        if params.boundary
            if ~params.IF_adaptive_boundary
                threshold = params.boundaryintensity * 2/255;
            else
                threshold = mean(mean(mean(background(i+bsize/2: i+bsize/2+center,j+bsize/2: j+bsize/2+center,:))));
            end
        end
        if mean(aboundary(:) + bboundary(:)) > threshold
            a = a./max(a(:));
            b = b./max(b(:));
            FRCresult = FRCAnalysis(a, b,params);
            ifmask = [FRCresult.Resolution.fixedThreshold_largeAngles...
                FRCresult.Resolution.twoSigma_largeAngles,...
                FRCresult.Resolution.threeSigma_largeAngles,...
                FRCresult.Resolution.fiveSigma_largeAngles];
            
            minres = ifmask(3);
            if isnan(minres)
                minres = ifmask(4);
                if params.enableSingleFrame ~= 1
                    minres = minres / (5/3)^2;
                end
            end
            if isnan(minres)
                minres = ifmask(2);
                if params.enableSingleFrame ~= 1
                    minres = minres / (2/3)^2;
                end
            end
%             if isnan(minres)
%                 minres = ifmask(1);
%                 if params.enableSingleFrame ~= 1
%                     minres = minres * 1.143^2;
%                 end
%             end            
            if params.enableSingleFrame
                point = FRCresult.CutOff.threeSigma_largeAngles / length(FRCresult.ThreeSigma);
                
                if isnan(point)
                    point = FRCresult.CutOff.fiveSigma_largeAngles / length(FRCresult.FiveSigma);
                else
                    minres = minres / correction(point);
                end
                if isnan(point)
                    point = FRCresult.CutOff.twoSigma_largeAngles / length(FRCresult.TwoSigma);
                    minres = minres/correction(point)/(2/3);
                else
                    minres = minres/correction(point)/(5/3);
                end
                
            end
        end
        if isnan(minres)==0
            fSNR_values(i_,j_) = minres;
            fSNR_i(i_,j_) = i;
            fSNR_j(i_,j_) = j;
        end
        %         if mod(tflage,round(total/3))==0
        %             time=toc;
        %             disp(['Percent : ' num2str(100*tflage/total,3) '%' ', Time : '...
        %                 ,num2str(time/60,4),' mins'])
        %         end
        %         tflage=tflage+1;
    end
end

for i = 1:size(fSNR_values,1)
    for j = 1:size(fSNR_values,2)
        if fSNR_values(i,j)~=0
            if params.skip==1
                v(flage)=fSNR_values(i,j);
                xv(flage)=fSNR_i(i,j);
                yv(flage)=fSNR_j(i,j);
                flage=flage+1;
            else
                for x=1:params.skip
                    for y=1:params.skip
                        v(flage) = fSNR_values(i,j);
                        xv(flage) = min(fSNR_i(i,j)+x-1,ox);
                        yv(flage) = min(fSNR_j(i,j)+y-1,oy);
                        flage=flage+1;
                    end
                end
            end
        end
    end
end

time = toc;
disp(['rFRC mapping done' ', Time : ',num2str(time/60,4),' mins'])

end

function y=correction(x)

para = [0.95988146, 0.97979108, 13.90441896, 0.55146136];

y=para(1) * exp(para(3) * (x - para(2))) + para(4);

end