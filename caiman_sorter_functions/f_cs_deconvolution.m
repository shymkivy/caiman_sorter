function f_cs_deconvolution(app, cells_to_process)
num_cells = numel(cells_to_process);

if strcmp(app.DeonvolutionTypeGroup.SelectedTab.Title, 'smooth df/dt')
    f_cs_compute_smooth_dfof(app);
elseif strcmp(app.DeonvolutionTypeGroup.SelectedTab.Title, 'constrained foopsi')
    fw = app.UIFigure;
    hw = uiprogressdlg(fw,'Title','Running constrained foopsi...');
    pause(0.05);
    for n_cell_inx = 1:num_cells
        n_cell = cells_to_process(n_cell_inx);
        if isempty(app.proc.deconv.c_foopsi.S{n_cell}) || app.OverwriteCheckBox.Value
            f_cs_compute_constrained_foopsi(app, n_cell);
        end
        hw.Value = n_cell/app.proc.num_cells;
    end
    close(hw);
    app.PlotconstfoopsiSwitch.Enable = 1;
elseif strcmp(app.DeonvolutionTypeGroup.SelectedTab.Title, 'MCMC')
    fw = app.UIFigure;
    hw = uiprogressdlg(fw,'Title','Running MCMC...');
    pause(0.05);
    for n_cell_inx = 1:num_cells
        n_cell = cells_to_process(n_cell_inx);
        if isempty(app.proc.deconv.MCMC.S{n_cell}) || app.OverwriteCheckBox.Value
            f_cs_compute_MCMC(app, n_cell);
        end
        hw.Value = n_cell/app.proc.num_cells;
    end
    close(hw);
    app.PlotMCMCSwitch.Enable = 1;
    app.PlotMCMCSAMPLESdetailsButton.Enable = 1;
end

end