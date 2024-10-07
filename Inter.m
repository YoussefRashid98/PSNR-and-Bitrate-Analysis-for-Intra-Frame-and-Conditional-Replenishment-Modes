function [blocks,codebooks_res,codebooks_mot]=Inter(Q,Vblk16,V,blocks,frame_size)

%% Start calculating residuals for Inter Mode

Vreceived_Inter = cell(numel(Q),50);
Vrec_Inter_Frame = cell(numel(Q),50);
Vreceived = cell(numel(Q),50);
Vreceived_blk = cell(numel(Q),50);


disp('Start calculating residuals for inter mode...');

for quantStep = 1:length(Q)  % loop over step sizes of quantizer
    for nframe = 1:length(V) % loop over all frames
         
        % how many 16x16 block fit into one frame
        [M,N] = size(Vblk16{nframe}); 
        
        % calculate motion vector and residual matrix for every block
        for nrow = 1:M
            for ncol =1:N
                
                blocks{quantStep,nframe}{nrow,ncol}.imgData = ...
                    Vblk16{nframe}{nrow,ncol};
                
                blocks{quantStep,nframe}{nrow,ncol}.pos = ...
                     [(nrow-1)*16+1 (ncol-1)*16+1];
                
                if nframe >= 2 % previous frame available
                    [blocks{quantStep,nframe}{nrow,ncol}.motionVec,...
                     blocks{quantStep,nframe}{nrow,ncol}.residual ] = ...
                        findMotionVec(Vrec_Inter_Frame{quantStep,nframe-1}, ... 
                        Vblk16{nframe}{nrow,ncol},...
                        blocks{quantStep,nframe}{nrow,ncol}.pos);
                else
                    % the first frame has no previous frame
                    [blocks{quantStep,nframe}{nrow,ncol}.motionVec,...
                     blocks{quantStep,nframe}{nrow,ncol}.residual ] = ...
                        findMotionVec(V{nframe}, ... 
                        Vblk16{nframe}{nrow,ncol},...
                        blocks{quantStep,nframe}{nrow,ncol}.pos);
                end
                
                % Apply DCT transform and quantize
                [blocks{quantStep,nframe}{nrow,ncol}.resDCT,...
                        blocks{quantStep,nframe}{nrow,ncol}.resDCTquant, ...
                        blocks{quantStep,nframe}{nrow,ncol}.MSEres ] = ...
                        encode_intraframe2(blocks{quantStep,nframe}{nrow,ncol}.residual, ...
                        Q(quantStep));
                    
                 if nframe>1
                    %reconstruct image from residual and motion vector
                     resimg = decode_intraframe2(blocks{quantStep,nframe}{nrow,ncol}.resDCTquant);
                     prevPos = blocks{quantStep,nframe}{nrow,ncol}.pos + ...
                         blocks{quantStep,nframe}{nrow,ncol}.motionVec;
                     previmgpart = Vrec_Inter_Frame{quantStep,nframe-1}...
                         (prevPos(1):prevPos(1)+15, prevPos(2):prevPos(2)+15);

                     Vreceived_Inter{quantStep,nframe}{nrow, ncol} = previmgpart + resimg;
                 else
                     Vreceived_Inter{quantStep,nframe}{nrow, ncol} =...
                         decode_intraframe2(blocks{quantStep, nframe}{nrow,ncol}.quantDCT);
                 end
            end
        end
        Vrec_Inter_Frame{quantStep,nframe} = cell2mat(Vreceived_Inter{quantStep,nframe});
    end
end


disp('Generate VLCs...');
% PSNR and rate calculation

% codebooks for each coefficients for each quantizer step size
codebooks_mot(numel(Q)).codewords = [];
codebooks_mot(numel(Q)).codelength = [];
codebooks_mot(numel(Q)).entropy = [];

coefVec_mot = zeros(numel(Q), 2*50*frame_size(1)*frame_size(2)/16^2 );


for quantStep=1:numel(Q)    % loop through all quantization steps
    idxMot = 1;
    for nframe = 1:length(V) % loop over all frames
        for nrow = 1:M
            for ncol = 1:N
                % loop through all coefficients of a 16x16
                coefVec_mot(quantStep, idxMot:idxMot+1) = ...
                    blocks{quantStep, nframe}{nrow,ncol}.motionVec;
                idxMot = idxMot + 2;
            end
        end
        
    end
end

%Ratefinal_mot = zeros(1,numel(delta));

for quantStep = 1:numel(Q)
    [codebooks_mot(quantStep).codewords, ...
        codebooks_mot(quantStep).codelength, ...
        codebooks_mot(quantStep).entropy] = ...
        generateCode(coefVec_mot(quantStep,:));
end

% Get codebook for residuals
[codebooks_res, ~, ~] = ...
    getCodebooks(blocks, 'resDCTquant', 'MSEres');
        

disp('Finish generating codes for residuals and motion vectors.');