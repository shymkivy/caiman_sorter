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
    visible_set = app.curr_contour_params.visible_set;

    app.ContourMinEditField.Value = c_lim(1);
    app.ContourMaxEditField.Value = c_lim(2);


    % crop if goes beyond lim
    contour_mag = max(app.curr_contour_params.contour_mag, c_lim(1));
    contour_mag = min(contour_mag, c_lim(2));

    % create color map
    color_map = jet(round(app.contour_resolution*c_lim(2)) - round(app.contour_resolution*c_lim(1))+1); 
    color_index = round(app.contour_resolution*c_lim(1)):round(app.contour_resolution*c_lim(2));
    imagesc(app.UIAxesColorPallet, color_index/app.contour_resolution, 1, reshape(color_map,1,[],3));
    axis(app.UIAxesColorPallet, 'tight');

    % update colors
    for n_cell = 1:app.proc.num_cells
        if app.proc.comp_accepted(n_cell)
            app.im_accepted_gobj(n_cell).Visible = visible_set;
            app.im_accepted_gobj(n_cell).Color = color_map(round(app.contour_resolution*contour_mag(n_cell)) == color_index,:); 
            app.im_rejected_gobj(n_cell).Visible = 0;

        else
            app.im_accepted_gobj(n_cell).Visible = 0;
            app.im_rejected_gobj(n_cell).Visible = visible_set;
            app.im_rejected_gobj(n_cell).Color = color_map(round(app.contour_resolution*contour_mag(n_cell)) == color_index,:); 
        end

    end

end