function [ y ] = quantize( x, delta )
y = delta*floor(x/delta+1/2);
end
