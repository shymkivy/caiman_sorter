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

eval_params2.EvalSNRcaiman =            0;
eval_params2.EvalSNR2 =                 1;
eval_params2.EvalCNN =                  1;
eval_params2.EvalRvalues =              0;
eval_params2.EvalMinSigFrac =           1;
eval_params2.EvalFiringStability =      0;

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

    
%%
ops.eval_params_caiman = eval_params_caiman;
ops.eval_params2 = eval_params2;
ops.deconv = deconv;
end