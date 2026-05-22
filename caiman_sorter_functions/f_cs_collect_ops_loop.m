function ops = f_cs_collect_ops_loop(ops)
% evaluate components params
ops.SwitchCaimanEvaluate = 'Reject threshhold';
%caiman method
eval_params_caiman.SNR_thresh =         2;
eval_params_caiman.SNR_lowest_thresh =  0.5;
eval_params_caiman.cnn_thresh =         0.99;
eval_params_caiman.cnn_lowest_thresh =  0.1;
eval_params_caiman.rval_thresh =        0.9;
eval_params_caiman.rval_lowest_thresh = -1;

% other method
eval_params2.RejThrSNRCaiman =          2;
eval_params2.RejThrSNR2 =               3;
eval_params2.RejThrCNN =                0.5;
eval_params2.RejThrRvalues =            0.5;
eval_params2.RejThrMinSigFrac =         0.5;
eval_params2.FiringStability =          0.01;
eval_params2.RejThrSkewness =           0;

eval_params2.EvalSNRcaiman =            0;
eval_params2.EvalSNR2 =                 1;
eval_params2.EvalCNN =                  1;
eval_params2.EvalRvalues =              0;
eval_params2.EvalMinSigFrac =           1;
eval_params2.EvalFiringStability =      0;
eval_params2.EvalSkewness =             0;

%% deconvolution params
% smooth df/dt
deconv.smooth_dfdt.params.convolve_gaus =       1;
deconv.smooth_dfdt.params.gauss_kernel_simga =  100;
deconv.smooth_dfdt.params.rectify =             1;
deconv.smooth_dfdt.params.normalize =           0;
deconv.smooth_dfdt.params.apply_thresh =        0;
deconv.smooth_dfdt.params.threshold =           2;
deconv.smooth_dfdt.gui.scale_value =            1;
deconv.smooth_dfdt.gui.shift_value =            0;
deconv.smooth_dfdt.gui.plot_threshold =         1;

% constrained foopsi — mirror of f_cs_collect_ops.m so loop/batch users
% get the same defaults the interactive GUI writes.
deconv.c_foopsi.params.AR_val =             '2';
deconv.c_foopsi.params.manual_tau =         0;
deconv.c_foopsi.params.manual_tau_rise =    0.01;
deconv.c_foopsi.params.manual_tau_decay =   1;
deconv.c_foopsi.params.convolve_gaus =      0;
deconv.c_foopsi.params.gauss_kernel_simga = 100;
deconv.c_foopsi.params.fudge_factor =       0.99;
deconv.c_foopsi.params.method =             'oasis';  % solver selection (always available default)
deconv.c_foopsi.gui.scale_value =           1;
deconv.c_foopsi.gui.shift_value =           0;

% mcmc
deconv.MCMC.params.AR_val =                 '2';
deconv.MCMC.params.B_param =                200;
deconv.MCMC.params.Nsamples_param =         500;
deconv.MCMC.params.manual_tau =             0;
deconv.MCMC.params.manual_tau_rise =        0.01;
deconv.MCMC.params.manual_tau_decay =       1;
deconv.MCMC.params.convolve_gaus =          0;
deconv.MCMC.params.gauss_kernel_simga =     100;
deconv.MCMC.gui.scale_value =               3;
deconv.MCMC.gui.shift_value =               -4;
deconv.MCMC.params.save_SAMP =              0;

    
% merge parameters (loop/batch defaults — match f_cs_collect_ops shape)
merge.apply =              false;
merge.method =             'choose better';
merge.spatial_thr =        0.3;
merge.temporal_thr =       0.5;
merge.use_accepted_only =  true;

% UI/UX defaults — only used if a loop-saved ops file gets opened by the
% interactive GUI, in which case these put the widgets in a sane starting
% state. Switch widgets expect 'On'/'Off' strings.
ui.manual_edits_on =          'On';
ui.overwrite_deconv =         false;
ui.press_arrow_to_change =    false;
ui.smooth_raw_on =            false;
ui.smooth_raw_window =        5;
ui.plot_last_c =              'Off';
ui.plot_c =                   'On';
ui.plot_raw =                 'On';
ui.plot_spikes =              'Off';
ui.plot_smooth_dfof =         'Off';
ui.plot_const_foopsi =        'Off';
ui.plot_mcmc =                'Off';
ui.contour_metric =           'None';
ui.bkg_plot_mode =            'Components';
ui.autosave_ops =             true;

%%
ops.eval_params_caiman = eval_params_caiman;
ops.eval_params2 = eval_params2;
ops.deconv = deconv;
ops.merge = merge;
ops.ui = ui;
end