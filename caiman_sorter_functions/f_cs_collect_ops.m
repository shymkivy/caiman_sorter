function ops = f_cs_collect_ops(app)
ops = app.ops;
% evaluate components params
ops.SwitchCaimanEvaluate = app.SwitchCaimanEvaluate.Value;
%caiman method
eval_params_caiman.SNR_thresh =         app.SNRthreshSpinner.Value;
eval_params_caiman.SNR_lowest_thresh =  app.SNRLowestthreshSpinner.Value;
eval_params_caiman.cnn_thresh =         app.CNNprobthreshSpinner.Value;
eval_params_caiman.cnn_lowest_thresh =  app.CNNLowestthreshSpinner.Value;
eval_params_caiman.rval_thresh =        app.RvalthreshSpinner.Value;
eval_params_caiman.rval_lowest_thresh = app.RvalLowestthreshSpinner.Value;

% other method
eval_params2.RejThrSNRCaiman =          app.EditFieldSNRcaiman.Value;
eval_params2.RejThrSNR2 =               app.EditFieldSNR2.Value;
eval_params2.RejThrCNN =                app.EditFieldCNN.Value;
eval_params2.RejThrRvalues =            app.EditFieldRvalues.Value;
eval_params2.RejThrRvalues =            app.EditFieldMinSigFrac.Value;
eval_params2.FiringStability =          app.EditFieldFiringStability.Value;
eval_params2.EvalSNRcaiman =            app.CheckBoxSNRcaiman.Value;
eval_params2.EvalSNR2 =                 app.CheckBoxSNR2.Value;
eval_params2.EvalCNN =                  app.CheckBoxCNN.Value;
eval_params2.EvalRvalues =              app.CheckBoxRvalues.Value;
eval_params2.EvalMinSigFrac =           app.CheckBoxMinSigFrac.Value;

%% deconvolution params
% smooth df/dt
deconv.smooth_dfdt.params.convolve_gaus =       app.ConvolvewithgaussiankernelCheckBoxSmoothdfdt.Value;
deconv.smooth_dfdt.params.gauss_kernel_simga =  app.GaussKernelSimgaSmoothdfdt.Value;
deconv.smooth_dfdt.params.rectify =             app.RectifyCheckBox.Value;
deconv.smooth_dfdt.params.normalize =           app.NormalizeCheckBox.Value;
deconv.smooth_dfdt.params.apply_thresh =        app.ApplythresholdCheckBox.Value;
deconv.smooth_dfdt.params.threshold =           app.ThresholdmagZEditField.Value;
deconv.smooth_dfdt.gui.scale_value =            app.ScaleEditField.Value;
deconv.smooth_dfdt.gui.shift_value =            app.ShiftEditField.Value;
deconv.smooth_dfdt.gui.plot_threshold =         app.PlotthresholdCheckBox.Value;


% constrained foopsi
if isobject(app.ARmodelSwitchCfoopsi)
    deconv.c_foopsi.params.AR_val =             app.ARmodelSwitchCfoopsi.Value;
    deconv.c_foopsi.params.manual_tau =         app.UsemanualtimeconstantsCheckBoxCfoopsi.Value;
    deconv.c_foopsi.params.manual_tau_rise =    app.TauriseEditFieldCfoopsi.Value;
    deconv.c_foopsi.params.manual_tau_decay =   app.TaudecayEditFieldCfoopsi.Value;
    deconv.c_foopsi.params.convolve_gaus =      app.ConvolvewithgaussiankernelCheckBoxCfoopsi.Value;
    deconv.c_foopsi.params.gauss_kernel_simga =	app.GaussKernelSimgaCfoopsi.Value;
    deconv.c_foopsi.gui.scale_value =           app.ScaleEditFieldCfoopsi.Value;
    deconv.c_foopsi.gui.shift_value =           app.ShiftEditFieldCfoopsi.Value;
end

% mcmc
if isobject(app.ARmodelSwitchMCMC)
    deconv.MCMC.params.AR_val =                 app.ARmodelSwitchMCMC.Value;
    deconv.MCMC.params.B_param =                app.MCMCBurnInSamples.Value;
    deconv.MCMC.params.Nsamples_param =         app.MCMCNNumberOfSamples.Value;
    deconv.MCMC.params.manual_tau =             app.UsemanualtimeconstantsCheckBoxMCMC.Value;
    deconv.MCMC.params.manual_tau_rise =        app.TauriseEditFieldMCMC.Value;
    deconv.MCMC.params.manual_tau_decay =       app.TaudecayEditFieldMCMC.Value;
    deconv.MCMC.params.convolve_gaus =          app.ConvolvewithgaussiankernelCheckBoxMCMC.Value;
    deconv.MCMC.params.gauss_kernel_simga =     app.GaussKernelSimgaMCMC.Value;
    deconv.MCMC.gui.scale_value =               app.ScaleEditFieldMCMC.Value;
    deconv.MCMC.gui.shift_value =               app.ShiftEditFieldMCMC.Value;
    deconv.MCMC.params.save_SAMP =              app.SaveSamplesOutputsMCMC.Value;
end
    
%%
ops.eval_params_caiman = eval_params_caiman;
ops.eval_params2 = eval_params2;
ops.deconv = deconv;
end