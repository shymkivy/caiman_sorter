function [c, sp] = f_cs_compute_constrained_foopsi(app, n_cell)

y = double(app.est.C(n_cell,:) + app.est.YrA(n_cell,:));

[options, sn, g] = f_cs_gather_foopsi_params(app, n_cell);

[c, sp] = f_cs_compute_constrained_foopsi_core(y, g, sn, options);

app.proc.deconv.c_foopsi.S{n_cell} = sp';
app.proc.deconv.c_foopsi.C{n_cell} = c';
app.proc.deconv.c_foopsi.p{n_cell} = options.p;
app.proc.deconv.c_foopsi.g{n_cell} = g;

end