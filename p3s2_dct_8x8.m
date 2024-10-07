function Y = p3s2_dct_8x8(X)
    M = 8;
    a0 = sqrt(1/M);
    ai = sqrt(2/M);
    A = zeros(M,M);
    for k = 0:M-1
        A(1,k+1) = a0*cos(0);
    end
    for i = 1:M-1
        for k = 0:M-1
            A(i+1,k+1) = ai*cos((2*k+1)*i*pi/(2*M));
        end
    end
    dct = @(block_struct) A*block_struct.data*transpose(A);
    Y = blockproc(X,[8 8],dct);
end
