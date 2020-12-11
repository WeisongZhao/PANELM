clear;clc;close all;
addpath('.\Utils')
addpath('.\fSNR')
addpath('.\RSM')
stack = imreadstack('LDSMLM_20nmpixel_background_15.tif');
stackraw(:,:,1) = double(imread('LDWF.tif'));
stackraw(:,:,2) = stackraw(:,:,1);
%%
[FRCMap,PANELs,RSM,absolute_value,SR_convolve_rsf]...
    = PANEL(stack,'LRstack',stackraw,'pixelSize'...
    ,20/1000,'skip',1,'boundaryintensity',15,'blocksize',64,'EnableRSM',false);
%%
figure(1)
subplot(1,2,1)
imshow(stackraw(:,:,1),[])
title(['Low resolution']);
subplot(1,2,2)
imshow(stack(:,:,1),[],'color',hot)
title(['SMLM result']);
suptitle('RAW INPUT DATA');
figure(2)
subplot(1,3,1)
imshow(RSM,[],'color',RSMerrorlut)
title(['RSM']);
h = colorbar('South');
h.Label.String = '(a.u.)';
set(h,'Color',[1 1 1])
subplot(1,3,2)
imshow(FRCMap,[0 256],'color',sjet)
title(['rFRC map']);
h = colorbar('South');
h.Label.String = '(nm)';
set(h,'Color',[1 1 1])
subplot(1,3,3)
imshow(PANELs)
title(['Full PANEL']);
suptitle('PANELM - Pixel-level ANalysising of Error Locations with Matlab');


