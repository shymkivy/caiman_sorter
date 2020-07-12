function f_cs_initialize_im(app)

% initialize accepted components image
A_tot = app.im_accepted_A_data;
if isempty(app.UIAxes_Accepted.Children)
    new_plot = 1;
else
    new_plot = 0;
end
app.im_accepted = imagesc(app.UIAxes_Accepted, A_tot);
app.im_accepted.ButtonDownFcn = @(~,~) f_cs_button_down(app, app.im_accepted, 'accepted');
app.UIAxes_Accepted.Title.String = sprintf('Accepted; %d cells', sum(app.proc.comp_accepted));
if new_plot
    axis(app.UIAxes_Accepted,'tight');
end

% initialize rejected components image
A_disc_tot = app.im_rejected_A_data;
if isempty(app.UIAxes_Rejected.Children)
    new_plot = 1;
else
    new_plot = 0;
end
app.im_rejected = imagesc(app.UIAxes_Rejected, A_disc_tot);
app.im_rejected.ButtonDownFcn = @(~,~) f_cs_button_down(app, app.im_rejected, 'rejected');
app.UIAxes_Rejected.Title.String = sprintf('Rejected; %d cells', sum(~app.proc.comp_accepted));
if new_plot
    axis(app.UIAxes_Rejected,'tight');
end
end