function f_cs_initialize_GUI_params(app)

% precompute variables
app.num_cells = size(app.est.C,1);
app.num_frames = size(app.est.C,2);
app.idx_components_all = 1:app.num_cells;
app.current_cell_num = 1;
app.bkg_comp_weights = mean(app.est.C,2);
app.bkg_bgkcomp = reshape((mean(app.est.f)*app.est.b)',app.est.dims(1),app.est.dims(2));
app.DataframeratefpsEditField.Value = double(app.est.init_params_caiman.data.fr);

% process caiman SNR vals to make sure there are no inf 
inf_comp = app.est.SNR_comp == Inf;
app.est.SNR_comp(inf_comp) = 0;
app.est.SNR_comp(inf_comp) = max(app.est.SNR_comp);

app.SNR_abs_lim = [round(10*min(app.est.SNR_comp))/10 round(10*max(app.est.SNR_comp))/10];
app.SNR2_abs_lim = [round(10*min(app.proc.SNR2_vals))/10 round(10*max(app.proc.SNR2_vals))/10];
%app.SNR_lim = app.SNR_abs_lim;
%app.SNR2_lim = app.SNR2_abs_lim;

end