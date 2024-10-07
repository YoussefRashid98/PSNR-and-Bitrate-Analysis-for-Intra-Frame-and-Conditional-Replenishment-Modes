function [PSNR_avg, R_avg] = p3s2_main(Q,file_name,frame_size,frames_num)
    Yuv = yuv_import_y(file_name,frame_size,frames_num);

    size_coefficient_block = frame_size/16;
    coefficient_block = zeros(size_coefficient_block(1), ...
        size_coefficient_block(2), 16, 16, frames_num); 

    PSNR = zeros(frames_num, 1);
    R = zeros(10, 1);

    for frame = 1:50
        Y = Yuv{frame};
        Y_q_idct = Y;
        for i = 1:size_coefficient_block(1)
            for j = 1:size_coefficient_block(2)
                block = Y(j*16-15:j*16, i*16-15:i*16);
                block_dct = p3s2_dct_8x8(block);
                block_dct_q = p3s2_quantizer(block_dct, Q);
                block_dct_q_idct = p3s2_idct_8x8(block_dct_q);
                Y_q_idct(j*16-15:j*16, i*16-15:i*16) = block_dct_q_idct;
                coefficient_block(i,j,:,:,frame)=block_dct_q_idct;
            end
        end
        PSNR(frame) = p3s2_PSNR(immse(Y, Y_q_idct));
        R(frame)= p3s2_bitrate_v2(Y_q_idct, Q);
    end

    PSNR_avg = sum(PSNR) / 50;
    R_avg = sum(R)/50;
end

