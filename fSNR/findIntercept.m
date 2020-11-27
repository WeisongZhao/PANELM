function [firstIntercept] =  findIntercept(data,threshold)
%   [firstIntercept] =  FindFirstiIntercept(data,threshold)
%
%   Calculates the first intercept abscissa between data (non strictly
%   decraising) and a given threshold curve.

nSamples = size(data,1);
assert(nSamples == size(threshold,1), 'nSamples != size(threshold,1)');
firstIntercept = -1;
 
for sample = 4 : nSamples-1
    if(	(data (sample) < threshold(sample) ) && ...
            ( max( [data(sample-1), data(sample-2), data(sample-3)] ) > threshold(sample)) )
        firstIntercept = sample;
        break;
    end
end

end