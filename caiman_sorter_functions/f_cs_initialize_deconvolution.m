function f_cs_initialize_deconvolution(app)

n = app.proc.num_cells;

%%
app.proc.deconv.smooth_dfdt.S = zeros(n, app.proc.num_frames);
f_cs_compute_smooth_dfof(app);
%%
% Init c_foopsi / MCMC cells if absent OR if length doesn't match num_cells
% (a partial reset or external load can leave stale-length arrays that
% would crash later when indexed past their end).
if isobject(app.PlotconstfoopsiSwitch)
    if ~isfield(app.proc.deconv, 'c_foopsi') ...
            || ~isfield(app.proc.deconv.c_foopsi, 'S') ...
            || numel(app.proc.deconv.c_foopsi.S) ~= n
        app.proc.deconv.c_foopsi.S = cell(n, 1);
        app.proc.deconv.c_foopsi.C = cell(n, 1);
        app.proc.deconv.c_foopsi.p = cell(n, 1);
        app.proc.deconv.c_foopsi.g = cell(n, 1);
    end
end
%%
if isobject(app.PlotMCMCSwitch)
    if ~isfield(app.proc.deconv, 'MCMC') ...
            || ~isfield(app.proc.deconv.MCMC, 'S') ...
            || numel(app.proc.deconv.MCMC.S) ~= n
        app.proc.deconv.MCMC.S = cell(n, 1);
        app.proc.deconv.MCMC.C = cell(n, 1);
        app.proc.deconv.MCMC.SAMP = cell(n, 1);
    end
end

end