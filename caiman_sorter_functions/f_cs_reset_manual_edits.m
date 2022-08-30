function f_cs_reset_manual_edits(app)

app.proc.idx_manual = [];
app.proc.idx_manual_bad = [];

[app.est, app.proc] = f_cs_reset_est_proc(app.est, app.proc);

if app.current_cell_num > app.proc.num_cells
    app.current_cell_num = 1;
end

f_cs_update_idx_components(app);
f_cs_compute_background_im(app);
f_cs_update_image_plots(app);
f_cs_set_contours(app);   
f_cs_plot_curr_contour(app);

end