function f_cs_update_image_plots(app)
    app.im_accepted.CData = app.im_accepted_A_data;
    app.im_rejected.CData = app.im_rejected_A_data;
    drawnow;
    app.UIAxes_Accepted.Title.String = sprintf('Accepted; %d cells', sum(app.proc.comp_accepted));
    app.UIAxes_Rejected.Title.String = sprintf('Rejected; %d cells', sum(~app.proc.comp_accepted));
end