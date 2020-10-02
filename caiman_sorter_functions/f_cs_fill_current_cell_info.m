function f_cs_fill_current_cell_info(app)

app.SNRcaimanEditField.Value = num2str(app.est.SNR_comp(app.current_cell_num));
app.SNR2EditField.Value = num2str(app.proc.SNR2_vals(app.current_cell_num));
app.CNNprobEditField.Value = num2str(app.est.cnn_preds(app.current_cell_num));
app.r_valEditField.Value = num2str(app.est.r_values(app.current_cell_num));
app.FiringstabilityEditField.Value = num2str(app.proc.firing_stab_vals(app.current_cell_num));
app.PeaksaveEditField.Value = num2str(app.proc.peaks_ave(app.current_cell_num));
app.StdnoiseEditField.Value = num2str(app.proc.noise(app.current_cell_num));
% extract the zoomed cell and make it square axis
current_A = reshape(full(app.est.A(:,app.current_cell_num)),app.est.dims(1),app.est.dims(2));
imagesc(app.UIAxes_component, current_A);
if app.proc.comp_accepted(app.current_cell_num)
    title(app.UIAxes_component, sprintf('Accepted cell %d', app.current_cell_num));
else
    title(app.UIAxes_component, sprintf('Rejected cell %d', app.current_cell_num));
end

y_lim = find(sum(current_A,2)>0);
y_coord = [y_lim(1), y_lim(end)];
y_size = y_coord(2) - y_coord(1);
x_lim = find(sum(current_A,1)>0);
x_coord = [x_lim(1), x_lim(end)];
x_size = x_coord(2) - x_coord(1);
xy_diff = floor(abs(y_size - x_size)/2);
if y_size > x_size
    xlim(app.UIAxes_component, x_coord + [-xy_diff, xy_diff]);
    ylim(app.UIAxes_component, y_coord);
elseif y_size < x_size
    xlim(app.UIAxes_component, x_coord);
    ylim(app.UIAxes_component, y_coord + [-xy_diff, xy_diff]);
else
    xlim(app.UIAxes_component, x_coord);
    ylim(app.UIAxes_component, y_coord);
end

%% deconvolution window
app.CellEditField.Value = app.current_cell_num;
app.TaudecayEditFieldAR1.Value = app.proc.tauAR1(app.current_cell_num);
app.TauriseEditFieldAR2.Value = app.proc.tauAR2(app.current_cell_num,1);
app.TaudecayEditFieldAR2.Value = app.proc.tauAR2(app.current_cell_num,2);

if isobject(app.PlotconstfoopsiSwitch)
    if ~isempty(app.proc.deconv.c_foopsi.S{app.current_cell_num})
        app.PlotconstfoopsiSwitch.Enable = 1;
    else
        app.PlotconstfoopsiSwitch.Enable = 0;
    end
end

if isobject(app.ARmodelSwitchMCMC)
    if ~isempty(app.proc.deconv.MCMC.S)
        if ~isempty(app.proc.deconv.MCMC.S{app.current_cell_num})
            app.PlotMCMCSwitch.Enable = 1;
        else
            app.PlotMCMCSwitch.Enable = 0;
        end
        if ~isempty(app.proc.deconv.MCMC.SAMP)
            if ~isempty(app.proc.deconv.MCMC.SAMP{app.current_cell_num})
                app.PlotMCMCSAMPLESdetailsButton.Enable = 1;
            else
                app.PlotMCMCSAMPLESdetailsButton.Enable = 0;
            end
        end
    else
        app.PlotMCMCSwitch.Enable = 0;
        app.PlotMCMCSAMPLESdetailsButton.Enable = 0;
    end
end

