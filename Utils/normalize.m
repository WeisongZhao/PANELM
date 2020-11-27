function img=normalize(img)
for i=1:size(img,3)
    img(:,:,i)=img(:,:,i)./max(max(img(:,:,i)));
end