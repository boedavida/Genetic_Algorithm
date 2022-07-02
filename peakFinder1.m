function peaks = peakFinder1(x)

% Finds the peaks in a 1-d sequence.
% A peak is any point that is greater than both 
% the point to its right and the point to its left.

% Error checking
s = size(x);
if length(s) > 2 || prod(s) > max(s)
	error('peakFinder1: input must be a vector')
end

% Make sure that it is a row vector
x = x(:).';

% Test against neighbors
xr = circshift(x,[0,1]);
xl = circshift(x,[0,-1]);
xDiff = zeros(2,length(x));
xDiff(1,:) = (x - xr > 0);
xDiff(2,:) = (x - xl > 0);

% Find peaks
peaks = (sum(xDiff) == 2);

return