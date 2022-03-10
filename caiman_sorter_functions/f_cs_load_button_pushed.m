function f_cs_load_button_pushed(app)

if ~isempty(app.file_loc)
    fw = app.UIFigure;
    hw = uiprogressdlg(fw,'Title','Loading data...');
    
    f_cs_update_log(app, 'Loading ...');
    [filepath,filename,ext] = fileparts(app.file_loc);
    
    clear app.proc app.est
    
    % process h5 file if opened\
    if strcmpi(ext,'.hdf5') || strcmpi(ext,'.hdf') || strcmpi(ext,'.h5')
        temp_dims = h5read(app.file_loc,'/estimates/dims');
        % import caiman settings
        app.est = f_cs_extract_h5_data(app.file_loc, temp_dims);
        app.est.dims = temp_dims;
        app.ops.eval_params_caiman = app.est.eval_params_caiman;
        app.ops.init_params_caiman = app.est.init_params_caiman;
        f_cs_update_log(app, ['Loaded .hdf5: ' strrep(app.file_loc, '\', '\\')])
        app.mat_file_loc = [filepath '\' filename '_sort.mat'];
        
        f_cs_update_log(app, 'Initializing proc data...');
        app.proc = f_cs_initialize_new_proc(app.est, app.ops);
        
        f_cs_update_log(app, 'Loaded caiman estimated components')

    elseif strcmp(ext,'.mat')
        app.mat_file_loc = app.file_loc;
        temp_load = load(app.mat_file_loc);
        if ~issparse(temp_load.est.A)
            temp_load.est.A = sparse(double(temp_load.est.A));
        end
        app.est = temp_load.est;
        if isfield(temp_load, 'dims')
            app.est.dims = temp_load.dims;
        end
        if isfield(temp_load, 'ops')
            browse_path = app.ops.browse_path;
            app.ops = temp_load.ops;
            app.ops.browse_path = browse_path;
        end
        if isfield(temp_load, 'proc')
            app.proc = temp_load.proc;
        end
        f_cs_update_log(app, ['Loaded .mat: ' strrep(app.file_loc, '\', '\\')]);
    end
    
    app.VisualizationparamsPanel.Visible = 1;
    app.CatracePanel.Visible = 1;
    app.TabGroup.Visible = 1;
    app.TabGroup2.Visible = 1;
    app.CellselectionPanel.Visible = 1;
    
    f_cs_write_ops(app);
    f_cs_update_log(app, 'Initializing...');
    f_cs_initialize_GUI_params(app);

    axis(app.UIAxes_ca_trace, 'tight');

    f_cs_initialize_im(app);
    f_cs_initialize_contours(app);       % maybe slow
    f_cs_initialize_deconvolution(app);

    % evaluate with default settings
    f_cs_evaluate_components(app);
    f_cs_update_idx_components(app);
    f_cs_compute_background_im(app);
    f_cs_update_image_plots(app);
    f_cs_set_contours(app);          % maybe slow
    f_cs_update_contour_lims(app);
    f_cs_update_curr_cell_info(app);

    % turn on panels
    app.SavedataButton.Enable = true;
    
    close(hw);
    f_cs_update_log(app, 'Ready');
else
    f_cs_update_log(app, 'Select file to load');
end

end