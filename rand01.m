function zerosOnes = rand01(m,n,p)

% Generates an mxn random matrix of ones (with 
% probability p) and zeros (with probability 1 - p).
% Default would be the equivalent of a coin flip with a fair coin.

if nargin < 3
	p = 0.5;
end

zerosOnes = (rand(m,n) <= p);

return
