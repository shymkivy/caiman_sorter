function f_cs_initialize_deconvolution(app)

%%
app.proc.deconv.smooth_dfdt.S = zeros(app.proc.num_cells,app.proc.num_frames);
f_cs_compute_smooth_dfof(app);
%%
if isobject(app.PlotconstfoopsiSwitch)
    if ~isfield(app.proc.deconv, 'c_foopsi') || ~isfield(app.proc.deconv.c_foopsi, 'S')
        app.proc.deconv.c_foopsi.S = cell(app.proc.num_cells,1);
        app.proc.deconv.c_foopsi.C = cell(app.proc.num_cells,1);
        app.proc.deconv.c_foopsi.p = cell(app.proc.num_cells,1);
        app.proc.deconv.c_foopsi.g = cell(app.proc.num_cells,1);
    end
end
%%
if isobject(app.PlotMCMCSwitch)
    if ~isfield(app.proc.deconv, 'MCMC') || ~isfield(app.proc.deconv.MCMC, 'S')
        app.proc.deconv.MCMC.S = cell(app.proc.num_cells,1);
        app.proc.deconv.MCMC.C = cell(app.proc.num_cells,1);
        app.proc.deconv.MCMC.SAMP = cell(app.proc.num_cells,1);
    end
end

end