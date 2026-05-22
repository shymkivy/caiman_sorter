function f_cs_write_ops(app)

ops = app.ops;

if isfield(ops, 'SwitchCaimanEvaluate')
    try
        % The toggle dropdown only accepts the two exact strings 'Caiman evaluate'
        % or 'Reject threshhold' — anything else throws. Normalize case-/spell-
        % variations from other tools (e.g. Python sorter's 'CaImAn evaluate')
        % to the canonical value before assigning.
        v = lower(ops.SwitchCaimanEvaluate);
        if contains(v, 'caiman')
            app.SwitchCaimanEvaluate.Value = 'Caiman evaluate';
        elseif contains(v, 'reject') || contains(v, 'thresh')
            app.SwitchCaimanEvaluate.Value = 'Reject threshhold';
        else
            app.SwitchCaimanEvaluate.Value = ops.SwitchCaimanEvaluate; % let it error
        end
        f_cs_FlipSwitchCaimanLight(app);
    catch ME
        f_cs_update_log(app, ['Unable to set SwitchCaimanEvaluate: ' ME.message]);
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
    catch ME
        f_cs_update_log(app, ['Unable to write eval_params_caiman ops: ' ME.message]);
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
        app.EditFieldMinSigFrac.Value =         eval_params2.RejThrMinSigFrac;
        app.EditFieldFiringStability.Value =    eval_params2.FiringStability;
        app.CheckBoxSNRcaiman.Value =           eval_params2.EvalSNRcaiman;
        app.CheckBoxSNR2.Value =                eval_params2.EvalSNR2;
        app.CheckBoxCNN.Value =                 eval_params2.EvalCNN;
        app.CheckBoxRvalues.Value =             eval_params2.EvalRvalues;
        app.CheckBoxMinSigFrac.Value =          eval_params2.EvalMinSigFrac;
        app.CheckBoxFiringStability.Value =     eval_params2.EvalFiringStability;
        % Skewness round-trip: collect_ops writes RejThrSkewness/EvalSkewness
        % but earlier versions of this file didn't read them back, so a save
        % → close → reopen lost the skewness threshold + checkbox.
        if isfield(eval_params2, 'RejThrSkewness')
            app.EditFieldSkewness.Value =       eval_params2.RejThrSkewness;
        end
        if isfield(eval_params2, 'EvalSkewness')
            app.CheckBoxSkewness.Value =        eval_params2.EvalSkewness;
        end
    catch ME
        f_cs_update_log(app, ['Unable to write eval_params2 ops: ' ME.message]);
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
    catch ME
        f_cs_update_log(app, ['Unable to write init_params_caiman ops: ' ME.message]);
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
        catch ME
            f_cs_update_log(app, ['Unable to write smooth_dfdt ops: ' ME.message]);
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
                % Fudge factor — shared across c_foopsi / OASIS / merge.
                % Guarded for backward-compat with old ops files that didn't save it.
                if isfield(deconv.c_foopsi.params, 'fudge_factor')
                    app.FudgeFactorEditField.Value = deconv.c_foopsi.params.fudge_factor;
                end
                % Solver-selection dropdown (may be absent on older .mlapp).
                % Guard inside isfield so loading an old ops file is harmless.
                if isfield(deconv.c_foopsi.params, 'method') ...
                        && isprop(app, 'DeconvMethodDropDownCfoopsi') ...
                        && isobject(app.DeconvMethodDropDownCfoopsi)
                    app.DeconvMethodDropDownCfoopsi.Value = deconv.c_foopsi.params.method;
                end
            catch ME
                f_cs_update_log(app, ['Unable to write c_foopsi ops: ' ME.message]);
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
            catch ME
                f_cs_update_log(app, ['Unable to write MCMC ops: ' ME.message]);
            end
        end
    end
end

% Pre-populate the load-data path field with the last successfully-loaded
% file (if it still exists on disk), so users see / can re-load it with
% one click. Quiet no-op when the field or path is missing.
if isfield(ops, 'last_file') && ~isempty(ops.last_file) ...
        && exist(ops.last_file, 'file') ...
        && isprop(app, 'LoadDataEditField') && isobject(app.LoadDataEditField)
    app.LoadDataEditField.Value = ops.last_file;
    app.file_loc = ops.last_file;
end

% merge parameters (used by find_similar_comp tab)
if isfield(ops, 'merge')
    try
        m = ops.merge;
        if isfield(m, 'apply');             app.MergesimilarcompCheckBox.Value =    m.apply;             end
        if isfield(m, 'method');            app.MergemethodDropDown.Value =         m.method;            end
        if isfield(m, 'spatial_thr');       app.spatialcorrthershEditField.Value =  m.spatial_thr;       end
        if isfield(m, 'temporal_thr');      app.tempcorrtheshEditField.Value =      m.temporal_thr;      end
        if isfield(m, 'use_accepted_only'); app.UseacceptedcellsCheckBox.Value =    m.use_accepted_only; end
    catch ME
        f_cs_update_log(app, ['Unable to write merge ops: ' ME.message]);
    end
end

% UI / UX state (view toggles and workflow flags). Each field guarded — old
% ops files without these sections still load cleanly; widgets stay at
% whatever the .mlapp default was.
if isfield(ops, 'ui')
    try
        u = ops.ui;
        if isfield(u, 'manual_edits_on');       app.ManualEditsSwitch.Value =                u.manual_edits_on;       end
        if isfield(u, 'overwrite_deconv');      app.OverwriteCheckBox.Value =                u.overwrite_deconv;      end
        if isfield(u, 'press_arrow_to_change'); app.PressupdownkeytochangecellnumButton.Value = u.press_arrow_to_change; end
        if isfield(u, 'smooth_raw_on');         app.SmoothRawButton.Value =                  u.smooth_raw_on;         end
        if isfield(u, 'smooth_raw_window');     app.SmoothRawWindowSpinner.Value =           u.smooth_raw_window;     end
        if isfield(u, 'plot_last_c');           app.PlotLastCSwitch.Value =                  u.plot_last_c;           end
        if isfield(u, 'plot_c');                app.PlotCSwitch.Value =                      u.plot_c;                end
        if isfield(u, 'plot_raw');              app.PlotRawSwitch.Value =                    u.plot_raw;              end
        if isfield(u, 'plot_spikes');           app.PlotSpikesSwitch.Value =                 u.plot_spikes;           end
        if isfield(u, 'plot_smooth_dfof');      app.PlotsmoothdfofSwitch.Value =             u.plot_smooth_dfof;      end
        if isfield(u, 'plot_const_foopsi') && isobject(app.PlotconstfoopsiSwitch)
            app.PlotconstfoopsiSwitch.Value = u.plot_const_foopsi;
        end
        if isfield(u, 'plot_mcmc') && isobject(app.PlotMCMCSwitch)
            app.PlotMCMCSwitch.Value = u.plot_mcmc;
        end
        % ButtonGroups: find the radio whose .Text matches and select it.
        if isfield(u, 'contour_metric') && isobject(app.PlotContoursButtonGroup)
            local_select_radio(app.PlotContoursButtonGroup, u.contour_metric);
        end
        if isfield(u, 'bkg_plot_mode') && isobject(app.BackgroundplotButtonGroup)
            local_select_radio(app.BackgroundplotButtonGroup, u.bkg_plot_mode);
        end
        if isfield(u, 'autosave_ops') ...
                && isprop(app, 'AutoSaveOpsCheckBox') ...
                && isobject(app.AutoSaveOpsCheckBox)
            app.AutoSaveOpsCheckBox.Value = u.autosave_ops;
        end
    catch ME
        f_cs_update_log(app, ['Unable to write ui ops: ' ME.message]);
    end
end

end


function local_select_radio(grp, target_text)
% Set a uibuttongroup's SelectedObject to whichever button matches target_text.
% Silently does nothing if the group is empty or no button matches — that
% way an old ops file referencing a renamed/removed radio just leaves the
% group at its existing selection rather than erroring out.
if isempty(grp) || isempty(grp.Buttons)
    return;
end
for k = 1:numel(grp.Buttons)
    if strcmpi(grp.Buttons(k).Text, target_text)
        grp.SelectedObject = grp.Buttons(k);
        return;
    end
end
end