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

y_nonzero = find(y~=0);
sig_start = y_nonzero(1);

spikeRaster = zeros(500, app.proc.num_frames);

try
    SAMP = cont_ca_sampler(y(sig_start:end),params);
    SAMP.C_rec = extract_C_YS(SAMP,y(sig_start:end));
    
    for rep = 1:500
        temp = ceil(SAMP.ss{rep})+sig_start-1;
        spikeRaster(rep,temp) = 1;
    end
    
catch
    warning(['Cell ' num2str(n_cell) ' error in MCMC, splitting in 2'])
    second_start = floor((numel(y)-sig_start)/2)+sig_start;
    samp1 = cont_ca_sampler(y(sig_start:second_start),params);
    samp1.C_rec = extract_C_YS(samp1,y(sig_start:second_start));
    samp2 = cont_ca_sampler(y((second_start+1):end),params);
    samp2.C_rec = extract_C_YS(samp2,y((second_start+1):end));
     
    for rep = 1:500
        temp1 = ceil(samp1.ss{rep})+sig_start-1;
        temp2 = ceil(samp2.ss{rep})+second_start;
        spikeRaster(rep,temp1) = 1;
        spikeRaster(rep,temp2) = 1;
    end
    
    SAMP.samp1 = samp1;
    SAMP.samp2 = samp2;
    SAMP.C_rec = [mean(samp1.C_rec,1), mean(samp2.C_rec,1)];
    SAMP.error  = 'data needed to be split in 2 for MCMC';
    SAMP.second_start = second_start;
end

SAMP.sig_start = sig_start;

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