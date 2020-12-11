function [xv,yv,v]=fSNRmap0143(stackraw,params)
% using 1/7 threshold
[ox,oy,~]=size(stackraw);
bsize=params.blocksize;
if mod(bsize,2)~=0
    bsize=bsize+1;
end
stackraw=padarray(stackraw,[bsize/2,bsize/2,0],'symmetric');
flage=1;
tflage=1;
total=length(1:params.skip:ox)*length(1:params.skip:oy);
v(1)=0;
xv(1)=1;
yv(1)=1;
center = params.skip - 1;
tic
for i=1:params.skip:ox
    for j=1:params.skip:oy
        a=stackraw(i:i+bsize-1,j:j+bsize-1,1);
        b=stackraw(i:i+bsize-1,j:j+bsize-1,2);
        % aboundary=a( bsize/2-center: bsize/2+center,bsize/2-center: bsize/2+center);
        % bboundary=b( bsize/2-center: bsize/2+center,bsize/2-center: bsize/2+center);
        aboundary=a( bsize/2: bsize/2+center,bsize/2: bsize/2+center);
        bboundary=b( bsize/2: bsize/2+center,bsize/2: bsize/2+center);
        if params.boundary
            threshold = params.boundaryintensity * 2/255;
        else
            threshold = eps * 2;
        end
        if mean(aboundary(:) + bboundary(:)) > threshold
            a=a./max(a(:));
            b=b./max(b(:));
            FRCresult= FRCAnalysis(a, b,params);
            ifmask(1)=(FRCresult.Resolution.fixedThreshold_largeAngles);
            ifmask(2)=(FRCresult.Resolution.threeSigma_largeAngles);
            
            minres = ifmask(1);
            if isnan(minres)
                minres = ifmask(2);
                if params.enableSingleFrame ~= 1
                    minres = minres/1.1;
                end
            end
            
            if params.enableSingleFrame
                point=FRCresult.CutOff.fixedThreshold_largeAngles/ length(FRCresult.FixedThreshold);
                if isnan(point)
                    point=FRCresult.CutOff.threeSigma_largeAngles/ length(FRCresult.ThreeSigma);
                    minres=minres/correction(point)/(1.1);
                else
                    minres=minres/correction(point);
                end
            end
            
            if isnan(minres)==0
                if params.skip==1
                    v(flage)=minres;
                    xv(flage)=i;
                    yv(flage)=j;
                    flage=flage+1;
                else
                    for x=1:params.skip
                        for y=1:params.skip
                            v(flage)=minres;
                            xv(flage)=min(i+x-1,ox);
                            yv(flage)=min(j+y-1,oy);
                            flage=flage+1;
                        end
                    end
                end
            end
        end
        if mod(tflage,round(total/3))==0
            time=toc;
            disp(['Percent : ' num2str(100*tflage/total,3) '%' ', Time : '...
                ,num2str(time/60,4),' mins'])
        end
        tflage=tflage+1;
    end
end
end

function y=correction(x)

para = [0.95988146, 0.97979108, 13.90441896, 0.55146136];

y=para(1) * exp(para(3) * (x - para(2))) + para(4);

end