function f_cs_startup(app)
disp('Caiman Sorter GUI started');

app.VisualizationparamsPanel.Visible = 0;
app.CatracePanel.Visible = 0;
app.TabGroup.Visible = 0;
app.TabGroup2.Visible = 0;
app.CellselectionPanel.Visible = 0;

% Populate the foopsi solver dropdown with availability-tagged labels
% (mirrors the Python sorter). No-op if the widget hasn't been added in
% App Designer yet — backend defaults to 'auto' in that case.
f_cs_populate_foopsi_dropdown(app);

% Set tooltips on every user-facing widget so the .mlapp doesn't have to
% carry them (and they stay editable in one .m file rather than App
% Designer property dialogs).
f_cs_set_tooltips(app);

ops = f_cs_collect_ops(app);

% Resolve ops_path to an absolute, always-writable location. The .mlapp
% bakes in a relative default ('caiman_sorter_options.mat') which lands
% in whatever working directory MATLAB had when the app launched —
% impossible to predict, and often not writable. Fall back to prefdir
% (per-user, always exists) when the configured path is empty or doesn't
% live in an existing directory.
ops_path = app.ops_path;
if isempty(ops_path) || ~exist(fileparts(ops_path), 'dir')
    ops_path = fullfile(prefdir, 'caiman_sorter_options.mat');
    app.ops_path = ops_path;
end
ops.ops_path = ops_path;
f_cs_update_log(app, ['ops path: ' ops_path]);

if exist(ops_path, 'file')
    try
        ops_temp = load(ops_path, 'ops');
        ops = ops_temp.ops;
        ops.ops_path = ops_path;
        f_cs_update_log(app, ['ops loaded path: ' ops.ops_path]);
        if ~isfield(ops_temp.ops, 'ops_path') || ~strcmpi(ops_temp.ops.ops_path, ops_path)
            disp('RAFA: Welcome new user, you should join the Yuste lab, it is great, no?');
            f_cs_update_log(app, 'RAFA: Welcome new user, you should join the Yuste lab, it is great, no?');
        end
        % Assign to app BEFORE write_ops — that helper reads app.ops to set
        % every widget value, so the assignment must precede the call.
        app.ops = ops;
        f_cs_write_ops(app);
    catch ME
        f_cs_update_log(app, ['Failed to load ops from ' ops_path ': ' ME.message]);
        app.ops = ops;  % keep the freshly-collected defaults
    end
else
    try
        save(ops_path, 'ops');
        f_cs_update_log(app, ['Created new ops file: ' ops_path]);
    catch ME
        f_cs_update_log(app, ['Failed to create ops file at ' ops_path ': ' ME.message]);
    end
    disp('RAFA: Welcome new user, you should join the Yuste lab, it is great, no?');
    f_cs_update_log(app, 'RAFA: Welcome new user, you should join the Yuste lab, it is great, no?');
    app.ops = ops;
end

end