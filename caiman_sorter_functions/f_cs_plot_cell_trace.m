function f_cs_plot_cell_trace(app)
    % cell trace
    fr = double(app.est.init_params_caiman.data.fr);
    plot_time = (1:app.proc.num_frames)/fr;
    cla(app.UIAxes_ca_trace)
    title(app.UIAxes_ca_trace, sprintf('Ca trace, cell %d', app.current_cell_num));
    if strcmp(app.PlotLastCSwitch.Value, 'On')
        hold(app.UIAxes_ca_trace, 'on');
        plot(app.UIAxes_ca_trace, plot_time, app.est.C(app.last_cell_num,:), 'color', [0.2039, 0.9216, 0.3686]);
        hold(app.UIAxes_ca_trace, 'off');
    end
    
    if strcmp(app.PlotCSwitch.Value, 'On')
        hold(app.UIAxes_ca_trace, 'on');
        plot(app.UIAxes_ca_trace, plot_time, app.est.C(app.current_cell_num,:), 'color', [0, 0.4470, 0.7410]);
        hold(app.UIAxes_ca_trace, 'off');
    end
    
    if strcmp(app.PlotRawSwitch.Value, 'On')
        hold(app.UIAxes_ca_trace, 'on');
        raw_C_plot = app.est.C(app.current_cell_num,:)+app.est.YrA(app.current_cell_num,:);
        if app.SmoothRawButton.Value
            raw_C_plot = smoothdata(raw_C_plot,'lowess',app.SmoothRawWindowSpinner.Value);
        end
        plot(app.UIAxes_ca_trace, plot_time, raw_C_plot, 'color', [0.8500, 0.3250, 0.0980]);
        hold(app.UIAxes_ca_trace, 'off');
    end
    if strcmp(app.PlotSpikesSwitch.Value, 'On')
        scale_up = max(app.est.C(app.current_cell_num,:))/max(app.est.S(app.current_cell_num,:))/2;
        hold(app.UIAxes_ca_trace, 'on');
        plot(app.UIAxes_ca_trace, plot_time, app.est.S(app.current_cell_num,:)*scale_up, 'color', 	[0.9290, 0.6940, 0.1250]);
        hold(app.UIAxes_ca_trace, 'off');
    end
    
    if strcmp(app.PlotsmoothdfofSwitch.Value, 'On')
        hold(app.UIAxes_ca_trace, 'on');
        trace = app.proc.deconv.smooth_dfdt.S(app.current_cell_num,:);
        z_thresh = app.ThresholdmagZEditField.Value*app.proc.deconv.smooth_dfdt.S_std(app.current_cell_num);
        if app.ApplythresholdCheckBox.Value
            trace(trace<=z_thresh) = z_thresh;
            trace = trace - z_thresh;
            z_thresh = 0;
        end
        trace = trace*app.ScaleEditField.Value+app.ShiftEditField.Value;
        z_thresh = z_thresh*app.ScaleEditField.Value+app.ShiftEditField.Value;
        plot(app.UIAxes_ca_trace, plot_time, trace, 'color', [1, 0, 0]);
        if app.PlotthresholdCheckBox.Value
            plot(app.UIAxes_ca_trace, plot_time, ones(1, app.proc.num_frames)*z_thresh, '--', 'color', [0.6, 0, 0]);
        end
        hold(app.UIAxes_ca_trace, 'off');
    end
    
    if isobject(app.PlotconstfoopsiSwitch)
        if strcmp(app.PlotconstfoopsiSwitch.Value, 'On')
            if ~isempty(app.proc.deconv.c_foopsi.S{app.current_cell_num})
                hold(app.UIAxes_ca_trace, 'on');
                trace1 = app.proc.deconv.c_foopsi.S{app.current_cell_num};
                if app.ConvolvewithgaussiankernelCheckBoxCfoopsi.Value
                    trace1 = convolve_gauss(trace1, app.GaussKernelSimgaCfoopsi.Value, fr);
                end
                trace1 = trace1*app.ScaleEditFieldCfoopsi.Value+app.ShiftEditFieldCfoopsi.Value;
                trace2 = app.proc.deconv.c_foopsi.C{app.current_cell_num};
                plot(app.UIAxes_ca_trace, plot_time, trace1, 'color', [0.4940, 0.1840, 0.5560]);
                plot(app.UIAxes_ca_trace, plot_time, trace2, 'color', [0.6940, 0.3840, 0.7560]);
                hold(app.UIAxes_ca_trace, 'off');
            end
        end
    end
    
    if isobject(app.PlotMCMCSwitch)
        if strcmp(app.PlotMCMCSwitch.Value, 'On')
            if ~isempty(app.proc.deconv.MCMC.S{app.current_cell_num})
                hold(app.UIAxes_ca_trace, 'on');
                trace1 = app.proc.deconv.MCMC.S{app.current_cell_num};
                if app.ConvolvewithgaussiankernelCheckBoxMCMC.Value
                    trace1 = convolve_gauss(trace1, app.GaussKernelSimgaMCMC.Value, fr);
                end
                trace1 = trace1*app.ScaleEditFieldMCMC.Value+app.ShiftEditFieldMCMC.Value;
                trace2 = app.proc.deconv.MCMC.C{app.current_cell_num};
                plot(app.UIAxes_ca_trace, plot_time, trace1, 'color', [0.2660, 0.4740, 0.0880]);
                plot(app.UIAxes_ca_trace, plot_time, trace2, 'color', [0.4660, 0.6740, 0.1880]);
                hold(app.UIAxes_ca_trace, 'off');
            end
        end
    end
end

function trace = convolve_gauss(y, sigma, frame_rate)

dt = 1000/double(frame_rate);
sigma_frames = sigma/dt;
% make kernel
kernel_half_size = ceil(sqrt(-log(0.05)*2*sigma_frames^2));
gaus_win = -kernel_half_size:kernel_half_size;
gaus_kernel = exp(-((gaus_win).^2)/(2*sigma_frames^2));
gaus_kernel = gaus_kernel/sum(gaus_kernel);

trace = conv2(y, gaus_kernel, 'same');

end