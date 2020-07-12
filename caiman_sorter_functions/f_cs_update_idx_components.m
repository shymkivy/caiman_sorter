function f_cs_update_idx_components(app)
    % add manual components if want
    app.proc.comp_accepted = app.proc.comp_accepted_core;
    if strcmp(app.ManualEditsSwitch.Value, "On")
        app.proc.comp_accepted(app.proc.idx_manual) = 1;
        app.proc.comp_accepted(app.proc.idx_manual_bad) = 0;
    end
    app.proc.idx_components = app.idx_components_all(app.proc.comp_accepted);
    app.proc.idx_components_bad = app.idx_components_all(~app.proc.comp_accepted);
end