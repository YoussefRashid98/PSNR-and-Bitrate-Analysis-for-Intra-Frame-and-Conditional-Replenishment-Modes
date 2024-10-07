% clear all;
% clc;
% close all;

%% Calculation for video foreman
file_name = 'foreman_qcif.yuv';

AllCoders;

blocks1 = blocks(1,:);
blocks2 = blocks(2,:);
blocks3 = blocks(3,:);
blocks4 = blocks(4,:);

[intra_for1, copy_for1, motion_for1, num_for] = calc_absDecisionNum(blocks1);
[frameintra_for1, framecopy_for1, framemotion_for1] = calc_decisionsPerFrame(blocks1);

[intra_for2, copy_for2, motion_for2, num_for] = calc_absDecisionNum(blocks2);
[frameintra_for2, framecopy_for2, framemotion_for2] = calc_decisionsPerFrame(blocks2);

[intra_for3, copy_for3, motion_for3, num_for] = calc_absDecisionNum(blocks3);
[frameintra_for3, framecopy_for3, framemotion_for3] = calc_decisionsPerFrame(blocks3);

[intra_for4, copy_for4, motion_for4, num_for] = calc_absDecisionNum(blocks4);
[frameintra_for4, framecopy_for4, framemotion_for4] = calc_decisionsPerFrame(blocks4);




%% Calculation for video mother-daughter

file_name = 'mother-daughter_qcif.yuv';
AllCoders;


blocks1 = blocks(1,:);
blocks2 = blocks(2,:);
blocks3 = blocks(3,:);
blocks4 = blocks(4,:);

[intra_mot1, copy_mot1, motion_mot1, num_mot] = calc_absDecisionNum(blocks1);
[frameintra_mot1, framecopy_mot1, framemotion_mot1] = calc_decisionsPerFrame(blocks1);

[intra_mot2, copy_mot2, motion_mot2, num_mot] = calc_absDecisionNum(blocks2);
[frameintra_mot2, framecopy_mot2, framemotion_mot2] = calc_decisionsPerFrame(blocks2);

[intra_mot3, copy_mot3, motion_mot3, num_mot] = calc_absDecisionNum(blocks3);
[frameintra_mot3, framecopy_mot3, framemotion_mot3] = calc_decisionsPerFrame(blocks3);

[intra_mot4, copy_mot4, motion_mot4, num_mot] = calc_absDecisionNum(blocks4);
[frameintra_mot4, framecopy_mot4, framemotion_mot4] = calc_decisionsPerFrame(blocks4);

%% plot results

plot_decisionRes(frameintra_for1, framecopy_for1, framemotion_for1, frameintra_mot1, framecopy_mot1, framemotion_mot1, delta(1));
plot_decisionRes(frameintra_for2, framecopy_for2, framemotion_for2, frameintra_mot2, framecopy_mot2, framemotion_mot2, delta(2));
plot_decisionRes(frameintra_for3, framecopy_for3, framemotion_for3, frameintra_mot3, framecopy_mot3, framemotion_mot3, delta(3));
plot_decisionRes(frameintra_for4, framecopy_for4, framemotion_for4, frameintra_mot4, framecopy_mot4, framemotion_mot4, delta(4));

save('quant1', 'intra_for1', 'copy_for1', 'motion_for1', 'intra_mot1', 'copy_mot1', 'motion_mot1');
save('quant2', 'intra_for2', 'copy_for2', 'motion_for2', 'intra_mot2', 'copy_mot2', 'motion_mot2');
save('quant3', 'intra_for3', 'copy_for3', 'motion_for3', 'intra_mot3', 'copy_mot3', 'motion_mot3');
save('quant4', 'intra_for4', 'copy_for4', 'motion_for4', 'intra_mot4', 'copy_mot4', 'motion_mot4');