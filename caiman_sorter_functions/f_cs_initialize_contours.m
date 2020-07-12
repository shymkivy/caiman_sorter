function f_cs_initialize_contours(app)

    % creates gobjects and plots all beackground contours to make
    % plotting later faster
    app.im_accepted_gobj = gobjects(app.proc.num_cells,1);
    hold(app.UIAxes_Accepted, 'on');
    for n_cell = 1:app.proc.num_cells
        temp_contours = app.est.contours{n_cell};
        app.im_accepted_gobj(n_cell) = plot(app.UIAxes_Accepted, temp_contours(:,1), temp_contours(:,2), 'LineWidth', 1, 'Visible', 0);
    end
    hold(app.UIAxes_Accepted, 'off');

    app.im_rejected_gobj = gobjects(app.proc.num_cells,1);
    hold(app.UIAxes_Rejected, 'on');
    for n_cell = 1:app.proc.num_cells
        temp_contours = app.est.contours{n_cell};
        app.im_rejected_gobj(n_cell) = plot(app.UIAxes_Rejected, temp_contours(:,1), temp_contours(:,2), 'LineWidth', 1, 'Visible', 0);
    end
    hold(app.UIAxes_Rejected, 'off');

end 