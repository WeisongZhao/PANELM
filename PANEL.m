function [FRCMap,PANELs,RSM,absolute_value,SR_convolve_rsf]...
    = PANEL(SRstack,varargin)
%-------image property----------
% if low SNR LR
params.lowdose = false;
params.preblur2LR = 3;
% pixel size
params.pixelSize = 0.0325;
% background intensity (0~255 range, 8bit)
params.boundaryintensity = 5;
% if enable RSM
params.EnableRSM = true;
% if 3D
params.IS3D = false;
%-----------tSNR----------------
% drift para
params.driftCorrection = false;
% FRC map para
params.blocksize = 64;
params.skip = 1;
params.enableSingleFrame = false;
% output para
params.boundary = true;
params.amedianfilter = true;
params.LRstack = zeros(size(SRstack));
%%
addpath('.\Utils')
addpath('.\fSNR')
addpath('.\RSM')
if nargin > 1
    params = read_params(params, varargin);
end
tic
disp(['PANEL estimation start...'])

[xs,ys,t]=size(SRstack);
SR=double(SRstack);
if params.EnableRSM == 1
    LR=double(params.LRstack);
    [xl,yl,~]=size(LR);
    mag=[xs/xl,ys/yl,1];
    if size(LR,3)~=size(SR,3)
        LR = padarray(LR,[0,0,size(SR,3)-size(LR,3)],'post','replicate');
    end
else
    mag=[1,1];
end


if params.lowdose
    LR = imgaussfilt(LR,params.preblur2LR);
end

if mag(1) ~= 1 || mag(2) ~= 1
    LR = fourierInterpolation(LR,floor(mag),'lateral');
end

if params.EnableRSM == 1
    if size(LR)~=size(SR)
        for f=1:size(LR,3)
            LR(:,:,f)=imresize(LR(:,:,f),[xs,ys]);
        end
    end
end

if params.EnableRSM == 1 && params.IS3D == 0
    LR=normalize(LR);
    SR=normalize(SR);
elseif params.EnableRSM == 0 && params.IS3D == 0
    SR=normalize(SR);
end

if params.EnableRSM == 1
    disp('Resolution scaled error map estimation...')
    SR_convolve_rsf = RSMap(LR,SR);
    [RSE,RSP,RSSIM,RSM] = compute_RSE_RSP(LR,SR_convolve_rsf);
else
    RSP=NaN;
    RSE=NaN;
    RSSIM=NaN;
    RSM=zeros(xs,ys);
    SR_convolve_rsf=RSM;
end
disp('High-resolution fSNR estimation...')
FRCMap = fSNR_stack(single(SR),params);

disp('Essemble...')
PANELs=RGBnor(RSM,FRCMap);

inter=FRCMap;
inter(inter==0) = max(inter(:));
minfrc = min(inter(:));
remove0 = FRCMap;
remove0(remove0 > 0)=1;
FRC_absolute=(sum(FRCMap(:))./sum(remove0(:))./minfrc)-1;
FRC_mean=(sum(FRCMap(:))./sum(remove0(:)));
absolute_value=[FRC_absolute,FRC_mean,RSE,RSP,RSSIM];
fprintf(strcat('Absolute score of error:', '\n', ...
    num2str(absolute_value(1)),' fSNR' , '\n', ...
    num2str(absolute_value(2)),' nm, mean resolution' , '\n', ...
    num2str(absolute_value(3)),' RSE', '\n' ));

disp('PANEL estimation done, thank you for your waiting')

ttime=toc;
disp(['Total time cost: ', num2str(2 * ttime/60) ' mins' ...
    ' for ' num2str(t-1) ' frames'])
