function f_cs_populate_foopsi_dropdown(app)
% Populate the foopsi solver dropdown with availability-tagged labels and
% pre-select the best installed method.
%
% Layout: .Items holds display labels (with optional "(not installed)"
% suffix); .ItemsData holds the bare method tags. .Value returns the tag.
% Default selection = first installed in (cvx, dual, oasis) order, picked
% by f_cs_pick_foopsi_method — same rule the old 'auto' entry used.
%
% Call this once from f_cs_startup.m. Safe to call when the widget is
% absent (just no-ops) — backend defaults to picking best-available too.

if ~isprop(app, 'DeconvMethodDropDownCfoopsi') ...
        || ~isobject(app.DeconvMethodDropDownCfoopsi)
    return;
end

methods = {'oasis', 'cvx', 'dual'};
available = [...
    true, ...                                    % 'oasis' — vendored locally
    ~isempty(which('cvx_begin')), ...            % 'cvx' — needs CVX install
    exist('fmincon', 'file') == 2 ...            % 'dual' — needs Optimization Toolbox
    ];

labels = methods;
for k = 1:numel(methods)
    if ~available(k)
        labels{k} = [methods{k} ' (not installed)'];
    end
end

app.DeconvMethodDropDownCfoopsi.Items = labels;
app.DeconvMethodDropDownCfoopsi.ItemsData = methods;

% Default to whichever installed method has highest quality.
default = f_cs_pick_foopsi_method();
if isempty(app.DeconvMethodDropDownCfoopsi.Value) ...
        || strcmpi(app.DeconvMethodDropDownCfoopsi.Value, 'auto')
    app.DeconvMethodDropDownCfoopsi.Value = default;
end

end
