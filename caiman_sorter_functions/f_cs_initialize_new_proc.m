function proc = f_cs_initialize_new_proc(est, ops)

%% 
proc.idx_components = est.idx_components;
proc.idx_components_bad = est.idx_components_bad;
proc.dims = est.dims;

[proc.num_cells, proc.num_frames] = size(est.C);

proc.idx_manual = [];
proc.idx_manual_bad = [];
proc.comp_accepted_core = false(proc.num_cells,1);
proc.comp_accepted_core(proc.idx_components) = 1;
proc.comp_accepted = proc.comp_accepted_core;

%%  average of top peaks
%f_cs_update_log(app, 'Computing SNR and time constants...');

data = est.C + est.YrA;

params.peaks_to_ave = 5;      % for SNR and and peaks computation
params.peak_bin_zero_size = 10;     % in sec, for firing stability
params.peak_bin_sig_size = .4;        % sec take median around peak
params.fr = ops.init_params_caiman.data.fr;

proc.peaks_ave = f_cs_compute_peaks_ave(data, params);

proc.peaks_to_ave = params.peaks_to_ave;
proc.peak_bin_zero_size = params.peak_bin_zero_size;
proc.peak_bin_sig_size = params.peak_bin_sig_size;

%%  number of missing values (zeros) in traces
proc.num_zeros = zeros(proc.num_cells,1);
for n_cell = 1:proc.num_cells
    temp_YrA = est.YrA(n_cell,:);
    proc.num_zeros(n_cell) = sum(temp_YrA==0);
end

%%  noise and time constants
traces1 = est.YrA + est.C;

proc.noise = GetSn(traces1);
proc.skewness = skewness(traces1, [], 2);

proc.gAR1 = zeros(proc.num_cells,1);
proc.gAR2 = zeros(proc.num_cells,2);
proc.tauAR1 = zeros(proc.num_cells,1);
proc.tauAR2 = zeros(proc.num_cells,2);

dt = 1/double(ops.init_params_caiman.data.fr);


for n_cell = 1:proc.num_cells
    temp_cell = traces1(n_cell,:);
    %peak = max(temp_cell)-base;

    proc.gAR1(n_cell) = estimate_time_constant(temp_cell, 1, proc.noise(n_cell));
    proc.gAR2(n_cell,:) = estimate_time_constant(temp_cell, 2, proc.noise(n_cell));
    
    temp_tau = tau_d2c(proc.gAR1(n_cell),dt);
    proc.tauAR1(n_cell) = temp_tau(2);
    
    proc.tauAR2(n_cell,:) = tau_d2c(proc.gAR2(n_cell,:),dt);
end

proc.SNR2_vals = double(proc.peaks_ave./proc.noise);

%%
proc.firing_stab_vals = f_cs_compute_firing_stability(est.S, params);

end