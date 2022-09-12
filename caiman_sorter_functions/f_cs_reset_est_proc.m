function [est, proc] = f_cs_reset_est_proc(est, proc)

num_cells_pre = est.num_cells_original;

est.A = est.A(:,1:num_cells_pre);
est.contours = est.contours(1:num_cells_pre);
est.C = est.C(1:num_cells_pre,:);
est.F_dff = est.F_dff(1:num_cells_pre,:);
est.R = est.R(1:num_cells_pre,:);
est.S = est.S(1:num_cells_pre,:);
est.YrA = est.YrA(1:num_cells_pre,:);
est.SNR_comp = est.SNR_comp(1:num_cells_pre);
est.cnn_preds = est.cnn_preds(1:num_cells_pre);
est.r_values = est.r_values(1:num_cells_pre);
est.g = est.g(:,1:num_cells_pre);
est.idx_components = est.idx_components(est.idx_components<=num_cells_pre);
est.idx_components_bad = est.idx_components_bad(est.idx_components_bad<=num_cells_pre);

proc.num_cells = num_cells_pre;

proc.peaks_ave = proc.peaks_ave(1:num_cells_pre);
proc.num_zeros = proc.num_zeros(1:num_cells_pre);
proc.noise = proc.noise(1:num_cells_pre);
proc.gAR1 = proc.gAR1(1:num_cells_pre);
proc.gAR2 = proc.gAR2(1:num_cells_pre,:);
proc.tauAR1 = proc.tauAR1(1:num_cells_pre);
proc.tauAR2 = proc.tauAR2(1:num_cells_pre,:);
proc.SNR2_vals = proc.SNR2_vals(1:num_cells_pre);
proc.firing_stab_vals = proc.firing_stab_vals(1:num_cells_pre);

proc.num_cells = num_cells_pre;

proc.comp_accepted = proc.comp_accepted(1:num_cells_pre);
proc.comp_accepted_core = proc.comp_accepted_core(1:num_cells_pre);
proc.idx_components = proc.idx_components(proc.idx_components<=num_cells_pre);
proc.idx_components_bad = proc.idx_components_bad(proc.idx_components_bad<=num_cells_pre);

proc.idx_manual = [];
proc.idx_manual_bad = [];

if isfield(proc, 'devonv')
    proc.deconv.smooth_dfdt.S = proc.deconv.smooth_dfdt.S(1:num_cells_pre,:);
    proc.deconv.smooth_dfdt.S_std = proc.deconv.smooth_dfdt.S_std(1:num_cells_pre);

    if isfield(proc.deconv, 'MCMC')
        proc.deconv.MCMC.C = proc.deconv.MCMC.C(1:num_cells_pre);
        proc.deconv.MCMC.S = proc.deconv.MCMC.S(1:num_cells_pre);
        proc.deconv.MCMC.SAMP = proc.deconv.MCMC.SAMP(1:num_cells_pre);
    end
    if isfield(proc.deconv, 'c_foopsi')
        proc.deconv.c_foopsi.C = proc.deconv.c_foopsi.C(1:num_cells_pre);
        proc.deconv.c_foopsi.g = proc.deconv.c_foopsi.g(1:num_cells_pre);
        proc.deconv.c_foopsi.p = proc.deconv.c_foopsi.p(1:num_cells_pre);
        proc.deconv.c_foopsi.S = proc.deconv.c_foopsi.S(1:num_cells_pre);
    end
end
end