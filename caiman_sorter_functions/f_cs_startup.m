function f_cs_startup(app)

disp('Caiman Sorter GUI started');

app.VisualizationparamsPanel.Visible = 0;
app.CatracePanel.Visible = 0;
app.TabGroup.Visible = 0;
app.TabGroup2.Visible = 0;
app.CellselectionPanel.Visible = 0;

pwd2 = fileparts(which('caiman_sorter.mlapp'));
%pwd2 = pwd;

if exist([pwd2 '\caiman_sorter_functions'], 'dir')
    addpath([pwd2 '\caiman_sorter_functions']);
    addpath([pwd2 '\caiman_sorter_functions\deconvolution_dep']);
    addpath([pwd2 '\caiman_sorter_functions\deconvolution_dep\MCMC']);
    addpath([pwd2 '\caiman_sorter_functions\deconvolution_dep\MCMC\utilities']);
    addpath([pwd2 '\caiman_sorter_functions\deconvolution_dep\oasis']);
    addpath([pwd2 '\caiman_sorter_functions\deconvolution_dep\functions']);
else
    error('RAFA: You need to move to caiman sorter directory and reopen GUI!!!');
end
ops = f_cs_collect_ops(app);
ops_path = [pwd2 '\caiman_sorter_options.mat'];
ops.ops_path = ops_path;

if exist(ops_path, 'file')
    ops_temp = load(ops_path, 'ops');
    ops = ops_temp.ops;
    ops.ops_path = ops_path;
    f_cs_update_log(app, ['ops loaded path: ' ops.ops_path]);
    if ~strcmpi(ops_temp.ops.ops_path, ops_path)
        disp('RAFA: Welcome new user, you should join the Yuste lab, it is great, no?');
        f_cs_update_log(app, 'RAFA: Welcome new user, you should join the Yuste lab, it is great, no?');
    end
    f_cs_write_ops(app);
else
    save(ops_path, 'ops');
    disp('RAFA: Welcome new user, you should join the Yuste lab, it is great, no?');
    f_cs_update_log(app, 'RAFA: Welcome new user, you should join the Yuste lab, it is great, no?');
end

app.ops = ops;

end