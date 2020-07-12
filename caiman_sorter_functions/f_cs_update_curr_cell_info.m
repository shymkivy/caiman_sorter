function f_cs_update_curr_cell_info(app)
    app.CellnumberSpinner.Value = app.current_cell_num;
    f_cs_plot_cell_trace(app);
    f_cs_fill_current_cell_info(app)
    f_cs_plot_curr_contour(app);
end