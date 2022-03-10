function f_cs_compute_MCMC(app, n_cell)

y = double(app.est.C(n_cell,:) + app.est.YrA(n_cell,:));

params.p = str2double(app.ARmodelSwitchMCMC.Value);
params.f = double(app.ops.init_params_caiman.data.fr);
params.Nsamples = app.MCMCNNumberOfSamples.Value;
params.B = app.MCMCBurnInSamples.Value;
params.sn = app.proc.noise(n_cell);

dt = 1/double(app.ops.init_params_caiman.data.fr);

if params.p == 1
    if app.UsemanualtimeconstantsCheckBoxMCMC.Value
        params.g = tau_c2d(Inf, app.TaudecayEditFieldMCMC.Value, dt);
    else
        params.g = app.proc.gAR1(n_cell);
    end
elseif params.p == 2
    if app.UsemanualtimeconstantsCheckBoxMCMC.Value
        params.g = tau_c2d(app.TauriseEditFieldMCMC.Value, app.TaudecayEditFieldMCMC.Value, dt);
    else
        params.g = app.proc.gAR2(n_cell,:);
    end
end

SAMP = f_cs_compute_MCMC_core(y, params);

if app.SaveSamplesOutputsMCMC.Value
    app.proc.deconv.MCMC.SAMP{n_cell} = SAMP;
end

if SAMP.process_ok
    % need to fill in the zeros here for unprocessed signal
    app.proc.deconv.MCMC.C{n_cell} = [zeros(1,sig_start-1), mean(SAMP.C_rec,1)];
    app.proc.deconv.MCMC.S{n_cell} = mean(spikeRaster,1);
end
%     figure; imagesc(spikeRaster)
%     figure; hold on;
%     plot(y)
%     plot(app.proc.deconv.MCMC.C{n_cell})
%     plot(app.proc.deconv.MCMC.S{n_cell}*1000)

end