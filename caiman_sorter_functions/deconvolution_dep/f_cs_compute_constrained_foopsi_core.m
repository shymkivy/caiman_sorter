function [c, sp] = f_cs_compute_constrained_foopsi_core(y, g, sn, options)

% Default method 'cvx' errors if CVX isn't installed (blocking merges and
% single-cell deconv). Pick something that works given what's on the path.
% Caller can still override by pre-setting options.method.
if ~isfield(options, 'method') || isempty(options.method)
    options.method = f_cs_pick_foopsi_method();
end

% Special case 'oasis': constrained_foopsi doesn't know that name. Route
% to the vendored OASIS solvers directly — pure MATLAB, no external deps.
% constrained_foopsi applies fudge_factor inside the solver; for OASIS we
% pre-shrink the AR poles ourselves before handing them in.
if strcmpi(options.method, 'oasis')
    g_in = g;
    if isfield(options, 'fudge_factor') && ~isempty(options.fudge_factor)
        g_in = f_cs_apply_fudge(g, options.fudge_factor);
    end
    [c, sp] = local_oasis_deconv(y, g_in, sn);
    return;
end

try
    [cc, b, c1, ~, ~, sp] = constrained_foopsi(y,[],[],g, sn, options);
    gd = max(roots([1,-g]));  % decay time constant for initial concentration
    gd_vec = gd.^((0:length(y)-1));
    c = cc(:) + c1*gd_vec' + b;
catch ME
    % If the chosen method also fails (e.g. fmincon errored, CVX returned
    % infeasible), fall back to OASIS so the merge still produces a real
    % deconvolution rather than passthrough.
    warning('caiman_sorter:foopsi_fallback', ...
        'constrained_foopsi failed; falling back to OASIS. Reason: %s', ...
        strrep(ME.message, '%', '%%'));
    try
        g_fb = g;
        if isfield(options, 'fudge_factor') && ~isempty(options.fudge_factor)
            g_fb = f_cs_apply_fudge(g, options.fudge_factor);
        end
        [c, sp] = local_oasis_deconv(y, g_fb, sn);
    catch ME2
        % Last-resort passthrough: no deconvolution. Lets the merge
        % complete with raw signal as C and zero spikes.
        warning('caiman_sorter:oasis_fallback', ...
            'OASIS fallback also failed; returning passthrough. Reason: %s', ...
            strrep(ME2.message, '%', '%%'));
        c = y(:);
        sp = zeros(numel(y), 1);
    end
end

end


function [c, sp] = local_oasis_deconv(y, g, sn)
% Run an OASIS deconvolution suitable for the AR order of g, returning
% (c, sp) shaped like the constrained_foopsi result.
%
% AR1: constrained_oasisAR1 with optimize_b=true works — scalar g, nested
%   funcs' g^N math is safe.
% AR2: vendored constrained_oasisAR2 is broken (nested update_phi /
%   update_lam_b assume scalar g via g^N). Approximate the noise-
%   constrained formulation manually:
%     1) coarse baseline = quantile(y, 0.15) (matches what
%        constrained_oasisAR2's optimize_b path initializes b to)
%     2) pick lambda via choose_lambda(g, sn) — sets lam so noise alone
%        has ~1% chance of producing a false spike (Selesnick 2012)
%     3) run foopsi_oasisAR2 with that lam (proper AR2 OASIS via the
%        inner oasisAR2 solver)
g = g(:);
y_col = y(:);
if numel(g) == 1
    [c, sp] = constrained_oasisAR1(y_col, g, sn, true, 0, [], []);
else
    b = quantile(y_col, 0.15);
    lam = choose_lambda(g', sn);
    [c, sp] = foopsi_oasisAR2(y_col - b, g, lam, false, 0, [], []);
    c = c + b;
end
c = c(:);
sp = sp(:);
end