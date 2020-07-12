function f_cs_FlipSwitchCaimanLight(app)
    if strcmp(app.SwitchCaimanEvaluate.Value, 'Caiman evaluate')
        app.LampCaimanEval.Color = [0.00,1.00,0.00];
        app.LampRejectThresh.Color = [0.80,0.80,0.80];
    elseif strcmp(app.SwitchCaimanEvaluate.Value, 'Reject threshhold')
        app.LampCaimanEval.Color = [0.80,0.80,0.80];
        app.LampRejectThresh.Color = [0.00,1.00,0.00];
    end
end