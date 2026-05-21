function f_cs_FlipSwitchCaimanLight(app)
    % strcmpi so files written by other tools (e.g. the Python sorter, which
    % may use 'CaImAn evaluate') still match. Same effect for 'Reject threshhold'.
    if strcmpi(app.SwitchCaimanEvaluate.Value, 'Caiman evaluate')
        app.LampCaimanEval.Color = [0.00,1.00,0.00];
        app.LampRejectThresh.Color = [0.80,0.80,0.80];
    elseif strcmpi(app.SwitchCaimanEvaluate.Value, 'Reject threshhold')
        app.LampCaimanEval.Color = [0.80,0.80,0.80];
        app.LampRejectThresh.Color = [0.00,1.00,0.00];
    end
end