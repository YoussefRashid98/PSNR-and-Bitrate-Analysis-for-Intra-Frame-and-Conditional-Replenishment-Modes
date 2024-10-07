function [ rate ] = getRate( DCTcoef, codebooks, quantStep )


validateattributes(codebooks, {'cell'}, {'nonempty'}, mfilename);

serDCTcoef = DCTcoef(:);
rate = 0;

for coefIdx=1:numel(serDCTcoef)
    % get the correct codebook for each coefficients and quantization
    % stepsize
    coefCode = codebooks{coefIdx, quantStep};
    codeLength = coefCode{:,1};
    codeVal = coefCode{:,2};
    
    % find codeword length for the coefficients
    rate = rate + codeLength(serDCTcoef(coefIdx) == codeVal);
end

rate = rate / numel(serDCTcoef);

end
