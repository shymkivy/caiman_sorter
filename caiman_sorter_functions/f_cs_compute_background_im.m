function f_cs_compute_background_im(app)
    % Fall back to est.dims if proc.dims is missing, wrong size, or zero —
    % some externally-written .mat files have proc.dims = [0 0].
    dims = app.proc.dims;
    if numel(dims) < 2 || any(dims(1:2) == 0) ...
            || prod(dims(1:2)) ~= size(app.est.A, 1)
        dims = app.est.dims;
        app.proc.dims = dims;   % cache the corrected value
    end
    temp_text = app.BackgroundplotButtonGroup.SelectedObject.Text;
    if strcmp(temp_text, 'Components')
        app.im_accepted_A_data = reshape(full(sum(app.est.A(:,app.proc.comp_accepted),2)), dims(1), dims(2));
        app.im_rejected_A_data = reshape(full(sum(app.est.A(:,~app.proc.comp_accepted),2)), dims(1), dims(2));
    else
        app.im_accepted_A_data = reshape(full(app.est.A(:,app.proc.comp_accepted)) * app.bkg_comp_weights(app.proc.comp_accepted), dims(1), dims(2));
        app.im_rejected_A_data = reshape(full(app.est.A(:,~app.proc.comp_accepted)) * app.bkg_comp_weights(~app.proc.comp_accepted), dims(1), dims(2));
        if strcmp(temp_text, 'W comp + bkg')
            app.im_accepted_A_data = app.im_accepted_A_data + app.bkg_bgkcomp;
            app.im_rejected_A_data = app.im_rejected_A_data + app.bkg_bgkcomp;
        end
    end
end