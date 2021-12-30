function [FRCMap,PANELs,RSM,absolute_value,SR_convolve_rsf]...
    = PANEL(SRstack,varargin)
%***************************************************************************
% PANEL
%***************************************************************************
% function [FRCMap,PANELs,RSM,absolute_value,SR_convolve_rsf]
% = PANEL(SRstack,varargin)
%-----------------------------------------------
%Source code for rFRC map and RSM error mapping
%SRstack    input data to be evaluated
%varargin   configurations
%------------------------------------------------
%***************************Configurations***********************************
% ATTENTION: 
% The 3D dataset should be pre-normalized as [0~1],
% and slice-by-slice as input of PANEL.
%-------image property----------
%LRstack  |  the corresponding LR input {default: zeros(size(SRstack))}
%lowdose  |  whether the input LR is under low SNR {default: false}
%preblur2LR  |  the pre Gaussian filter size on the input LR {default: 3}
%pixelSize  |  pixel size in micron {default: 0.0325}
%boundaryintensity  | background intensity (0~255 range, 8bit) {default: 5}
%EnableRSM  |  if estimate the RSM {default: true}
%IS3D  |  if the input SR is 3D {default: false}
%-----------rFRC----------------
%driftCorrection  |  if do drift correction {default: false}
%blocksize  |  rFRC block size {default: 64}
%skip  |  skip size to accelerate {default: 1}
%enableSingleFrame  |  whether enable single frame FRC {default: false}
%boundary  |  whether calculate background {default: true}
%IF_adaptive_boundary  |  whether adaptive background threshold {default: false}
%amedianfilter  |  whether do adaptive filter after rFRC mapping {default: true}
%EnableOstu  |  whether enable otsu filter in PANEL merging {default: true}
%mapping0143  |  whether use 1/7 threshold {default: false}
%***************************************************************************
%Output:
%  rFRC map, Full PANEL, RSM, metrics, SRstack convoluted by RSF
%***************************************************************************
% Written by WeisongZhao @ zhaoweisong950713@163.com
% Version 0.4.5
% if any bugs is found, please just email me or put an issue on the github.
%***************************************************************************
% https://github.com/WeisongZhao/PANELM/
% *********************************************************************************
% It is a part of publication:
% Weisong Zhao et al. PANEL: quantitatively mapping reconstruction errors in
% super-resolution scale via rolling Fourier ring correlation,
% Nature Methods (2022).
% *********************************************************************************
%    Copyright 2019~2022 Weisong Zhao et al.
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the Open Data Commons Open Database License v1.0.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
%    Open Data Commons Open Database License for more details.
%
%    You should have received a copy of the
%    Open Data Commons Open Database License
%    along with this program.  If not, see:
%    <https://opendatacommons.org/licenses/odbl/>.
%***************************************************************************
warning off;
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
%-----------rFRC----------------
params.driftCorrection = false;
params.blocksize = 64;
params.skip = 1;
params.enableSingleFrame = false;
params.boundary = true;
params.IF_adaptive_boundary = false;
params.amedianfilter = true;
params.LRstack = zeros(size(SRstack));
params.EnableOtsu = true;
params.mapping0143 = false;
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
PANELs=RGBnor(RSM,FRCMap,params.EnableOtsu);

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
disp(['Total time cost: ', num2str(2 * ttime/60) ' mins'])