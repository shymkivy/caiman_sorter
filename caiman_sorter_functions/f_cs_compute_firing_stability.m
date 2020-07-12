function firing_stab_vals = f_cs_compute_firing_stability(est, proc, ops)
    bin_size = floor((proc.peak_bin_size * single(ops.init_params_caiman.data.fr))/2);
    [num_cells, num_frames] = size(est.C);
    firing_stab_vals = zeros(num_cells,1);          
    for n_cell = 1:num_cells
        S_std = std(est.S(n_cell,est.S(n_cell,:)>0));
        temp_S = est.S(n_cell,:);  
        num_peaks = 0;
        end_loop = 0;

        while ~end_loop      
            [m_val, m_ind] = max(temp_S);
            if m_val > S_std
                num_peaks = num_peaks + 1;
            else
                end_loop = 1;
            end
            temp_S(max(m_ind-bin_size,1): min(m_ind+bin_size,num_frames)) = 0;
        end
        firing_stab_vals(n_cell) = num_peaks/(num_frames/bin_size/2);
    end
end