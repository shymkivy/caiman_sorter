function f_cs_merge_similar_comp(app)

disp('looking for components to merge...');

plot_stuff =1;

spac_thr = app.spatialcorrthershEditField.Value;
temp_thr = app.tempcorrtheshEditField.Value;

comp_acc = app.proc.comp_accepted;
idx_lut = find(comp_acc);
num_comp = sum(comp_acc);

A = app.est.A(:,comp_acc);
trace = app.est.C(comp_acc,:) + app.est.YrA(comp_acc,:);

AA = (A'*A);
AA_lt = tril(AA,-1);

[sort_vals, sort_idx] = sort(reshape(full(AA_lt),[], 1), 'descend');
[rows, cols] = ind2sub([num_comp, num_comp], sort_idx);

num_cells_ov = sum(sort_vals>spac_thr);

A_merge = cell(num_cells_ov,1);
tr_merge = cell(num_cells_ov,1);

for n_cell = 1:num_cells_ov
    n_cell1 = rows(n_cell);
    n_cell2 = cols(n_cell);
    
    cells_corr = corr(trace(n_cell1,:)', trace(n_cell2,:)');
    
    if cells_corr > temp_thr
        tr1 = trace(n_cell1,:);
        tr2 = trace(n_cell2,:);
        
        A1 = A(:,n_cell1);
        A2 = A(:,n_cell2);
        
        tr_comb = full(sum(A1))*tr1 + full(sum(A2))*tr2;

        mean_tr1 = mean(tr1);
        mean_tr2 = mean(tr2);

        A_comb = (A1*mean_tr1 + A2*mean_tr2);
        A_comb = A_comb/sum(A_comb);

        A_norm = norm(A_comb);

        A_combn = A_comb/A_norm;
        tr_combn = tr_comb*A_norm;
        
        A_merge{n_cell} = A_combn;
        tr_merge{n_cell} = tr_combn;
        
%         merged_cell.A = A_combn;
%         merged_cell.C = zeros(1, numel(tr_combn));
%         merged_cell.YrA = tr_combn;
%         
        %deconvolve trace

        if plot_stuff
            im1 = reshape(full(A1), [256, 256]);
            im2 = reshape(full(A2), [256, 256]);
            im_comb = reshape(full(A_combn), [256, 256]);
            
            all_vals = [A1, A2, A_combn];
            max_val = full(max(all_vals(:)));
            
            n_marg = find(sum(im_comb,1));
            m_marg = find(sum(im_comb,2));
            m_lim = [m_marg(1), m_marg(end)];
            n_lim = [n_marg(1), n_marg(end)];

            figure; 
            subplot(2,3,1);
            imagesc(im1); title(sprintf('A1, cell%d', idx_lut(n_cell1))); 
            axis equal tight; caxis([0 max_val]); ylim(m_lim); xlim(n_lim);
            subplot(2,3,2);
            imagesc(im2); title(sprintf('A2, cell%d', idx_lut(n_cell2))); 
            axis equal tight; caxis([0 max_val]); ylim(m_lim); xlim(n_lim);
            subplot(2,3,3);
            imagesc(im_comb); title('Acomb'); 
            axis equal tight; caxis([0 max_val]); ylim(m_lim); xlim(n_lim);
            subplot(2,3,4:6); hold on; 
            plot(tr_combn, 'k'); plot(tr1); plot(tr2); 
            legend('trcomb', 'tr1', 'tr2'); axis tight;
            title(sprintf('trace corr=%.2f; spac corr=%.2f', cells_corr, sort_vals(n_cell)));

        end
        
    end
end

disp('Done');

% 
% im1 = reshape(full(A1), [256, 256]);
% im2 = reshape(full(A2), [256, 256]);
% im_comb = reshape(full(A_combn), [256, 256]);
% 
% all_vals = [A1, A2, A_combn];
% max_val = full(max(all_vals(:)));
% 
% n_marg = find(sum(im_comb,1));
% m_marg = find(sum(im_comb,2));
% 

% 
% 
% A_idx = logical(A_combn);
% 
% data_full = full(A1(A_idx)*tr1 + A2(A_idx)*tr2);
% 
% [U,S,V] = svd(data_full, 'econ');
% 
% data_lr = U(:,1:2)*S(1:2,1:2)*V(:,1:2)';
% 
% A_pc1 = U(:,1);
% A_pc2 = U(:,2);
% tr_pc1 = V(:,1)*S(1,1);
% tr_pc2 = V(:,2)*S(2,2);
% 
% figure; hold on;
% plot(tr_pc1);
% plot(tr_combn);
% 
% 
% A_pc1f = sparse(256*256,1);
% A_pc1f(A_idx) = A_pc1;
% A_pc2f = sparse(256*256,1);
% A_pc2f(A_idx) = A_pc2;
% 
% figure; imagesc(reshape(full(A_pc1f), [256 256]))
% figure; imagesc(reshape(full(A_pc2f), [256 256]))
% 
% A_rgb = zeros(256, 256, 3);
% A_rgb(:,:,1) = im1;
% A_rgb(:,:,2) = im2;
% A_rgb(:,:,3) = im_comb;
% 
% figure; imagesc(A_rgb/max_val*2)
% 
% figure; imagesc(im1);
% figure; imagesc(im2)
% figure; imagesc(A_combn)
% 
% figure; hold on;
% %plot(tr1);
% %plot(tr2);
% plot(tr_combn);
% 


end