function [ Intra_Rkbps,Intra_PSNR,CR_Rkbps,CR_PSNR,Inter_Rkbps, Inter_PSNR ]=part3_4_main( Q , file ,frame_size  )
%% load video

Y = yuv_import_y(file,frame_size,50);
received_Intra = cell(numel(Q),50);
received_CR = cell(numel(Q),50);

%% start with setting some values from intra frame coding to get the part 3 & 4 

%seperate frames to blocks of 16 then 8 
%perform dct and quantization

blk16 = cell(length(Y), 1);
blocks = cell(length(Q), length(Y));

disp('Start coding in intra frame mode...');

for quantStep = 1:length(Q)  % loop over step sizes of quantizer
    for nframe = 1:length(Y) % loop over all frames
        
        
        %divide each frame into blocks of 16x16
        blk16{nframe} = mat2cell(Y{nframe}, repmat(16, 1, frame_size(2)/16), ...
            repmat(16, 1, frame_size(1)/16)); 
        
        % how many 16x16 block fit into one frame
        [M,N] = size(blk16{nframe}); 
        
        for ii = 1:M
            for jj =1:N
                blocks{quantStep,nframe}{ii,jj}.imgData = blk16{nframe}{ii,jj};
                % Apply DCT transform and quantize
                [blocks{quantStep,nframe}{ii,jj}.DCT, blocks{quantStep,nframe}{ii,jj}.quantDCT, ...
                    blocks{quantStep,nframe}{ii,jj}.MSEIntra] = encode_intraframe2(blocks{quantStep,nframe}{ii,jj}.imgData, Q(quantStep));
                
                received_Intra{quantStep,nframe}{ii,jj} = ...
                    decode_intraframe2(blocks{quantStep,nframe}{ii,jj}.quantDCT);

            end
        end
        received_Intra{quantStep,nframe} = cell2mat(received_Intra{quantStep,nframe});
    end
end


[Intra_Rkbps,Intra_PSNR,codebooks]=intra_R_PSNR(frame_size,blocks, 'quantDCT', 'MSEIntra','Intra')

%% conditional replinishment

[CR_Rkbps,CR_PSNR,blocks]=Intra_CONDrep(Q,Y,blocks,'quantDCT','receivedDCT',codebooks,frame_size);
%% Residual Coding:
[blocks,codebooks_res,codebooks_mot]=Inter(Q,blk16,Y,blocks,frame_size);

%% Intra & inter & conditional replinishment together
[Inter_Rkbps, Inter_PSNR]=Inter_intra_rep(Q,blk16,Y,frame_size,blocks,'quantDCT','receivedDCT',codebooks,'Intra',codebooks_mot,codebooks_res)

 

