function shiftedjet = sjet
shiftedjet=zeros(256,3,'uint8');
roll=42;
shiftedjet(1:roll,3)=linspace(0,255,roll);

shiftedjet(roll+1:2*roll,3)=255*ones(1,roll);
shiftedjet(roll+1:2*roll,1)=linspace(0,255,roll);

shiftedjet(2*roll+1:3*roll,1)=255*ones(1,roll);
shiftedjet(2*roll+1:3*roll,3)=linspace(255,0,roll);

shiftedjet(3*roll+1:4*roll,1)=255*ones(1,roll);
shiftedjet(3*roll+1:4*roll,2)=linspace(0,255,roll);

shiftedjet(4*roll+1:5*roll,2)=255*ones(1,roll);
shiftedjet(4*roll+1:5*roll,1)=linspace(255,0,roll);
shiftedjet(5*roll+1:6*roll,2)=255*ones(1,roll);
shiftedjet(5*roll+1:6*roll,1)=linspace(0,255,roll);
shiftedjet(5*roll+1:6*roll,3)=linspace(0,255,roll);

shiftedjet(6*roll+1:256,1)=255*ones(1,4);
shiftedjet(6*roll+1:256,2)=255*ones(1,4);
shiftedjet(6*roll+1:256,3)=255*ones(1,4);
%% for imagej
% dlmwrite('sJet.lut',shiftedjet);
%% for matlab
shiftedjet = double(shiftedjet);
shiftedjet = shiftedjet./255;
shiftedjet = squeeze(shiftedjet);