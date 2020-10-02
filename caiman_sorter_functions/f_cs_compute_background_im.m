function f_cs_compute_background_im(app)
    temp_text = app.BackgroundplotButtonGroup.SelectedObject.Text;
    if strcmp(temp_text, 'Components')
        app.im_accepted_A_data = reshape(full(sum(app.est.A(:,app.proc.comp_accepted),2)), app.proc.dims(1), app.proc.dims(2));
        app.im_rejected_A_data = reshape(full(sum(app.est.A(:,~app.proc.comp_accepted),2)), app.proc.dims(1), app.proc.dims(2));
    else
        app.im_accepted_A_data = reshape(full(app.est.A(:,app.proc.comp_accepted)) * app.bkg_comp_weights(app.proc.comp_accepted),app.proc.dims(1), app.proc.dims(2));
        app.im_rejected_A_data = reshape(full(app.est.A(:,~app.proc.comp_accepted)) * app.bkg_comp_weights(~app.proc.comp_accepted),app.proc.dims(1), app.proc.dims(2));
        if strcmp(temp_text, 'W comp + bkg')
            app.im_accepted_A_data = app.im_accepted_A_data + app.bkg_bgkcomp;
            app.im_rejected_A_data = app.im_rejected_A_data + app.bkg_bgkcomp;
        end
    end
end