function f_cs_deconvolution_light(app)
%num_cells = numel(cells_to_process);

if strcmp(app.DeonvolutionTypeGroup.SelectedTab.Title, 'smooth df/dt')
    f_cs_compute_smooth_dfof(app);
end

ends