function zerosOnes = rand01(p,m,n)

% Generates an mxn random matrix of ones (with 
% probability p) and zeros (with probability 1 - p).
% Default would be the equivalent of a coin flip with a fair coin.

if nargin < 2
	n = 1;
end

if nargin < 1
	p = 0.5;
end

zerosOnes = (rand(m,n) <= p);

return
