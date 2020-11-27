function elut = RSMerrorlut
load('errorlut.mat')
elut = double(errorlut)./255;