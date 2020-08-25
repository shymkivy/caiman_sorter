function f_cs_write_ops(app)

ops = app.ops;

if isfield(ops, 'SwitchCaimanEvaluate')
    try
        app.SwitchCaimanEvaluate.Value = ops.SwitchCaimanEvaluate;
        f_cs_FlipSwitchCaimanLight(app);
    catch
        f_cs_update_log(app, 'Unable to set SwitchCaimanEvaluate');
    end
end

%caiman method
if isfield(ops, 'eval_params_caiman')
    try
        eval_params_caiman = ops.eval_params_caiman;
        app.SNRthreshSpinner.Value =            eval_params_caiman.SNR_thresh;
        app.SNRLowestthreshSpinner.Value =      eval_params_caiman.SNR_lowest_thresh;
        app.CNNprobthreshSpinner.Value =        eval_params_caiman.cnn_thresh;
        app.CNNLowestthreshSpinner.Value =      eval_params_caiman.cnn_lowest_thresh;
        app.RvalthreshSpinner.Value =           eval_params_caiman.rval_thresh;
        app.RvalLowestthreshSpinner.Value =     eval_params_caiman.rval_lowest_thresh;
    catch
        f_cs_update_log(app, 'Unable to write eval_params_caiman ops');
    end
end

% other method
if isfield(ops, 'eval_params2')
    try
        eval_params2 = ops.eval_params2;
        app.EditFieldSNRcaiman.Value =          eval_params2.RejThrSNRCaiman;
        app.EditFieldSNR2.Value =               eval_params2.RejThrSNR2;
        app.EditFieldCNN.Value =                eval_params2.RejThrCNN;
        app.EditFieldRvalues.Value =            eval_params2.RejThrRvalues;
        app.EditFieldMinSigFrac.Value =         eval_params2.RejThrRvalues;
        app.EditFieldFiringStability.Value =    eval_params2.FiringStability;
        app.CheckBoxSNRcaiman.Value =           eval_params2.EvalSNRcaiman;
        app.CheckBoxSNR2.Value =                eval_params2.EvalSNR2;
        app.CheckBoxCNN.Value =                 eval_params2.EvalCNN;
        app.CheckBoxRvalues.Value =             eval_params2.EvalRvalues;
        app.CheckBoxMinSigFrac.Value =          eval_params2.EvalMinSigFrac;
    catch
        f_cs_update_log(app, 'Unable to write eval_params2 ops');
    end
end

% set inital params values;
if isfield(ops, 'init_params_caiman')
    try
        init_params_caiman = ops.init_params_caiman;
        app.DimsEditField.Value = ['[' num2str(init_params_caiman.data.dims(1)) ',' num2str(init_params_caiman.data.dims(2)) ']'];
        app.DecayTimeEditField.Value = double(init_params_caiman.data.decay_time);
        app.FrameRateEditField.Value = double(init_params_caiman.data.fr);
        app.gSigEditField.Value = ['[' num2str(init_params_caiman.init.gSig(1)) ',' num2str(init_params_caiman.init.gSig(2)) ']'];
        app.EpochsEditField.Value = double(init_params_caiman.online.epochs);
        app.pARmodelEditField.Value = double(init_params_caiman.preprocess.p);
        app.ds_factorEditField.Value = double(init_params_caiman.online.ds_factor);
    catch
        f_cs_update_log(app, 'Unable to write init_params_caiman ops');
    end
end

% set deconv params
if isfield(ops, 'deconv')
    deconv = ops.deconv;
    if isfield(ops.deconv, 'smooth_dfdt')
        try
            app.ConvolvewithgaussiankernelCheckBoxSmoothdfdt.Value =    deconv.smooth_dfdt.params.convolve_gaus;
            app.GaussKernelSimgaSmoothdfdt.Value =                      deconv.smooth_dfdt.params.gauss_kernel_simga;
            app.RectifyCheckBox.Value =                                 deconv.smooth_dfdt.params.rectify;
            app.NormalizeCheckBox.Value =                               deconv.smooth_dfdt.params.normalize;
            app.ApplythresholdCheckBox.Value =                          deconv.smooth_dfdt.params.apply_thresh;
            app.ThresholdmagZEditField.Value =                          deconv.smooth_dfdt.params.threshold;
            app.ScaleEditField.Value =                                  deconv.smooth_dfdt.gui.scale_value;
            app.ShiftEditField.Value =                                  deconv.smooth_dfdt.gui.shift_value;
            app.PlotthresholdCheckBox.Value =                           deconv.smooth_dfdt.gui.plot_threshold;
        catch
            f_cs_update_log(app, 'Unable to write smooth_dfdt ops');
        end
    end
    if isobject(app.ARmodelSwitchCfoopsi)
        if isfield(ops.deconv, 'c_foopsi')
            try
                app.ARmodelSwitchCfoopsi.Value =                        deconv.c_foopsi.params.AR_val;
                app.UsemanualtimeconstantsCheckBoxCfoopsi.Value =       deconv.c_foopsi.params.manual_tau;
                app.TauriseEditFieldCfoopsi.Value =                     deconv.c_foopsi.params.manual_tau_rise;
                app.TaudecayEditFieldCfoopsi.Value =                    deconv.c_foopsi.params.manual_tau_decay;
                app.ConvolvewithgaussiankernelCheckBoxCfoopsi.Value =   deconv.c_foopsi.params.convolve_gaus;
                app.GaussKernelSimgaCfoopsi.Value =                     deconv.c_foopsi.params.gauss_kernel_simga;
                app.ScaleEditFieldCfoopsi.Value =                       deconv.c_foopsi.gui.scale_value;
                app.ShiftEditFieldCfoopsi.Value =                       deconv.c_foopsi.gui.shift_value;
            catch
                f_cs_update_log(app, 'Unable to write c_foopsi ops');
            end
        end
    end
    if isobject(app.PlotMCMCSwitch)
        if isfield(ops.deconv, 'MCMC')
            try
                app.ARmodelSwitchMCMC.Value =                           deconv.MCMC.params.AR_val;
                app.MCMCBurnInSamples.Value =                           deconv.MCMC.params.B_param;
                app.MCMCNNumberOfSamples.Value =                        deconv.MCMC.params.Nsamples_param;
                app.UsemanualtimeconstantsCheckBoxMCMC.Value =          deconv.MCMC.params.manual_tau;
                app.TauriseEditFieldMCMC.Value =                        deconv.MCMC.params.manual_tau_rise;
                app.TaudecayEditFieldMCMC.Value =                       deconv.MCMC.params.manual_tau_decay;
                app.ConvolvewithgaussiankernelCheckBoxMCMC.Value =      deconv.MCMC.params.convolve_gaus;
                app.GaussKernelSimgaMCMC.Value =                        deconv.MCMC.params.gauss_kernel_simga;
                app.ScaleEditFieldMCMC.Value =                          deconv.MCMC.gui.scale_value;
                app.ShiftEditFieldMCMC.Value =                          deconv.MCMC.gui.shift_value;
                app.SaveSamplesOutputsMCMC.Value =                      deconv.MCMC.params.save_SAMP;
            catch
                f_cs_update_log(app, 'Unable to write MCMC ops');
            end
        end
    end
end

    
end