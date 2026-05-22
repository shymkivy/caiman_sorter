function method = f_cs_pick_foopsi_method()
% Pick a deconvolution method that won't error based on what's currently
% on the MATLAB path. Order of preference:
%   'cvx'   — requires CVX (cvxr.com)               — best quality
%   'dual'  — requires Optimization Toolbox fmincon — built-in fallback
%   'oasis' — uses vendored constrained_oasisAR1/2  — no external deps
%
% The last option is NOT a constrained_foopsi method string; callers
% (f_cs_compute_constrained_foopsi_core) detect it and route to OASIS
% directly via constrained_oasisAR1/AR2.

if ~isempty(which('cvx_begin'))
    method = 'cvx';
elseif exist('fmincon', 'file') == 2
    method = 'dual';
else
    method = 'oasis';
end

end
