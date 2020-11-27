function y=generate_rsf(gama1,gama2)
    sigma=max(gama1,gama2);
    kernelRadius = ceil(sigma* sqrt(-2* log(0.0002)))+1;
    ii=-kernelRadius:kernelRadius;
    rsf_x=1/2*(erf((ii+0.5)./(sqrt(2).*gama1))-erf((ii-0.5)./(sqrt(2).*gama2)));
    kernel= rsf_x'* rsf_x;
    y=kernel./sum(kernel(:));
end