Q = [2^3, 2^4, 2^5, 2^6];
frame_size = [176 144];
file_name='foreman_qcif.yuv';
file_name_new = 'mother-daughter_qcif.yuv';
frames_num=50;
PSNR = zeros(1,4);
R = zeros(1,4);
PSNR2 = zeros(1,4);
R2 = zeros(1,4);
%% Part 2 ( intra frame coding )
for i = 1:4
    [PSNR(i), R(i)] = p3s2_main(Q(i),file_name,frame_size,frames_num);
end
for i = 1:4
    [PSNR2(i), R2(i)] = p3s2_main(Q(i),file_name_new,frame_size,frames_num);
end



%% part 3 (conditional replinishment)
%  & part 4
%'foreman_qcif.yuv'
[Intra_Rkbps, Intra_PSNR,condRe_Rkbps,condRe_PSNR,Inter_Rkbps, Inter_PSNR]=part3_4_main (Q,file_name,frame_size);
%'mother-daughter_qcif.yuv'
[Intra_Rkbps2, Intra_PSNR2,condRe_Rkbps2,condRe_PSNR2,Inter_Rkbps2, Inter_PSNR2]=part3_4_main (Q,file_name_new,frame_size);


fig1=figure(1);
subplot(1,2,1);
plot(R, PSNR);
xlabel('R');
ylabel('PSNR');
title('foreman Intra mode only');
subplot(1,2,2);
plot(condRe_Rkbps, condRe_PSNR);
xlabel('R');
ylabel('PSNR');
title('foreman Intra mode with conditional replenishment');
fig2=figure(2);
subplot(1,2,1);
plot(R2, PSNR2);
xlabel('R');
ylabel('PSNR');
title('mother-daughter Intra mode only ')
subplot(1,2,2);
plot(condRe_Rkbps2, condRe_PSNR2);
xlabel('R');
ylabel('PSNR');
title('mother-daughter Intra mode with conditional replenishment');
%%%%%%%%%%%%%%%%%
%% output plots
%'foreman_qcif.yuv'
plotoutput(Intra_Rkbps, Intra_PSNR,condRe_Rkbps,condRe_PSNR,Inter_Rkbps, Inter_PSNR);
%'mother-daughter_qcif.yuv'
plotoutput(Intra_Rkbps2, Intra_PSNR2,condRe_Rkbps2,condRe_PSNR2,Inter_Rkbps2, Inter_PSNR2);


disp('The end ');