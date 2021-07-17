function PANEL = RGBnor(RSM,FRCMaps,otsu)
RSM(RSM<0.4) = 0;
inter = FRCMaps;
inter(inter==0) = max(inter(:));
minfrc = min(inter(:));
FRCMaps = FRCMaps./minfrc - 1;
FRCMaps(FRCMaps > 1) = 1;
if otsu
    FRCMaps = FRCMaps - 0.4;
    level = graythresh(FRCMaps);
    FRCMaps(FRCMaps<level*max(FRCMaps(:))) = 0;
    FRCMaps(FRCMaps > 1) = 1;
end
PANEL = cat(3,1.9639*RSM,FRCMaps./max(FRCMaps(:)),zeros(size(FRCMaps)));