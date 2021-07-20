clear;clc;close all;
%% read data
stackSR = imreadstack('HDSMLM_20nmpixel_background_15.tif');
stackLR = imreadstack('HDWF.tif');
%% PANEL mapping
[FRCMap,PANELs,RSM,absolute_value,SR_convolve_rsf]...
    = PANEL(stackSR,'LRstack',stackLR,'pixelSize',20/1000, ...
    'boundaryintensity',15,'EnableOtsu',false);
%% visualization
figure(1);suptitle('RAW INPUT DATA');
subplot(1,2,1);imshow(stackLR(:,:,1),[]);title(['Low resolution']);
subplot(1,2,2);imshow(stackSR(:,:,1),[],'color',hot);title(['SMLM result']);
figure(2);suptitle('PANELM - Pixel-level ANalysising of Error Locations with MATLAB');
subplot(1,3,1);imshow(RSM,[],'color',RSMerrorlut);title(['RSM']);
h = colorbar('South');h.Label.String = '(a.u.)';set(h,'Color',[1 1 1]);
subplot(1,3,2);imshow(FRCMap,[0 256],'color',sjet);title(['rFRC map']);
h = colorbar('South');h.Label.String = '(nm)';set(h,'Color',[1 1 1]);
subplot(1,3,3);imshow(PANELs);title(['Full PANEL']);


