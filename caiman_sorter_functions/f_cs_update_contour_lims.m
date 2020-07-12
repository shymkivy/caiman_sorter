function f_cs_update_contour_lims(app)
    if strcmp(app.PlotContoursButtonGroup.SelectedObject.Text,'SNR caiman')
        app.SNR_lim = app.curr_contour_params.c_lim;
    elseif strcmp(app.PlotContoursButtonGroup.SelectedObject.Text,'SNR2')
        app.SNR2_lim = app.curr_contour_params.c_lim;
    elseif strcmp(app.PlotContoursButtonGroup.SelectedObject.Text,'CNN')
        app.cnn_lim = app.curr_contour_params.c_lim;
    elseif strcmp(app.PlotContoursButtonGroup.SelectedObject.Text,'R values')
        app.rval_lim = app.curr_contour_params.c_lim;
    elseif strcmp(app.PlotContoursButtonGroup.SelectedObject.Text,'Firing stability')
        app.firing_stab_lim = app.curr_contour_params.c_lim;
    end
end