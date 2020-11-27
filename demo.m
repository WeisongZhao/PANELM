clear;clc;close all;
addpath('.\Utils')
addpath('.\fSNR')
addpath('.\RSM')
stack = imreadstack('MT SMLM Large - 4096 x 4096_pixelsize10nm.tif');
stack = stack(8*16 + 1:end-8*16,8*16 + 1:end-8*16,:);
stackraw(:,:,1) = double(imread('WF.tif'));
stackraw(:,:,2) = stackraw(:,:,1);
stackraw = stackraw(8 + 1:end-8,8 + 1:end-8,:);
%%
[FRCMap,PANELs,RSM,absolute_value,SR_convolve_rsf]...
    = PANEL(stack,'LRstack',stackraw,'pixelSize'...
    ,10/1000,'skip',1,'boundaryintensity',15,'blocksize',64,'EnableRSM',false);
%%
figure(1)
subplot(1,2,1)
imshow(stackraw(8 + 1:end-8,8 + 1:end-8,1),[])
title(['Low resolution']);
subplot(1,2,2)
imshow(stack(8*16 + 1:end-8*16,8*16 + 1:end-8*16,1),[],'color',hot)
title(['SMLM result']);
suptitle('RAW INPUT DATA');
figure(2)
subplot(1,3,1)
imshow(RSM(8*16 + 1:end-8*16,8*16 + 1:end-8*16),[],'color',RSMerrorlut)
title(['RSM']);
h = colorbar('South');
h.Label.String = '(a.u.)';
set(h,'Color',[1 1 1])
subplot(1,3,2)
imshow(FRCMap(8*16 + 1:end-8*16,8*16 + 1:end-8*16),[],'color',sjet)
title(['rFRC map']);
h = colorbar('South');
h.Label.String = '(nm)';
set(h,'Color',[1 1 1])
subplot(1,3,3)
imshow(PANELs(8*16 + 1:end-8*16,8*16 + 1:end-8*16,:))
title(['Full PANEL']);
suptitle('PANELM - Pixel-level ANalysising of Error Locations with Matlab');


