function [ entropy ] = entropy2( subband )
%Calculates entropy for given subband

[~, ~, entropy] = generateCode(subband);


% x = hist(subband(:), 2*max(abs(subband(:))));
% 
% sum1 = sum(x);
% 
% 
% p = x./sum1;
% 
% p(p==0) = [];
% entropy = -sum(p.*log2(p));

end
