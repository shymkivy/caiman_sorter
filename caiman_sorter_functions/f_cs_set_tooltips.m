function f_cs_set_tooltips(app)
% Set tooltips on user-facing widgets. Called once from f_cs_startup.m so
% the user doesn't have to set them in App Designer. Each widget is
% guarded with isprop so missing/renamed widgets silently skip.

%% ---- Load / save ----
set_tt('LoadDataEditField', ...
    'Path to the input file. Accepts CaImAn output (.hdf5/.h5) or a previously saved sort (.mat).');
set_tt('AutoSaveOpsCheckBox', ...
    'When on, GUI settings are auto-saved to a per-user options file at app close and at key actions. Off = only saved manually.');

%% ---- Cell selection / navigation ----
set_tt('CellnumberSpinner', ...
    'Currently selected cell index.');
set_tt('PressupdownkeytochangecellnumButton', ...
    'When on, the up/down arrow keys step through cells in the current category.');
set_tt('ManualEditsSwitch', ...
    'When On, manual accept/reject toggles are applied on top of the automatic evaluation. When Off, only the automatic eval result is shown.');

%% ---- CaImAn-evaluate thresholds ----
set_tt('SwitchCaimanEvaluate', ...
    'Choose evaluation method: ''Caiman evaluate'' (accept if any metric exceeds its high threshold, then reject if any falls below its low threshold) or ''Reject threshhold'' (start with all accepted, apply enabled cutoffs).');
set_tt('SNRthreshSpinner', ...
    'Accept cells whose CaImAn SNR meets or exceeds this value.');
set_tt('SNRLowestthreshSpinner', ...
    'Reject cells whose CaImAn SNR falls below this value (overrides accept).');
set_tt('CNNprobthreshSpinner', ...
    'Accept cells whose CNN classifier probability meets or exceeds this value.');
set_tt('CNNLowestthreshSpinner', ...
    'Reject cells whose CNN classifier probability falls below this value (overrides accept).');
set_tt('RvalthreshSpinner', ...
    'Accept cells whose spatial r-value meets or exceeds this value.');
set_tt('RvalLowestthreshSpinner', ...
    'Reject cells whose spatial r-value falls below this value (overrides accept).');

%% ---- Reject-threshold cutoffs ----
set_tt('EditFieldSNRcaiman', 'Reject cells with CaImAn SNR below this value.');
set_tt('CheckBoxSNRcaiman',  'Enable the CaImAn-SNR rejection cutoff.');
set_tt('EditFieldSNR2',      'Reject cells with SNR2 (peaks_ave / noise) below this value.');
set_tt('CheckBoxSNR2',       'Enable the SNR2 rejection cutoff.');
set_tt('EditFieldCNN',       'Reject cells with CNN probability below this value.');
set_tt('CheckBoxCNN',        'Enable the CNN rejection cutoff.');
set_tt('EditFieldRvalues',   'Reject cells with spatial r-value below this value.');
set_tt('CheckBoxRvalues',    'Enable the r-value rejection cutoff.');
set_tt('EditFieldMinSigFrac', ...
    'Reject cells active in fewer than this fraction of frames (uses num_zeros).');
set_tt('CheckBoxMinSigFrac', 'Enable the min-signal-fraction cutoff.');
set_tt('EditFieldFiringStability', ...
    'Reject cells with firing-stability score below this value.');
set_tt('CheckBoxFiringStability', 'Enable the firing-stability cutoff.');
set_tt('EditFieldSkewness',  'Reject cells with trace skewness below this value.');
set_tt('CheckBoxSkewness',   'Enable the skewness cutoff.');

%% ---- Smooth dF/dt deconvolution ----
set_tt('ConvolvewithgaussiankernelCheckBoxSmoothdfdt', ...
    'Apply a Gaussian smoothing kernel to the diff(C+YrA) trace before deconvolution.');
set_tt('GaussKernelSimgaSmoothdfdt', ...
    'Standard deviation of the Gaussian smoothing kernel, in milliseconds.');
set_tt('RectifyCheckBox', 'Zero out negative values after smoothing (half-wave rectification).');
set_tt('NormalizeCheckBox', 'Divide each cell''s trace by its absolute peak so values are in [-1, 1].');
set_tt('ApplythresholdCheckBox', 'Zero out values below threshold_z * std (per cell) at display time.');
set_tt('ThresholdmagZEditField', 'Z-score cutoff applied when "Apply threshold" is on.');
set_tt('ScaleEditField', 'Display-only multiplicative scale for the smooth dF/dt trace.');
set_tt('ShiftEditField', 'Display-only additive offset for the smooth dF/dt trace.');
set_tt('PlotthresholdCheckBox', 'Show a horizontal line at the applied threshold.');

%% ---- Constrained foopsi ----
set_tt('ARmodelSwitchCfoopsi', ...
    'AR(1): single exponential decay (one tau). AR(2): separate rise + decay; better for slow indicators like GCaMP6s.');
set_tt('UsemanualtimeconstantsCheckBoxCfoopsi', ...
    'When on, use the manual tau values below instead of the per-cell AR coefficients estimated at load time.');
set_tt('TauriseEditFieldCfoopsi', 'Rise time constant in seconds (AR(2) only, only used when manual taus are on).');
set_tt('TaudecayEditFieldCfoopsi', 'Decay time constant in seconds (used when manual taus are on).');
set_tt('ConvolvewithgaussiankernelCheckBoxCfoopsi', ...
    'Display-only Gaussian smoothing of the foopsi spike output.');
