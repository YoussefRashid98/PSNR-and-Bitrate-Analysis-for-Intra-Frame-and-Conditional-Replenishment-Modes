function [Intra_Rkbps,Intra_PSNR,codebooks]=intra_R_PSNR(frame_size,blocks, quantDCT, MSEIntra,Intra)
% PSNR and rate calculation for pure Intra Mode

disp('Calculate PSNR and rate for intra mode...');

[codebooks, Intra_rate, Intra_MSE] = getCodebooks(blocks, quantDCT, MSEIntra);
        
Intra_Rkbps = Intra_rate.*30*frame_size(1)*frame_size(2)/1000;

Intra_PSNR = 10*log10(255^2./Intra_MSE);


disp('Finish intra mode coding.');