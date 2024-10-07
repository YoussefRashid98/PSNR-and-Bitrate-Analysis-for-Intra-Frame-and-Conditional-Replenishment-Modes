function quantized = p3s2_quantizer(x, Q)
    % x: coefficient to be quantized
    % Q: step size
    quantized = Q * floor(x/Q + 0.5);
end