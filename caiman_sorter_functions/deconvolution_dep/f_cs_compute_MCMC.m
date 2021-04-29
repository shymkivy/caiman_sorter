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

num_samples = app.MCMCNNumberOfSamples.Value;

% for some reason it breaks when Y is zeros, so remove that part
y_nonzero = find(y~=0);
sig_start = y_nonzero(1);

spikeRaster = zeros(num_samples, app.proc.num_frames);

process_ok = 0;
try
    SAMP = cont_ca_sampler(y(sig_start:end),params);
    % need to reconstructing cropped signal, cuz there is Cin parameter for initial c
    SAMP.C_rec = extract_C_YS(SAMP,y(sig_start:end)); % 
    
    for rep = 1:num_samples
        temp = ceil(SAMP.ss{rep}) + sig_start - 1;
        spikeRaster(rep,temp) = 1;
    end
    process_ok = 1;
catch
    try
        warning(['Cell ' num2str(n_cell) ' error in MCMC, try splitting into 2 if too large'])
        second_start = floor((numel(y)-sig_start)/2)+sig_start;
        samp1 = cont_ca_sampler(y(sig_start:second_start),params);
        samp2 = cont_ca_sampler(y((second_start+1):end),params);

        samp1.C_rec = extract_C_YS(samp1,y(sig_start:second_start));
        samp2.C_rec = extract_C_YS(samp2,y((second_start+1):end));

        for rep = 1:app.MCMCNNumberOfSamples.Value
            temp1 = ceil(samp1.ss{rep})+sig_start-1;
            temp2 = ceil(samp2.ss{rep})+second_start;
            spikeRaster(rep,temp1) = 1;
            spikeRaster(rep,temp2) = 1;
        end

        SAMP.samp1 = samp1;
        SAMP.samp2 = samp2;
        SAMP.C_rec = [samp1.C_rec, samp2.C_rec];
        SAMP.error  = 'data needed to be split in 2 for MCMC';
        SAMP.second_start = second_start;
        process_ok = 1;
    catch
        warning(['Cell ' num2str(n_cell) ' error in MCMC, unable to process, skipping cell'])
        SAMP.error = 'MCMC failed';
    end
end

SAMP.sig_start = sig_start;

if app.SaveSamplesOutputsMCMC.Value
    app.proc.deconv.MCMC.SAMP{n_cell} = SAMP;
end

if process_ok
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