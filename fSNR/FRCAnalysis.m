function [result] =  FRCAnalysis(im1, im2, params)
% [result] =  FRCAnalysis (im1, im2, varargin)
%
% Performs FRC analysis on two images. If images are 3D, FRC is computed for each
% plane.
%
% Input arguments:
%   im1:                2D or 3D matrix containing photon counts of the first
%                       measurement
%   im2:                2D or 3D matrix containing photon counts of the second
%                       measurement
%
% Varargin:
%   pixelSize           (default 0.025 um)
%   driftCorrection:    if true, perform drift correction before FRC
%                       analysis (default false);
%   meanFilterWidth:    radius of the mean filter used to perform smooth
%                       the FRC curve (default 3 frequency bins);
%   maxIterations:      maximum iterations for the gaussian fitting
%                       performed when applying drift detection algoritm (default 200)
%   roiRadius:          radius of the crosscorrelation function considered for gaussian fitting
%                       when applying drift detection algoritm (default 5 pixels)
%   theta:              if set, for each ring split the FRC analysis for pixels in the
%                       frequency domain for which -theta < angle < +theta
%                       (0 rad). 0 <= theta <= (pi/2)
%
%
% Output parameters:
%   result:             struct containing all parameters and result of the
%                       FRC analysis
%


params.meanFilterWidth = 3;
params.theta = 0;
if (params.theta > pi/2 || params.theta < 0)
    warning('theta > pi/2 | theta < 0; forcing to 0. ');
    params.theta = 0;
end

try
    %check if the two images have same dimension and are squared
    assert( length(size(im1)) == length(size(im2)),...
        'MATLAB:differentDimensions', 'length(size(im1)) != length(size(im2)');
    assert(nnz( size(im1) == size(im2) ) == length(size(im1)),...
        'MATLAB:differentSizes', 'size(im1) != size(im2)');
    [h, w, d] = size(im1);
    assert( h == w , 'MATLAB:nonSquared','h != w');
    
    im1 = double(im1);
    im2 = double(im2);
    N = size(im1,1);  %   Number of pixels
    
    if mod(N,2)==0
        Scale = (0:(N/2-1))/(params.pixelSize*N);
    else
        Scale = (0:(N/2))/(params.pixelSize*N);
    end
    
    Scale = Scale';
    Hm = Hamming(N,N); %   Hamming function
    %Shift = [0 0];
    Shift = zeros(1,2,d,'single');
    
    for cDepth = 1 : d
        tmpIm1 = im1(:,:,cDepth);
        tmpIm2 = im2(:,:,cDepth);
        
        fftA = fftshift(fft2(tmpIm1 .* Hm));
        fftB = fftshift(fft2(tmpIm2 .* Hm));
        
        [FRC,twoSigma, threeSigma, fiveSigma] =  performFRC(fftA, fftB, h, w,params.theta );
        
        sFRC.smallAngles =  meanFilter(FRC.smallAngles, params.meanFilterWidth);         % smooth FRC via mean filter
        sFRC.largeAngles =  meanFilter(FRC.largeAngles, params.meanFilterWidth);
        
        fixedThreshold = 1/7 * ones(size(Scale,1),1);
        
        % CutOff frequencies for different threshold criteria - build a
        % function
        cutOff.fixedThreshold_smallAngles =  findIntercept(sFRC.smallAngles, fixedThreshold);
        cutOff.threeSigma_smallAngles =  findIntercept(sFRC.smallAngles, threeSigma);
        cutOff.fiveSigma_smallAngles =  findIntercept(sFRC.smallAngles, fiveSigma);
        cutOff.fixedThreshold_largeAngles =  findIntercept(sFRC.largeAngles, fixedThreshold);
        cutOff.twoSigma_largeAngles =  findIntercept(sFRC.largeAngles, twoSigma);
        cutOff.threeSigma_largeAngles =  findIntercept(sFRC.largeAngles, threeSigma);
        cutOff.fiveSigma_largeAngles =  findIntercept(sFRC.largeAngles, fiveSigma);
        
        [cutOff, resolution] = measureResolution(Scale, cutOff, params);
        
        result.FRC = FRC;
        result.sFRC = sFRC;
        result.Resolution = resolution;
        result.Im1 = im1;
        result.Im2 = im2;
        result.Scale = Scale ;
        result.N = N;
        result.Shift = Shift;
        result.PixelSize = params.pixelSize;
        result. MeanFilterWidth = params.meanFilterWidth;
        result.TwoSigma = twoSigma;
        result.ThreeSigma = threeSigma;
        result.FiveSigma = fiveSigma;
        result.FixedThreshold = fixedThreshold;
        result.Theta = params.theta;
        result.CutOff = cutOff;
    end
catch ME
    rethrow (ME);
    
end
end

function [cutOff, resolution] = measureResolution(Scale, cutOff, params)
fields = fieldnames(cutOff);

for i=1:numel(fields)
    if cutOff.(fields{i}) == -1
        if ( ...
                params.theta ~= 0 && ~isempty(strfind(fields{i}, '_smallAngles')) ...
                || ...
                params.theta ~= pi/2 && ~isempty(strfind(fields{i}, '_largeAngles')) ...
                )
        end
        cutOff.(fields{i}) = NaN;
        resolution.(fields{i}) = NaN;
    else
        resolution.(fields{i}) = 1000/Scale(cutOff.(fields{i}));
    end
end
end
