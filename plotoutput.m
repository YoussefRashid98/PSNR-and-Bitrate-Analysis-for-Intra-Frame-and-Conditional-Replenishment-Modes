function plotoutput(Intra_Rkbps, Intra_PSNR,condRe_Rkbps,condRe_PSNR,Inter_Rkbps, Inter_PSNR)


%Plot PSNR vs Rate in kbits/sec
 figure;
 plot(Intra_Rkbps, Intra_PSNR, 'o-','LineWidth', 2);
 grid on;
 hold on
 xlabel('Rate [kbps]');
 ylabel('PSNR [dB]');
 
 plot(condRe_Rkbps, condRe_PSNR, 'rx-.', 'LineWidth', 2);
 
 plot(Inter_Rkbps, Inter_PSNR, 'k--', 'LineWidth', 2);
 legend('Intra Mode', 'Intra and Copy Mode', 'Intra, Copy and Inter Mode', ...
     'Location', 'northwest');
end 