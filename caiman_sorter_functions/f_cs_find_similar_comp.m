function f_cs_find_similar_comp(app)

disp('looking for components to merge...');

params.apply_merge = app.MergesimilarcompCheckBox.Value;
params.merge_method = app.MergemethodDropDown.Value;
params.plot_stuff = 1;
params.spac_thr = app.spatialcorrthershEditField.Value;
params.temp_thr = app.tempcorrtheshEditField.Value;

dc_params.use_manual_params = app.UsemanualtimeconstantsCheckBoxCfoopsi.Value;
dc_params.p = str2double(app.ARmodelSwitchCfoopsi.Value);
dc_params.manual_tau_rise = app.TauriseEditFieldCfoopsi.Value;
dc_params.manual_tau_decay = app.TaudecayEditFieldCfoopsi.Value;
dc_params.fudge_factor = app.FudgeFactorEditField.Value;

params.dc_params = dc_params;

est = app.est;
proc = app.proc;

[est, proc] = f_cs_reset_est_proc(est, proc);

if app.UseacceptedcellsCheckBox.Value
    params.comp_acc = proc.comp_accepted;
else
    params.comp_acc = true(proc.num_cells,1);
end

[est, proc] = f_cs_find_similar_comp_core(est, proc, params);

app.est =  est;
app.proc = proc;

app.num_cells = size(app.est.C,1);
app.idx_components_all = (1:app.num_cells)';

f_cs_update_idx_components(app);
f_cs_compute_background_im(app)
f_cs_update_image_plots(app);
f_cs_plot_curr_contour(app);

disp('Done');

end