set_tt('GaussKernelSimgaCfoopsi', 'Sigma of the display-only Gaussian smoothing, in milliseconds.');
set_tt('FudgeFactorEditField', ...
    'Shrinks the AR poles toward 0 to compensate for time-constant estimation bias. Typical 0.97-0.99. Used by every deconv method (cvx, dual, OASIS) and by the merge step.');
set_tt('DeconvMethodDropDownCfoopsi', ...
    ['Solver for constrained foopsi:' newline ...
     '  oasis  — fast, no external dependencies (vendored)' newline ...
     '  cvx    — best quality, requires CVX install (cvxr.com)' newline ...
     '  dual   — uses fmincon (requires Optimization Toolbox)' newline ...
     'Items tagged "(not installed)" still let you pick — the backend falls back to a working solver and warns.']);
set_tt('ScaleEditFieldCfoopsi', 'Display-only multiplicative scale for the foopsi spike train.');
set_tt('ShiftEditFieldCfoopsi', 'Display-only additive offset for the foopsi spike train.');
set_tt('OverwriteCheckBox', ...
    'When on, re-run deconvolution even for cells that already have a stored result.');

%% ---- MCMC ----
set_tt('ARmodelSwitchMCMC', 'AR(1) or AR(2) for MCMC deconvolution.');
set_tt('MCMCBurnInSamples', 'Number of burn-in samples before MCMC averaging.');
set_tt('MCMCNNumberOfSamples', 'Total number of MCMC samples per cell.');
set_tt('UsemanualtimeconstantsCheckBoxMCMC', 'Use manual tau values for MCMC instead of estimated AR coefficients.');
set_tt('TauriseEditFieldMCMC',  'MCMC rise tau (s), only used when manual taus are on.');
set_tt('TaudecayEditFieldMCMC', 'MCMC decay tau (s), used when manual taus are on.');
set_tt('ConvolvewithgaussiankernelCheckBoxMCMC', 'Display-only Gaussian smoothing of the MCMC spike output.');
set_tt('GaussKernelSimgaMCMC',  'Sigma of the MCMC display-only smoothing, in milliseconds.');
set_tt('ScaleEditFieldMCMC',    'Display-only multiplicative scale for the MCMC spike train.');
set_tt('ShiftEditFieldMCMC',    'Display-only additive offset for the MCMC spike train.');
set_tt('SaveSamplesOutputsMCMC', 'When on, save the raw MCMC samples (large) in addition to the mean output.');

%% ---- Merge similar components ----
set_tt('MergesimilarcompCheckBox', ...
    'When on, apply the merge (combine duplicate cells); when off, only detect candidate pairs without modifying est/proc.');
set_tt('MergemethodDropDown', ...
    ['How to combine two duplicate cells:' newline ...
     '  choose better — keep the higher-SNR cell, drop the other' newline ...
     '  weighted ave  — weighted average of spatial + temporal' newline ...
     '  full mean corr — average using the full cross-correlation' newline ...
     '  svd / nmf      — low-rank decomposition of the joint pool']);
set_tt('spatialcorrthershEditField', 'Minimum A^T*A spatial overlap to consider a candidate merge pair.');
set_tt('tempcorrtheshEditField',     'Minimum Pearson temporal correlation to consider a candidate merge pair.');
set_tt('UseacceptedcellsCheckBox',   'Restrict merge candidates to currently-accepted cells only.');

%% ---- Visualization / trace panel ----
set_tt('ContourMinEditField', 'Lower bound of the contour color scale (current metric).');
set_tt('ContourMaxEditField', 'Upper bound of the contour color scale (current metric).');
set_tt('SmoothRawButton',     'Smooth the raw (C + YrA) trace before display.');
set_tt('SmoothRawWindowSpinner', 'Window size (frames) for raw-trace lowess smoothing.');
set_tt('PlotRawSwitch',       'Show the raw fluorescence trace (C + YrA) on the trace plot.');
set_tt('PlotCSwitch',         'Show the denoised C trace on the trace plot.');
set_tt('PlotLastCSwitch',     'Show the previously-viewed cell''s C trace (for side-by-side compare).');
set_tt('PlotSpikesSwitch',    'Show the raw CaImAn spike train (est.S) on the trace plot.');
set_tt('PlotsmoothdfofSwitch', 'Show the smooth dF/dt deconvolution output on the trace plot.');
set_tt('PlotconstfoopsiSwitch', 'Show the constrained-foopsi deconvolution output on the trace plot.');
set_tt('PlotMCMCSwitch',      'Show the MCMC deconvolution output on the trace plot.');

%% ---- Init / data-info fields (mostly read-only displays from the CaImAn file) ----
set_tt('DataframeratefpsEditField', 'Frame rate (Hz) from the CaImAn init params.');
set_tt('DimsEditField',         'FOV dimensions [height, width] from the CaImAn init params.');
set_tt('DecayTimeEditField',    'Typical transient decay time (s) from the CaImAn init params.');
set_tt('FrameRateEditField',    'Frame rate (Hz) at CaImAn estimate time.');
set_tt('gSigEditField',         'Cell half-size estimate [y, x] from the CaImAn init params.');
set_tt('EpochsEditField',       'Online-mode epochs from the CaImAn init params.');
set_tt('pARmodelEditField',     'AR model order used by CaImAn extraction (1 or 2).');
set_tt('ds_factorEditField',    'Downsampling factor used during CaImAn extraction.');


    function set_tt(widget_name, tip)
        % Set .Tooltip on a named widget; quietly skip if absent.
        if isprop(app, widget_name) && isobject(app.(widget_name))
            try
                app.(widget_name).Tooltip = tip;
            catch
                % some widget types (e.g. older Switch) don't have Tooltip
            end
        end
    end

end
