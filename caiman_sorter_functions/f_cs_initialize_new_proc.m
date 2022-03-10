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
proc.peaks_to_ave = 5;      % for SNR and and peaks computation
proc.peak_bin_size = 3;     % in sec, for firinf stability

bin_size = floor((proc.peak_bin_size * double(ops.init_params_caiman.data.fr))/2);

proc.peaks_ave = zeros(proc.num_cells,1);
temp_peaks = zeros(proc.peaks_to_ave,1);
for n_cell = 1:proc.num_cells
    temp_C = est.C(n_cell,:);
    for n_peak = 1:proc.peaks_to_ave     
        [temp_peaks(n_peak), m_ind] = max(temp_C);
        temp_C(max(m_ind-bin_size,1): min(m_ind+bin_size,proc.num_frames)) = 0;
    end
    %figure; plot(temp_C); title(num2str(n_peak))
    proc.peaks_ave(n_cell) = mean(temp_peaks);
end

%%  number of missing values (zeros) in traces
proc.num_zeros = zeros(proc.num_cells,1);
for n_cell = 1:proc.num_cells
    temp_YrA = est.YrA(n_cell,:);
    proc.num_zeros(n_cell) = sum(temp_YrA==0);
end

%%  noise and time constants
proc.noise = zeros(proc.num_cells,1);
proc.gAR1 = zeros(proc.num_cells,1);
proc.gAR2 = zeros(proc.num_cells,2);
proc.tauAR1 = zeros(proc.num_cells,1);
proc.tauAR2 = zeros(proc.num_cells,2);

dt = 1/double(ops.init_params_caiman.data.fr);

for n_cell = 1:proc.num_cells
    temp_cell = est.YrA(n_cell,:) + est.C(n_cell,:);
    %peak = max(temp_cell)-base;
    proc.noise(n_cell) = GetSn(temp_cell);
    
    proc.gAR1(n_cell) = estimate_time_constant(temp_cell, 1, proc.noise(n_cell));
    proc.gAR2(n_cell,:) = estimate_time_constant(temp_cell, 2, proc.noise(n_cell));
    
    temp_tau = tau_d2c(proc.gAR1(n_cell),dt);
    proc.tauAR1(n_cell) = temp_tau(2);
    
    proc.tauAR2(n_cell,:) = tau_d2c(proc.gAR2(n_cell,:),dt);
end

proc.SNR2_vals = double(proc.peaks_ave./proc.noise);

%%
proc.firing_stab_vals = f_cs_compute_firing_stability(est, proc, ops);

end