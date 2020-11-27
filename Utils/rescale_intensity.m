function output=rescale_intensity(input)
% skimage.exposure.rescale_intensity(input,0,100)
output=255*input;
output(output>255)=255;
GM=mean(output,3);
hmin=min(GM(:));
output=(output-hmin)/(255-hmin);
output(output<0)=0;
