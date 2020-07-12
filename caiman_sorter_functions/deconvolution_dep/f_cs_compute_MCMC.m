function f_cs_compute_MCMC(app, n_cell)

y = double(app.est.C(n_cell,:) + app.est.YrA(n_cell,:));

params.p = str2double(app.ARmodelSwitchMCMC.Value);
params.f = double(app.ops.init_params_caiman.data.fr);
params.Nsamples = app.MCMCNNumberOfSamples.Value;
params.B = app.MCMCBurnInSamples.Value;
params.sn = app.proc.noise(n_cell);


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

SAMP = cont_ca_sampler(y,params);
SAMP.C_rec = extract_C_YS(SAMP,y);

spikeRaster = zeros(500, app.proc.num_frames);
for rep = 1:500
    temp = ceil(SAMP.ss{rep});
    spikeRaster(rep,temp) = 1;
end

if app.SaveSamplesOutputsMCMC.Value
    app.proc.deconv.MCMC.SAMP{n_cell} = SAMP;
end
app.proc.deconv.MCMC.C{n_cell} = mean(SAMP.C_rec,1);
app.proc.deconv.MCMC.S{n_cell} = mean(spikeRaster,1);

%     figure; imagesc(spikeRaster)
%     figure; hold on;
%     plot(y)
%     plot(app.proc.deconv.MCMC.C{n_cell})
%     plot(app.proc.deconv.MCMC.S{n_cell}*1000)

end