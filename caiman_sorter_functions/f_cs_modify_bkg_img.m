function f_cs_modify_bkg_img(app, add_accept_comp)
    temp_text = app.BackgroundplotButtonGroup.SelectedObject.Text;
    temp_comp = app.A3d(:,:,app.current_cell_num);
    if strcmp(temp_text, 'Weighted comp')
        temp_comp = temp_comp * app.bkg_comp_weights(app.current_cell_num);
    end
    app.im_accepted_A_data = app.im_accepted_A_data + add_accept_comp*temp_comp;
    app.im_rejected_A_data = app.im_rejected_A_data - add_accept_comp*temp_comp;
end