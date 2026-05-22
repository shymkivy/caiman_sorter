function f_cs_set_contours(app)
    if strcmp(app.PlotContoursButtonGroup.SelectedObject.Text,'None')
        app.curr_contour_params.visible_set = 0;
        app.curr_contour_params.contour_mag = zeros(app.proc.num_cells,1);
        app.curr_contour_params.c_abs_lim = [0, 0];
        app.curr_contour_params.c_lim = [0 0];
    elseif strcmp(app.PlotContoursButtonGroup.SelectedObject.Text,'SNR caiman')
        app.curr_contour_params.visible_set = 1;
        app.curr_contour_params.contour_mag = app.est.SNR_comp; % factor to resize magnitudes to fir color
        app.curr_contour_params.c_lim = app.SNR_lim;
        app.curr_contour_params.c_abs_lim = app.SNR_abs_lim;
    elseif strcmp(app.PlotContoursButtonGroup.SelectedObject.Text,'SNR2')
        app.curr_contour_params.visible_set = 1;
        app.curr_contour_params.contour_mag = app.proc.SNR2_vals; % factor to resize magnitudes to fir color
        app.curr_contour_params.c_lim = app.SNR2_lim;
        app.curr_contour_params.c_abs_lim = app.SNR2_abs_lim;
    elseif strcmp(app.PlotContoursButtonGroup.SelectedObject.Text,'CNN')
        app.curr_contour_params.visible_set = 1;
        app.curr_contour_params.contour_mag = app.est.cnn_preds;
        app.curr_contour_params.c_lim = app.cnn_lim;
        app.curr_contour_params.c_abs_lim = [0, 1];
    elseif strcmp(app.PlotContoursButtonGroup.SelectedObject.Text,'R values')
        app.curr_contour_params.visible_set = 1;
        app.curr_contour_params.contour_mag = app.est.r_values;
        app.curr_contour_params.c_lim = app.rval_lim;
        app.curr_contour_params.c_abs_lim = [-1, 1];
    elseif strcmp(app.PlotContoursButtonGroup.SelectedObject.Text,'Firing stability')
        app.curr_contour_params.visible_set = 1;
        app.curr_contour_params.contour_mag = app.proc.firing_stab_vals;
        app.curr_contour_params.c_lim = app.firing_stab_lim;
        app.curr_contour_params.c_abs_lim = [0, 1];
    end    


    c_lim = app.curr_contour_params.c_lim;

    app.ContourMinEditField.Value = c_lim(1);
    app.ContourMaxEditField.Value = c_lim(2);

    % Palette display (small colorbar widget) — sample finely so the
    % displayed gradient stays smooth regardless of K.
    palette_resolution = app.contour_resolution;
    palette_map = jet(round(palette_resolution*c_lim(2)) ...
                      - round(palette_resolution*c_lim(1)) + 1);
    palette_index = round(palette_resolution*c_lim(1)) ...
                    : round(palette_resolution*c_lim(2));
    imagesc(app.UIAxesColorPallet, palette_index/palette_resolution, 1, ...
            reshape(palette_map, 1, [], 3));
    axis(app.UIAxesColorPallet, 'tight');

    % Set the per-bin colors on the K Line2Ds. K is the length of the
    % gobject arrays (created by f_cs_initialize_contours; currently 32).
    % All cells whose metric value falls in bin k get drawn with bin_colors(k).
    K = numel(app.im_accepted_gobj);
    bin_colors = jet(K);
    for k = 1:K
        app.im_accepted_gobj(k).Color = bin_colors(k, :);
        app.im_rejected_gobj(k).Color = bin_colors(k, :);
    end

    % Rebuild XData/YData per bin based on current contour_mag / accepted.
    f_cs_rebuild_contours(app);

end