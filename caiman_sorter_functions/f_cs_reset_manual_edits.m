function f_cs_reset_manual_edits(app)

app.proc.idx_manual = [];
app.proc.idx_manual_bad = [];

[app.est, app.proc] = f_cs_reset_est_proc(app.est, app.proc);

% Refresh top-level cell count + identity index. Without this,
% f_cs_update_idx_components below indexes a stale-length
% comp_accepted mask against the post-merge idx_components_all.
% Mirrors lines 54-55 of f_cs_find_similar_comp.m.
app.num_cells = size(app.est.C, 1);
app.idx_components_all = (1:app.num_cells)';

if app.current_cell_num > app.proc.num_cells
    app.current_cell_num = 1;
end

f_cs_update_idx_components(app);
f_cs_compute_background_im(app);
f_cs_update_image_plots(app);
% The bin-indexed contour Line2Ds are unchanged in count (K, not N);
% set_contours updates colors + triggers a rebuild that reads the new
% est.contours length, so no graphics-handle truncation is needed.
f_cs_set_contours(app);
f_cs_plot_curr_contour(app);

end