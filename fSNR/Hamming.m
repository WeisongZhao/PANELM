function [ hamming ] =  Hamming( w, h )
% [ hamming ] =  Hamming( w, h )
% computes Hamming function
alpha = 0.54;
beta = 1-alpha;

xv = alpha - beta * cos (2*pi/(w-1)*(0:1:(w-1)));
yv = alpha - beta * cos (2*pi/(h-1)*(0:1:(h-1)));

hamming = (yv')*xv;

end