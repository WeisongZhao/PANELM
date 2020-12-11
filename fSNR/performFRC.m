function [ FRC, twoSigma,threeSigma, fiveSigma] =  performFRC(fftA, fftB, h, w, theta)
% [FRC, threeSigma, fiveSigma] =  performFRC(fftA, fftB, h, w)
%
% Calculates FRC curve; 3Sigma and 5Sigma threshold curves

xc = ceil((w+1)./2);
yc = ceil((h+1)./2);

rMax = min( w - xc, h - yc);
FRC.smallAngles = zeros(rMax+1,1,'single');
FRC.largeAngles = zeros(rMax+1,1,'single');
twoSigma = zeros(rMax+1,1,'single');
threeSigma = zeros(rMax+1,1,'single');
fiveSigma = zeros(rMax+1,1,'single');

for r = 0 : rMax
    corr_smallAngles = 0;
    absA_smallAngles = 0;
    absB_smallAngles = 0;
    corr_largeAngles = 0;
    absA_largeAngles = 0;
    absB_largeAngles = 0;
    
    for x = 1 : w
        for y = 1 : h
            if ( sqrt((x-xc)^2+(y-yc)^2) >= ...
                    r-0.5 && sqrt((x-xc)^2+(y-yc)^2) < r + 0.5 )
                if  (theta == 0) || ...
                        ( atan( abs(y-yc) / ( abs(x-xc) + eps) ) > theta )
                    corr_largeAngles = ...
                        corr_largeAngles + fftA(y,x)*conj(fftB(y,x));
                    absA_largeAngles = ...
                        absA_largeAngles + abs(fftA(y,x)^2);
                    absB_largeAngles = ...
                        absB_largeAngles + abs(fftB(y,x)^2);
                else
                    corr_smallAngles = ...
                        corr_smallAngles + fftA(y,x)*conj(fftB(y,x));
                    absA_smallAngles = ...
                        absA_smallAngles + abs(fftA(y,x)^2);
                    absB_smallAngles = ...
                        absB_smallAngles + abs(fftB(y,x)^2);
                end
                
                %need to compute threshold curves
                twoSigma(r+1) = twoSigma(r+1) + 1;
                threeSigma(r+1) = threeSigma(r+1) + 1;
                fiveSigma(r+1) = fiveSigma(r+1) + 1;
                
            end
        end
    end
    FRC.smallAngles(r+1) = abs(corr_smallAngles) / ...
        ((absA_smallAngles*absB_smallAngles)^0.5 + eps);
    FRC.largeAngles(r+1) = abs(corr_largeAngles) / ...
        ((absA_largeAngles*absB_largeAngles)^0.5 + eps);
end

%compute threshold curves
for r = 0 : rMax
    twoSigma(r+1) = 2 / (sqrt(twoSigma(r+1)/2));
    threeSigma(r+1) = 3 / (sqrt(threeSigma(r+1)/2));
    fiveSigma(r+1) = 5 / (sqrt(fiveSigma(r+1)/2));
    
    %     if(threeSigma(r+1) > 1)
    %         threeSigma(r+1) = 1;
    %     end
    %     if(fiveSigma(r+1) > 1)
    %         fiveSigma(r+1) = 1;
    %     end
    
end
threeSigma(threeSigma>1)=0;
fiveSigma(fiveSigma>1)=0;
twoSigma(twoSigma>1)=0;
end