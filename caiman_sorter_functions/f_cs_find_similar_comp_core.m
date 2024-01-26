function [est, proc] = f_cs_find_similar_comp_core(est, proc, params)

method = params.merge_method; % 'weighted ave'; full mean corr; svd; nmf; choose better;
apply_merge = params.apply_merge;
plot_stuff = params.plot_stuff;
spac_thr = params.spac_thr;
temp_thr = params.temp_thr;

comp_acc = params.comp_acc;

idx_lut = find(comp_acc);
num_comp = sum(comp_acc);

num_comp_all = numel(comp_acc);
dims = est.dims;

dc_params = params.dc_params;
dt = 1/double(est.init_params_caiman.data.fr);

peak_params.peaks_to_ave = proc.peaks_to_ave;
peak_params.peak_bin_zero_size = proc.peak_bin_zero_size;
peak_params.peak_bin_sig_size = proc.peak_bin_sig_size;
peak_params.fr = est.init_params_caiman.data.fr;

A = est.A(:,comp_acc);
C = est.C(comp_acc,:);
trace = C + est.YrA(comp_acc,:);
base1 = min(C,[], 2);


AA = (A'*A);
AA_lt = tril(AA,-1);

[sort_vals, sort_idx] = sort(reshape(full(AA_lt),[], 1), 'descend');
[rows, cols] = ind2sub([num_comp, num_comp], sort_idx);

num_cells_ov = sum(sort_vals>spac_thr);

A_merge = cell(num_cells_ov,1);
tr_merge = cell(num_cells_ov,1);

num_cells_added = 0;
merged_cells = cell(num_cells_ov,1);

for n_cell = 1:num_cells_ov
    n_cell_acc1 = rows(n_cell);
    n_cell_acc2 = cols(n_cell);
    
    cells_corr = corr(trace(n_cell_acc1,:)', trace(n_cell_acc2,:)');
    
    if cells_corr > temp_thr
        n_cell1 = idx_lut(n_cell_acc1);
        n_cell2 = idx_lut(n_cell_acc2);
        
        tr1_norm = norm(trace(n_cell_acc1,:)-base1(n_cell_acc1));
        tr2_norm = norm(trace(n_cell_acc2,:)-base1(n_cell_acc2));
        
        tr1 = trace(n_cell_acc1,:);
        tr2 = trace(n_cell_acc2,:);
        A1 = A(:,n_cell_acc1);
        A2 = A(:,n_cell_acc2);
        
        if strcmpi(method, 'weighted ave')
            %tr1_sum = sum(tr1);
            %tr2_sum = sum(tr2);
            A1_sum = full(sum(A1));
            A2_sum = full(sum(A2));

            tr_comb = (tr1*A1_sum + tr2*A2_sum)/(A1_sum+A2_sum);
            A_comb = (A1*tr1_norm + A2*tr2_norm)/(tr1_norm+tr2_norm);
            A_comb_norm = norm(A_comb);

            A_combn = A_comb/A_comb_norm;
            tr_combn = 2*tr_comb*A_comb_norm; % 2 because we are combining
        else
            % basically same result
            if 1
                A_mask = (A1+A2)>0;
            else
                A_mask = true(prod(dims),1);
            end
            
            full1 = A1(A_mask)*tr1;
            full2 = A2(A_mask)*tr2;
            full_comb = full1+full2;
            
            if strcmpi(method, 'full mean corr')
                full_trace1 = sum(full_comb,1);
                full_trace1n = full_trace1/norm(full_trace1);

                full_A = full_comb*full_trace1n';
                full_A_norm = norm(full_A);

                A_combn = zeros(prod(dims),1);
                A_combn(A_mask) = full_A/full_A_norm;
                tr_combn = full_trace1n*full_A_norm;
            elseif strcmpi(method, 'svd')
                [U, S, V] = svd(full_comb, 'econ');
                tr_combn = V(:,1)*S(1,1);
                A_combn(A_mask) = U(:,1);
            elseif strcmpi(method, 'nmf')
                [W,H] = nnmf(full_comb,1);
                tr_combn = H*norm(W);
                A_combn(A_mask) = W/norm(W);
            else
                error('method %s is undefined', method)
            end
        end
        
        A_merge{n_cell} = A_combn;
        tr_merge{n_cell} = tr_combn;
        
        if plot_stuff
            im1 = reshape(full(A1), [256, 256]);
            im2 = reshape(full(A2), [256, 256]);
            im_comb = reshape(full(A_combn), [256, 256]);
            
            all_vals = [A1, A2, A_combn];
            max_val = full(max(all_vals(:)));
            min_val = full(min(all_vals(:)));
            
            n_marg = find(sum(im_comb,1));
            m_marg = find(sum(im_comb,2));
            m_lim = [m_marg(1), m_marg(end)];
            n_lim = [n_marg(1), n_marg(end)];

            figure; 
            subplot(2,3,1);
            imagesc(im1); title(sprintf('A1, cell%d', n_cell1)); 
            axis equal tight; caxis([min_val max_val]); ylim(m_lim); xlim(n_lim);
            subplot(2,3,2);
            imagesc(im2); title(sprintf('A2, cell%d', n_cell2)); 
            axis equal tight; caxis([min_val max_val]); ylim(m_lim); xlim(n_lim);
            subplot(2,3,3);
            imagesc(im_comb); title('Acomb'); 
            axis equal tight; caxis([min_val max_val]); ylim(m_lim); xlim(n_lim);
            subplot(2,3,4:6); hold on; 
            plot(tr_combn, 'k'); plot(tr1); plot(tr2); 
            legend('trcomb', 'tr1', 'tr2'); axis tight;
            title(sprintf('trace corr=%.2f; spac corr=%.2f', cells_corr, sort_vals(n_cell)));

        end

        if proc.SNR2_vals(n_cell1) >= proc.SNR2_vals(n_cell2)
            keep_throw_cell = [n_cell1, n_cell2];
        else
            keep_throw_cell = [n_cell2, n_cell1];
        end
               
        pre_merge_data = cell(2,1);
        for n_cell_idx = 1:2
            pre_merge_data{n_cell_idx} = f_cs_gather_est_cell_data(est, proc, keep_throw_cell(n_cell_idx));
            pre_merge_data{n_cell_idx}.n_cell_merge = num_comp_all + 1 + num_cells_added;
            pre_merge_data{n_cell_idx}.merge_status = 'input';
        end
        pre_merge_data{1}.keep_status = 1;
        pre_merge_data{2}.keep_status = 0;
        merged_cells{n_cell} = cat(1,pre_merge_data{:});
        
        % some new est
        cell_out = struct();
        cell_out.n_cell = num_comp_all + 1 + num_cells_added;
        cell_out.n_cell_merge = num_comp_all + 1 + num_cells_added;
        cell_out.A = A_combn;
        cell_out.F_dff = zeros(1, numel(tr_combn));
        
        cell_out.SNR_comp = mean([merged_cells{n_cell}.SNR_comp]);
        cell_out.cnn_preds = max([merged_cells{n_cell}.cnn_preds]);
        cell_out.r_values = max([merged_cells{n_cell}.r_values]);
        cell_out.g = mean([merged_cells{n_cell}.g],2);
        cell_out.merge_status = 'output';
        cell_out.keep_status = 0;
        
        % get concours
        temp_indices = find(A_combn);
        [y_temp, x_temp] = ind2sub(dims, temp_indices);
        indx_temp = boundary(x_temp, y_temp);
        cell_out.contours = {[x_temp(indx_temp),y_temp(indx_temp)]};
        
        % new proc params
        cell_out.noise = GetSn(tr_combn);
        cell_out.skewness = skewness(tr_combn);
        cell_out.peaks_ave = f_cs_compute_peaks_ave(tr_combn, peak_params);
        cell_out.num_zeros = sum(tr_combn==0);
        cell_out.gAR1 = estimate_time_constant(tr_combn, 1, proc.noise(n_cell));
        cell_out.gAR2 = estimate_time_constant(tr_combn, 2, proc.noise(n_cell));
        
        temp_tau = tau_d2c(cell_out.gAR1, dt);
        cell_out.tauAR1 = temp_tau(2);
        cell_out.tauAR2 = tau_d2c(cell_out.gAR2, dt);
        
        cell_out.SNR2_vals = double(cell_out.peaks_ave./cell_out.noise);
        
        % deconvolve
        if dc_params.p == 1
            if dc_params.use_manual_params
                g = tau_c2d(Inf, dc_params.manual_tau_decay, dt);
            else
                g = cell_out.gAR1;
            end
        elseif dc_params.p == 2
            if dc_params.use_manual_params
                g = tau_c2d(dc_params.manual_tau_rise, dc_params.manual_tau_decay, dt);
            else
                g = cell_out.gAR2;
            end
        end

        cell_out.g = g;
        options.fudge_factor = dc_params.fudge_factor;
        options.p = dc_params.p;
        
        [C, S] = f_cs_compute_constrained_foopsi_core(tr_combn, g, cell_out.noise, options);
        
        cell_out.C = C;
        cell_out.YrA = tr_combn - C';
        cell_out.R = cell_out.YrA;
        cell_out.S = S';
        cell_out.firing_stab_vals = f_cs_compute_firing_stability(cell_out.S, peak_params);
        
        cell_out.comp_accepted_core = 0;
        cell_out.comp_accepted = 1;
        
        merged_cells{n_cell} = [merged_cells{n_cell}; cell_out];

        num_cells_added = num_cells_added + 1;
    end
end

merged_cells2 = cat(1, merged_cells{:});

if numel(merged_cells2)
    if apply_merge
        if strcmpi(method, 'choose best snr')
            idx1 = and(strcmpi({merged_cells2.merge_status}, 'input'), ~[merged_cells2.keep_status]);
            cells_throw = [merged_cells2(idx1).n_cell];
            proc.idx_manual_bad = union(proc.idx_manual_bad, cells_throw);
            proc.idx_manual = setdiff(proc.idx_manual, proc.idx_manual_bad);
        else
            idx1 = strcmpi({merged_cells2.merge_status}, 'input');
            cells_throw = [merged_cells2(idx1).n_cell];
            proc.idx_manual_bad = union(proc.idx_manual_bad, cells_throw);
            proc.idx_manual = setdiff(proc.idx_manual, proc.idx_manual_bad);

            for n_cell_idx = 1:numel(idx1)
                if ~idx1(n_cell_idx)
                    cell_data = merged_cells2(n_cell_idx);
                    n_cell = cell_data.n_cell;
                    proc.idx_manual = union(proc.idx_manual, n_cell);
                    proc.idx_manual_bad = setdiff(proc.idx_manual_bad, proc.idx_manual);
                    
                    est.A(:,n_cell) = cell_data.A;
                    est.contours(n_cell) = cell_data.contours;
                    est.C(n_cell,:) = cell_data.C;
                    est.F_dff(n_cell,:) = cell_data.F_dff;
                    est.R(n_cell,:) = cell_data.R;
                    est.S(n_cell,:) = cell_data.S;
                    est.YrA(n_cell,:) = cell_data.YrA;
                    est.SNR_comp(n_cell) = cell_data.SNR_comp;
                    est.cnn_preds(n_cell) = cell_data.cnn_preds;
                    est.r_values(n_cell) = cell_data.r_values;
                    est.g(:,n_cell) = cell_data.g;

                    est.idx_components = [est.idx_components; n_cell];
                    est.num_cells_mod = est.num_cells_mod + 1;
                    
                    proc.num_cells = proc.num_cells + 1;
                    
                    proc.peaks_ave(n_cell) = cell_data.peaks_ave;
                    proc.num_zeros(n_cell) = cell_data.num_zeros;
                    proc.noise(n_cell) = cell_data.noise;
                    proc.skewness(n_cell) = cell_data.skewness;
                    proc.gAR1(n_cell) = cell_data.gAR1;
                    proc.gAR2(n_cell,:) = cell_data.gAR2;
                    proc.tauAR1(n_cell) = cell_data.tauAR1;
                    proc.tauAR2(n_cell,:) = cell_data.tauAR2;
                    proc.SNR2_vals(n_cell) = cell_data.SNR2_vals;
                    proc.firing_stab_vals(n_cell) = cell_data.firing_stab_vals;

                    proc.comp_accepted(n_cell) = cell_data.comp_accepted;
                    proc.comp_accepted_core(n_cell) = cell_data.comp_accepted_core;

                    proc.idx_components = [proc.idx_components; n_cell];

                    proc.deconv.smooth_dfdt.S(n_cell,:) = zeros(size(cell_data.C));
                    proc.deconv.smooth_dfdt.S_std(n_cell) = 0;
                    
                    if isfield(proc.deconv, 'MCMC')
                        proc.deconv.MCMC.C(n_cell) = {[]};
                        proc.deconv.MCMC.S(n_cell) = {[]};
                        proc.deconv.MCMC.SAMP(n_cell) = {[]};
                    end
                    
                    if isfield(proc.deconv, 'c_foopsi')
                        proc.deconv.c_foopsi.C(n_cell) = {cell_data.C};
                        proc.deconv.c_foopsi.g(n_cell) = {cell_out.g};
                        proc.deconv.c_foopsi.p(n_cell) = {dc_params.p};
                        proc.deconv.c_foopsi.S(n_cell) = {cell_data.S};
                    end
                end
            end
        end
    end

    proc.merged_cells = merged_cells2;
    
end

end