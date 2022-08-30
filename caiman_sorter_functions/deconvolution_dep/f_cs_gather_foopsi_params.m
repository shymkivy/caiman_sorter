function [options, sn, g] = f_cs_gather_foopsi_params(app, n_cell)

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

options.fudge_factor = app.FudgeFactorEditField.Value;
options.p = p;
%options.method = 'dual';

end