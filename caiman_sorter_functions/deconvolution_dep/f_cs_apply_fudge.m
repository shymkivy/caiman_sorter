function g_adj = f_cs_apply_fudge(g, fudge)
% Shrink AR poles by `fudge` (typically <1) to compensate for the bias in
% estimated time constants. Mirrors CaImAn's fudge_factor / `estimate_time
% _constant.m`. Works for AR(1) (scalar g) and AR(2) (2-vector g).
%
% Derivation:
%   AR(p) characteristic polynomial: z^p - g(1)*z^(p-1) - ... - g(p) = 0
%   Roots = poles of the discrete-time impulse response.
%   New roots = roots * fudge   (each pole moved closer to origin →
%   faster decay → counters the typical overestimation bias).
%   Recompose g from adjusted roots via Vieta's formulas.

if isempty(fudge) || fudge == 1 || isempty(g)
    g_adj = g;
    return;
end

g_col = g(:);
if numel(g_col) == 1
    g_adj = g_col * fudge;
else
    % AR(2): z^2 - g1*z - g2 = 0  →  r1*r2 = -g2,  r1+r2 = g1
    r = roots([1; -g_col]);
    r = r * fudge;
    g_adj = [sum(r); -prod(r)];
    g_adj = real(g_adj);   % drop tiny imag residue if roots are complex
end

% Return in the same shape as the input.
if isrow(g)
    g_adj = g_adj.';
end

end
