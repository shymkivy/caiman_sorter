function [c, sp] = f_cs_compute_constrained_foopsi(app, n_cell)

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
%options.method = 'dual';

[cc, b, c1, ~, ~, sp] = constrained_foopsi(y,[],[],g, sn, options);

gd = max(roots([1,-g]));  % decay time constant for initial concentration
gd_vec = gd.^((0:length(y)-1));
c = cc(:) + c1*gd_vec' + b;

app.proc.deconv.c_foopsi.S{n_cell} = sp';
app.proc.deconv.c_foopsi.C{n_cell} = c';
app.proc.deconv.c_foopsi.p{n_cell} = p;
app.proc.deconv.c_foopsi.g{n_cell} = g;

end