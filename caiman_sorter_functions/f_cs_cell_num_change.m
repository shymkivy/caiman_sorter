function f_cs_cell_num_change(app)

temp_val = round(app.CellnumberSpinner.Value);
temp_val = max(temp_val, 1);
temp_val = min(temp_val, app.proc.num_cells);
app.current_cell_num = temp_val;
app.CellnumberSpinner.Value = temp_val;
f_cs_update_curr_cell_info(app);

end