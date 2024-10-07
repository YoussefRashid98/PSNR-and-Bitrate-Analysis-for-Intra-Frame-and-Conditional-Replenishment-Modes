function bitrate = p3s2_bitrate_v2(Y, step)
 
    block_size = size(Y) / 8;
    coefficient_block = zeros(8,8);
    H = zeros(block_size(2), block_size(1));
    
    for w=1:block_size(2)
        for h=1:block_size(1)
            for i=1:8
                for j=1:8
                    coefficient_block(i,j) = Y(8*(h-1)+j,8*(w-1)+i);
                end
            end
            vals = reshape(coefficient_block(:,:),[1,size(coefficient_block(:,:),1)*size(coefficient_block(:,:),2)]);
            bins_coefs = [min(vals):step:max(vals)];
            if(length(bins_coefs) == 1)
                H(w,h) = -sum(1*log2(1+eps));
            else
                p = hist(vals,bins_coefs)/length(vals);
                H(w,h) = -sum(p.*log2(p+eps));
            end
        end
    end
    bitrate = mean2(H)* 176 * 144 * 30 / 1000;
end