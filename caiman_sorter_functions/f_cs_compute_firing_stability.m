function firing_stab_vals = f_cs_compute_firing_stability(S, params)

bin_zero_half_size = floor((params.peak_bin_zero_size * single(params.fr))/2);
%bin_sig_size = floor((proc.peak_bin_sig_size * single(ops.init_params_caiman.data.fr)));
[num_cells, num_frames] = size(S);
firing_stab_vals = zeros(num_cells,1);          
for n_cell = 1:num_cells
    S_std = std(S(n_cell, S(n_cell,:)>0));
    temp_S = S(n_cell,:);  
    num_peaks = 0;
    end_loop = 0;

    while ~end_loop      
        [m_val, m_ind] = max(temp_S);
        if m_val > S_std
            num_peaks = num_peaks + 1;
        else
            end_loop = 1;
        end
        temp_S(max(m_ind-bin_zero_half_size,1): min(m_ind+bin_zero_half_size,num_frames)) = 0;
    end
    firing_stab_vals(n_cell) = num_peaks/(num_frames/bin_zero_half_size/2);
end
    
end
