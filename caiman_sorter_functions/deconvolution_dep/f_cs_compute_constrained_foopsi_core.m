function [c, sp] = f_cs_compute_constrained_foopsi_core(y, g, sn, options)

[cc, b, c1, ~, ~, sp] = constrained_foopsi(y,[],[],g, sn, options);

gd = max(roots([1,-g]));  % decay time constant for initial concentration
gd_vec = gd.^((0:length(y)-1));
c = cc(:) + c1*gd_vec' + b;

end