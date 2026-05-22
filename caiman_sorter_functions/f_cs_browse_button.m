function ops = f_cs_browse_button(app)

ops = app.ops;

% Seed uigetfile with: full path to the last loaded file if it still
% exists (pre-selects it in the dialog) → else just the last directory →
% else the working dir with the default filter set.
% f_cs_load_button_pushed accepts .hdf5/.hdf/.h5 so all three are listed.
filters = {'*.mat;*.hdf5;*.h5;*.hdf'; '*.mat'; '*.hdf5;*.h5;*.hdf'};

seed = '';
if isfield(ops, 'last_file') && ~isempty(ops.last_file) && exist(ops.last_file, 'file')
    seed = ops.last_file;
elseif isfield(ops, 'browse_path') && exist(ops.browse_path, 'dir')
    seed = [ops.browse_path '*.mat;*.hdf5;*.h5;*.hdf'];
end

if isempty(seed)
    [file_name, path] = uigetfile(filters);
else
    [file_name, path] = uigetfile(filters, 'Select file', seed);
end

if path
    ops.browse_path = path;
end

drawnow; pause(0.05);
app.UIFigure.Visible = 'off';
app.UIFigure.Visible = 'on';
if isequal(file_name,0)
   disp('User selected Cancel');
else
   app.file_loc = fullfile(path,file_name);
   disp(['User selected ', app.file_loc]);
   app.LoadDataEditField.Value = app.file_loc;
end

app.ops = ops;
end