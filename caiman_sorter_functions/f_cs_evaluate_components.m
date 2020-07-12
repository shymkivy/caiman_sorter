function f_cs_evaluate_components(app)
    if strcmp(app.SwitchCaimanEvaluate.Value, 'Caiman evaluate')
        % find good above thresh (from caiman python)
        idx_comp_r = find(app.est.r_values >= app.RvalthreshSpinner.Value);
        idx_comp_raw = find(app.est.SNR_comp > app.SNRthreshSpinner.Value);
        idx_comp_cnn = find(app.est.cnn_preds >= app.CNNprobthreshSpinner.Value);

        % combine good
        idx_comp = union(idx_comp_cnn,idx_comp_r);
        idx_comp = union(idx_comp,idx_comp_raw);

        % find bad below lowest thresh
        bad_comp = find(or(or((app.est.r_values <= app.RvalLowestthreshSpinner.Value),(app.est.SNR_comp<= app.SNRLowestthreshSpinner.Value)),( app.est.cnn_preds <= app.CNNLowestthreshSpinner.Value)));

        idx_comp = setdiff(idx_comp,bad_comp);

        app.proc.comp_accepted_core = false(app.proc.num_cells,1);
        app.proc.comp_accepted_core(idx_comp) = 1;
    elseif strcmp(app.SwitchCaimanEvaluate.Value, 'Reject threshhold')
        app.proc.comp_accepted_core = true(size(app.est.C,1),1);
        if app.CheckBoxSNRcaiman.Value
            app.proc.comp_accepted_core = (app.est.SNR_comp>=app.EditFieldSNRcaiman.Value).*app.proc.comp_accepted_core;
        end
        if app.CheckBoxSNR2.Value
            app.proc.comp_accepted_core = (app.proc.SNR2_vals>=app.EditFieldSNR2.Value).*app.proc.comp_accepted_core;
        end
        if app.CheckBoxCNN.Value
            app.proc.comp_accepted_core = (app.est.cnn_preds>=app.EditFieldCNN.Value).*app.proc.comp_accepted_core;
        end
        if app.CheckBoxRvalues.Value
            app.proc.comp_accepted_core = (app.est.r_values>=app.EditFieldRvalues.Value).*app.proc.comp_accepted_core;
        end
        if app.CheckBoxMinSigFrac.Value
            app.proc.comp_accepted_core = (~(app.proc.num_zeros>=((1-app.EditFieldMinSigFrac.Value)*app.proc.num_frames))).*app.proc.comp_accepted_core;
        end
        if app.CheckBoxFiringStability.Value
            app.proc.comp_accepted_core = (app.proc.firing_stab_vals>=app.EditFieldFiringStability.Value).*app.proc.comp_accepted_core;
        end
        app.proc.comp_accepted_core = logical(app.proc.comp_accepted_core);
    end
end