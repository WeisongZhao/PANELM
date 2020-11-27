clear;clc
addpath('.\Utils')
addpath('.\fSNR')
addpath('.\RSM')
stack(:,:,1)=double(imread('fused-MT-pan\SMLM-fusion-odd-FRC.tif'));
stack(:,:,2)=double(imread('fused-MT-pan\SMLM-fusion-even-FRC.tif'));
stackraw(:,:,1)=double(imread('fused-MT-pan\AVG_STORM_256x256_0003-even.tif'));
stackraw(:,:,2)=double(imread('fused-MT-pan\AVG_STORM_256x256_0003-even.tif'));
%%
name='fused-MT-pan';
dir='fused-MT-pan';
bs=64;
[FRCMap,PANELs,RSM,absolute_value,SR_convolve_rsf]...
    =PANEL(stack,'LRstack',stackraw,'pixelSize'...
    ,20/1000,'skip',1,'boundaryintensity',15,'blocksize',bs,'EnableRSM',false);
save ([dir,'\',name,'-',num2str(bs),'-FRC.mat'])



