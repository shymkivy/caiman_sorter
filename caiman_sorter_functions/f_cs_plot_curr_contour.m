function f_cs_plot_curr_contour(app)
    % highlight contour when clicked on
    temp_contours = app.est.contours{app.current_cell_num};
    if isgraphics(app.current_contour)
        delete(app.current_contour);
    end
    if app.proc.comp_accepted(app.current_cell_num)
        hold(app.UIAxes_Accepted, 'on');
        app.current_contour = plot(app.UIAxes_Accepted, temp_contours(:,1), temp_contours(:,2), 'color', [0.75, 0, 0.75], 'LineWidth', 2);
        hold(app.UIAxes_Accepted, 'off');
    else
        hold(app.UIAxes_Rejected, 'on');
        app.current_contour = plot(app.UIAxes_Rejected, temp_contours(:,1), temp_contours(:,2), 'color', [0.75, 0, 0.75], 'LineWidth', 2);
        hold(app.UIAxes_Rejected, 'off');
    end
end