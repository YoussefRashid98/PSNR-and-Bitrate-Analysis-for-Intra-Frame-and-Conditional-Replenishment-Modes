function [CR_Rkbps,CR_PSNR,blocks]=Intra_CONDrep(Q,Y,blocks,quantDCT,receivedDCT,codebooks,frame_size)
%% Start with mode decisions for intra and conditional replenishment mode
% Calculation of Lagrangian cost function
received_Intra = cell(numel(Q),50);
received_CR = cell(numel(Q),50);
disp('Start coding with mode decision for intra and copy mode...');

for quantStep = 1:length(Q)  % loop over step sizes of quantizer
    
    % lambda for cost function according to instructions
    lambda = 0.2*Q(quantStep)^2;
    
    for nframe = 1:length(Y) % loop over all frames, comparison between two frames: -1
        
        M = size(Y{nframe},1)/16;
        N = size(Y{nframe},2)/16;
        
        % loop over all 16x16 blocks
        for ii = 1:M
            for jj =1:N
                
                % we already calculatd these before
                DCTCoef = blocks{quantStep,nframe}{ii,jj}.quantDCT; 
                Dist_intra = blocks{quantStep,nframe}{ii,jj}.MSEIntra;
                
                % get rate for intra coding
                R_intra =getRateStruct(DCTCoef, codebooks, quantStep, 'coef');
                R_intra = R_intra + 1/16^2;  % this means 1 bit per block
                
                if nframe==1
                    % the first frame has to be transmitted in intra mode
                    J_copy = inf;
                else
                    % Calculate the distortion between the previously sent
                    % coefficients and the UNquantized DCT coefficients of the
                    % current frame
                    framePrevSent = blocks{quantStep,nframe-1}{ii,jj}.receivedDCT;
                    frameCur = blocks{quantStep,nframe}{ii,jj}.DCT;
                    Dist_copy = sum(abs(framePrevSent(:)-frameCur(:)).^2)/16^2;
                    
                    % rate for copy mode is only 1 bit per block for indication
                    R_copy = 1/16^2;

                    % calculate cost functions
                    J_copy = Dist_copy + lambda*R_copy;
                    
                end
                
                J_intra = Dist_intra + lambda*R_intra;

                    
                
                % compare cost functions and decide on mode
                if J_intra < J_copy
                    blocks{quantStep,nframe}{ii,jj}.receivedDCT = DCTCoef;
                    blocks{quantStep,nframe}{ii,jj}.decision = 1;
                    blocks{quantStep,nframe}{ii,jj}.R_CR = R_intra; 
                    blocks{quantStep,nframe}{ii,jj}.MSE_CR = Dist_intra;
                else
                    blocks{quantStep,nframe}{ii,jj}.receivedDCT = ...
                        blocks{quantStep,nframe-1}{ii,jj}.receivedDCT;
                    blocks{quantStep,nframe}{ii,jj}.decision = 2;
                    blocks{quantStep,nframe}{ii,jj}.R_CR = R_copy; 
                    blocks{quantStep,nframe}{ii,jj}.MSE_CR = Dist_copy;
                end
                
                %blocks{quantStep,nframe}{ii,jj}.MSECopy = Dist_copy;
                
                % they already contain 1 bit for decision
                blocks{quantStep,nframe}{ii,jj}.RIntra = R_intra;
                
                received_CR{quantStep,nframe}{ii,jj} = ...
                    decode_intraframe2(blocks{quantStep,nframe}{ii,jj}.receivedDCT);
                
            end
        end
        received_CR{quantStep,nframe} = cell2mat(received_CR{quantStep,nframe});
    end
end



% calculate rate and PSNR
CR.rate = zeros(1,numel(Q));
CR.MSE = zeros(1,numel(Q));
for quantStep=1:numel(Q)
    for nframe=1:numel(Y)
        curBlock = [blocks{quantStep, nframe}{:,:}];
        CR.rate(quantStep) = CR.rate(quantStep) + ...
            mean([curBlock.R_CR]) / numel(Y);
        CR.MSE(quantStep) = CR.MSE(quantStep) + ...
            mean([curBlock.MSE_CR]) / numel(Y);
    end
end

CR_Rkbps = CR.rate.*30*frame_size(1)*frame_size(2)/1000;
CR_PSNR = 10*log10(255^2./CR.MSE);


disp('Finish coding with mode decision for intra and copy mode.');