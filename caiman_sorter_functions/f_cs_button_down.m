function f_cs_button_down(app, src, fig_type)
    % get coordinates of mouse click and type of click
    info = get(src);
    coord = round(info.Parent.CurrentPoint(1,1:2));
    coord1 = min(max(coord(1), 0), double(app.proc.dims(2)));
    coord2 = min(max(coord(2), 0), double(app.proc.dims(1)));
    indx_current =  sub2ind(app.proc.dims', coord2, coord1);
    selection_type = app.UIFigure.SelectionType;
    app.last_cell_num = app.current_cell_num;
    

    if strcmp(selection_type, 'alt')
        if strcmp(fig_type, 'accepted')
            add_accept_comp = -1;
        else
            add_accept_comp = 1;
        end
    else
        add_accept_comp = 0;
    end


    if strcmp(fig_type, 'accepted')
        pix_vals = app.est.A(indx_current,app.proc.comp_accepted);
        [temp_val, temp_cell_ind] = max(pix_vals);
        if full(temp_val) > 0
            app.current_cell_num = app.proc.idx_components(temp_cell_ind);
            if strcmp(selection_type, 'alt')
                if strcmp(app.ManualEditsSwitch.Value,'On')
                    f_manual_remove_comp(app);
                    f_manual_remove_contour(app);
                    f_cs_modify_bkg_img(app, add_accept_comp, app.current_cell_num)
                end
            end
        end
    elseif strcmp(fig_type, 'rejected')
        pix_vals = app.est.A(indx_current,~app.proc.comp_accepted);
        [temp_val, temp_cell_ind] = max(pix_vals);
        if full(temp_val) > 0
            app.current_cell_num = app.proc.idx_components_bad(temp_cell_ind);
            if strcmp(selection_type, 'alt')
                if strcmp(app.ManualEditsSwitch.Value,'On')
                    f_manual_add_comp(app);
                    f_manual_add_contour(app);
                    f_cs_modify_bkg_img(app, add_accept_comp, app.current_cell_num)
                end
            end
        end
    end
    f_cs_update_idx_components(app);
    %f_cs_compute_background_im(app);
    f_cs_update_image_plots(app);
    f_cs_update_curr_cell_info(app);
end

function f_manual_add_comp(app)
    app.proc.idx_manual = union(app.proc.idx_manual, app.current_cell_num);
    app.proc.idx_manual_bad = setdiff(app.proc.idx_manual_bad, app.proc.idx_manual);
end

function f_manual_remove_comp(app)
    app.proc.idx_manual_bad = union(app.proc.idx_manual_bad, app.current_cell_num);
    app.proc.idx_manual = setdiff(app.proc.idx_manual, app.proc.idx_manual_bad);
end

function f_manual_add_contour(app)
    if ~strcmp(app.PlotContoursButtonGroup.SelectedObject.Text,'None')
        app.im_accepted_gobj(app.current_cell_num).Visible = 1;
        app.im_rejected_gobj(app.current_cell_num).Visible = 0;
    end
end

function f_manual_remove_contour(app)
    % background countours with clicked on fig (faster than set_contours for this purpose)
    if ~strcmp(app.PlotContoursButtonGroup.SelectedObject.Text,'None')
        app.im_accepted_gobj(app.current_cell_num).Visible = 0;
        app.im_rejected_gobj(app.current_cell_num).Visible = 1;
    end
end