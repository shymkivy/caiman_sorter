function f_cs_autosave_ops(app)
% Save the current ops to disk IF the AutoSaveOpsCheckBox widget is
% present and checked. Silently does nothing otherwise. Safe to call
% from any natural save-point (post-save_data, app close, etc.) without
% caring whether the user wants auto-save enabled.
%
% If the checkbox doesn't exist in the .mlapp (older layout), defaults
% to ON — preserves the historical behaviour where Save Ops was always
% a single-click away and most users wanted ops preserved.

if isprop(app, 'AutoSaveOpsCheckBox') && isobject(app.AutoSaveOpsCheckBox)
    if ~app.AutoSaveOpsCheckBox.Value
        return;
    end
end

% Reuse the existing save path so save behaviour stays single-source.
f_cs_save_ops(app);

end
