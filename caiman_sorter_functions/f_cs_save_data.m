function f_cs_save_data(app)

fw = app.UIFigure;
hw = uiprogressdlg(fw,'Title','Saving data...');

app.ops = f_cs_collect_ops(app);
app.proc.deconv.smooth_dfdt.params =    app.ops.deconv.smooth_dfdt.params;
app.proc.deconv.c_foopsi.params =       app.ops.deconv.c_foopsi.params;
app.proc.deconv.MCMC.params =           app.ops.deconv.MCMC.params;

ops = app.ops;
proc = app.proc;
est = app.est;

save(app.mat_file_loc, 'est', 'proc', 'ops', '-v7.3');
%             if exist(app.mat_file_loc, 'file')
%                 
%             else
%                 save(app.mat_file_loc, 'est', 'proc', 'ops');
%             end
f_cs_update_log(app, 'Saved data');

close(hw);

end