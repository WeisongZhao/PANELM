function blackjet = bjet
blackjet = uint8(jet(256) * 255);
blackjet(1,:) = 0;
%% for imagej
if exist('bJet.lut','file')==0
    dlmwrite('bJet.lut',blackjet);
end
%% for matlab
blackjet = double(blackjet);
blackjet = blackjet./255;
blackjet = squeeze(blackjet);