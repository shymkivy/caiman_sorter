function f_cs_modify_bkg_img(app, add_accept_comp, current_cell_num)
    temp_text = app.BackgroundplotButtonGroup.SelectedObject.Text;
    temp_comp = reshape(full(app.est.A(:,current_cell_num)),app.est.dims(1),app.est.dims(2));
    if strcmp(temp_text, 'Weighted comp')
        temp_comp = temp_comp * app.bkg_comp_weights(app.current_cell_num);
    end
    app.im_accepted_A_data = app.im_accepted_A_data + add_accept_comp*temp_comp;
    app.im_rejected_A_data = app.im_rejected_A_data - add_accept_comp*temp_comp;
end
