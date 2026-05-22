function f_cs_initialize_contours(app)
    % Create K empty Line2D objects per axis, one per color bin. Per-cell
    % polygons are concatenated (NaN-separated) into the bin they belong
    % to by f_cs_rebuild_contours, which is called whenever
    % proc.comp_accepted / est.contours / curr_contour_params change.
    %
    % Previous design: one Line2D per cell per axis (e.g. 1150 objects
    % for 575 cells). Initial draw was slow and every per-metric refresh
    % had to loop N times. K=32 is enough resolution to look like a
    % continuous gradient under the jet colormap.
    K = 32;

    % Delete any prior contour lines (e.g. from a previous load).
    if isprop(app, 'im_accepted_gobj') && ~isempty(app.im_accepted_gobj)
        delete(app.im_accepted_gobj(isgraphics(app.im_accepted_gobj)));
    end
    if isprop(app, 'im_rejected_gobj') && ~isempty(app.im_rejected_gobj)
        delete(app.im_rejected_gobj(isgraphics(app.im_rejected_gobj)));
    end

    app.im_accepted_gobj = gobjects(K, 1);
    app.im_rejected_gobj = gobjects(K, 1);

    hold(app.UIAxes_Accepted, 'on');
    hold(app.UIAxes_Rejected, 'on');
    for k = 1:K
        app.im_accepted_gobj(k) = plot(app.UIAxes_Accepted, NaN, NaN, ...
            'LineWidth', 1, 'Visible', 0);
        app.im_rejected_gobj(k) = plot(app.UIAxes_Rejected, NaN, NaN, ...
            'LineWidth', 1, 'Visible', 0);
    end
    hold(app.UIAxes_Accepted, 'off');
    hold(app.UIAxes_Rejected, 'off');
end 