function f_cs_cell_num_change_key(app, event)

if app.PressupdownkeytochangecellnumButton.Value
    
    if strcmpi(app.CellcategoryButtonGroup.SelectedObject.Text, 'Accepted')
        cells_list = find(app.proc.comp_accepted);
    elseif strcmpi(app.CellcategoryButtonGroup.SelectedObject.Text, 'Rejected')
        cells_list = find(~app.proc.comp_accepted);
    elseif strcmpi(app.CellcategoryButtonGroup.SelectedObject.Text, 'All')
        cells_list = (1:app.proc.num_cells)';
    end
    
    if strcmp(event.Key, 'uparrow')
        cells_list2 = cells_list > app.current_cell_num;
        if sum(cells_list2)
            app.current_cell_num = cells_list(find(cells_list2, 1));
        else
            app.current_cell_num = max(cells_list);
        end
        f_cs_update_curr_cell_info(app);
    elseif strcmp(event.Key, 'downarrow')
        cells_list2 = cells_list(cells_list < app.current_cell_num);
        if numel(cells_list2)
            app.current_cell_num = max(cells_list2);
        else
            app.current_cell_num = min(cells_list);
        end
        f_cs_update_curr_cell_info(app);
    end
end

end