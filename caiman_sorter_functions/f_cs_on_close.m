function f_cs_on_close(app, event) %#ok<INUSD>
% Close-request handler: persist ops then close the app. Wire this from
% the .mlapp UIFigure's CloseRequestFcn in App Designer:
%
%   function UIFigureCloseRequest(app, event)
%       f_cs_on_close(app, event);
%   end
%
% Saves ops via the autosave path (so the user's "autosave off" choice
% is still respected — only the toggle callback bypasses the flag).
% Then deletes the app, which is what the default close behaviour does.

try
    f_cs_autosave_ops(app);
catch ME
    % Don't block close just because save errored.
    fprintf(2, 'Autosave on close failed: %s\n', ME.message);
end

delete(app);

end
