function method = f_cs_get_foopsi_method(app)
% Read the foopsi solver dropdown and return a usable method tag.
%
% Returns one of: 'cvx', 'dual', 'oasis'.
%
% If the user picked an unavailable method (e.g. selected 'cvx' but CVX
% isn't on the path) — or if the dropdown widget doesn't exist at all —
% fall back to f_cs_pick_foopsi_method's best-installed pick. Also handles
% the legacy 'auto' string from older saved ops files.

% Widget absent (old .mlapp without the dropdown) → just auto-pick.
if ~isprop(app, 'DeconvMethodDropDownCfoopsi') ...
        || ~isobject(app.DeconvMethodDropDownCfoopsi)
    method = f_cs_pick_foopsi_method();
    return;
end

choice = app.DeconvMethodDropDownCfoopsi.Value;
if isempty(choice) || strcmpi(choice, 'auto')
    % Legacy 'auto' from older ops files — resolve and remember.
    method = f_cs_pick_foopsi_method();
    app.DeconvMethodDropDownCfoopsi.Value = method;
    return;
end

% Verify the chosen method is actually available; fall back if not.
available = true;
switch lower(choice)
    case 'cvx';   available = ~isempty(which('cvx_begin'));
    case 'dual';  available = exist('fmincon', 'file') == 2;
    case 'oasis'; available = true;
end

if ~available
    fallback = f_cs_pick_foopsi_method();
    f_cs_update_log(app, sprintf( ...
        'Foopsi method "%s" not installed; falling back to "%s".', ...
        choice, fallback));
    method = fallback;
else
    method = lower(choice);
end

end
