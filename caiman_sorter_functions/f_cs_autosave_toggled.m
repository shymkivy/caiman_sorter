function f_cs_autosave_toggled(app)
% Bypass-the-flag save. Wired to AutoSaveOpsCheckBox.ValueChangedFcn so
% the toggle state itself gets persisted immediately on change.
%
% Without this, turning auto-save OFF would never reach disk: auto-save
% is now off, the normal write at app close / save_data is suppressed,
% and the next session would still see the checkbox ON. Saving on every
% toggle (in either direction) avoids that.

f_cs_save_ops(app);

end
