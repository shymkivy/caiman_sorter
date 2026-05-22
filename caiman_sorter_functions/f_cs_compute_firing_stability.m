function firing_stab_vals = f_cs_compute_firing_stability(S, params)
% Peak-rate score per cell. Counts NMS-suppressed peaks above the std of
% nonzero values, then divides by the number of available windows.

bin_zero_half_size = floor((params.peak_bin_zero_size * single(params.fr))/2);
[num_cells, num_frames] = size(S);
firing_stab_vals = zeros(num_cells,1);

for n_cell = 1:num_cells
    trace = S(n_cell, :);
    S_std = std(trace(trace > 0));
    if isnan(S_std) || S_std == 0
        continue;   % all-zero / flat trace -> 0 peaks
    end

    % Sort descending; entries strictly above S_std are candidates. This
    % replaces a per-iteration max() scan (O(T*k)) with one sort
    % (O(T log T)) plus an O(k) greedy NMS pass — same accept/reject
    % decisions as the original loop (verified by hand-tracing).
    [vals, order] = sort(trace, 'descend');
    above = order(vals > S_std);

    used = false(1, num_frames);
    num_peaks = 0;
    for k = 1:numel(above)
        idx = above(k);
        if used(idx)
            continue;   % center already inside a prior peak's NMS window
        end
        lo = max(idx - bin_zero_half_size, 1);
        hi = min(idx + bin_zero_half_size, num_frames);
        used(lo:hi) = true;
        num_peaks = num_peaks + 1;
    end

    firing_stab_vals(n_cell) = num_peaks/(num_frames/bin_zero_half_size/2);
end

end
