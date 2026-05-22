function f_cs_compute_constrained_oasis(app, n_cell)

y = double(app.est.C(n_cell,:) + app.est.YrA(n_cell,:));

p = str2double(app.ARmodelSwitchCfoopsi.Value);
dt = 1/double(app.ops.init_params_caiman.data.fr);

sn = app.proc.noise(n_cell);
if p == 1
    if app.UsemanualtimeconstantsCheckBoxCfoopsi.Value
        g = tau_c2d(Inf, app.TaudecayEditFieldCfoopsi.Value, dt);
    else
        g = app.proc.gAR1(n_cell);
    end
elseif p == 2
    if app.UsemanualtimeconstantsCheckBoxCfoopsi.Value
        g = tau_c2d(app.TauriseEditFieldCfoopsi.Value, app.TaudecayEditFieldCfoopsi.Value, dt);
    else
        g = app.proc.gAR2(n_cell,:);
    end
end


options.p = p;
options.optimize_pars = true;
options.method = f_cs_get_foopsi_method(app);   % respect dropdown choice
options.fudge_factor = app.FudgeFactorEditField.Value;

% Pre-shrink AR poles by fudge_factor to compensate for time-constant
% estimation bias. constrained_foopsi applies it internally; OASIS doesn't
% know about it, so we do it here on g before passing in.
g_in = f_cs_apply_fudge(g, options.fudge_factor);

% AR1: constrained_oasisAR1 works directly.
% AR2: vendored constrained_oasisAR2 is broken (nested update_phi /
%   update_lam_b use scalar g^N, error on 2-vector). Approximate the
%   noise-constrained formulation: estimate baseline + use choose_lambda
%   to pick a noise-aware lambda + run foopsi_oasisAR2 which dispatches
%   to the correct AR2 inner solver.
if p == 1
    options.optimize_b = true;
    [c, sp, options.b, options.pars, options.lambda] = constrained_oasisAR1(y, ...
                    g_in, sn, options.optimize_b, options.optimize_pars, [], []);
else
    options.optimize_b = false;
    b = quantile(y(:), 0.15);
    options.lambda = choose_lambda(g_in(:)', sn);
    [c, sp, ~, g_out] = foopsi_oasisAR2(y(:) - b, g_in(:), options.lambda, ...
                    false, options.optimize_pars, [], []);
    c = c + b;
    options.b = b;
    options.pars = g_out;
end

% If neither CVX nor fmincon is available, f_cs_pick_foopsi_method returns
% 'oasis' — the constrained_oasisAR2 call above already gave us a valid c/sp,
% so skip the refinement step that would otherwise error or no-op.
if ~strcmpi(options.method, 'oasis')
    try
        [cc, b, c1, ~, ~, sp] = constrained_foopsi(y,[],[],g, sn, options);
        gd = max(roots([1,-g]));  % decay time constant for initial concentration
        gd_vec = gd.^((0:length(y)-1));
        c = cc(:) + c1*gd_vec' + b;
    catch ME
        % constrained_foopsi failed (e.g. picked method but solver still
        % errored) — keep the OASIS result from above.
        warning('caiman_sorter:foopsi_skipped', ...
            'constrained_foopsi failed; using OASIS result alone. Reason: %s', ...
            strrep(ME.message, '%', '%%'));
    end
end

app.proc.deconv.c_foopsi.S{n_cell} = sp';
app.proc.deconv.c_foopsi.C{n_cell} = c';
app.proc.deconv.c_foopsi.p{n_cell} = p;
app.proc.deconv.c_foopsi.g{n_cell} = g;

end