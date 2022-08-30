function peaks_ave = f_cs_compute_peaks_ave(data, params)

[num_cells, T] = size(data);

bin_size_zero_half = floor((params.peak_bin_zero_size * double(params.fr))/2);
bin_size_sig = floor((params.peak_bin_sig_size * double(params.fr)));

peaks_ave = zeros(num_cells,1);
temp_peaks = zeros(params.peaks_to_ave,1);
for n_cell = 1:num_cells
    temp_C = data(n_cell,:);
    for n_peak = 1:params.peaks_to_ave     
        [~, m_ind] = max(temp_C);
        start1 = max(m_ind - floor(bin_size_sig/2),1);
        end1 = min(start1 + bin_size_sig-1, T);
        temp_peaks(n_peak) = median(temp_C(start1:end1));
        temp_C(max(m_ind-bin_size_zero_half,1): min(m_ind+bin_size_zero_half, T)) = 0;
    end
    %figure; plot(temp_C); title(num2str(n_peak))
    peaks_ave(n_cell) = mean(temp_peaks);
end


end