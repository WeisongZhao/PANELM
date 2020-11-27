function img2save=Local_Normalization(img,local_sigma_mean,local_sigma_variance)
img=im2double(img);
img1 = imgaussfilt(img,local_sigma_mean);
img2=img-img1;
img2save=img2./sqrt(imgaussfilt(img2.^2,local_sigma_variance));
img2save=img2save-min(img2save(:));
img2save=img2save./max(img2save(:));