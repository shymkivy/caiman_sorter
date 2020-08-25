function f_cs_compute_smooth_dfof(app)
    data = double(app.est.C+app.est.YrA);
    
    fr = double(app.ops.init_params_caiman.data.fr);
    dt = 1000/fr;
    sigma_frames = app.GaussKernelSimgaSmoothdfdt.Value/dt;
 
    do_smooth = app.ConvolvewithgaussiankernelCheckBoxSmoothdfdt.Value;
    
    app.proc.deconv.smooth_dfdt.S = f_smooth_dfdt3(data, do_smooth, sigma_frames, app.NormalizeCheckBox.Value, app.RectifyCheckBox.Value);
    
    for n_cell = 1:app.proc.num_cells
        temp_trace = app.proc.deconv.smooth_dfdt.S(n_cell,:);
        temp_trace(temp_trace <= 0) = [];
        app.proc.deconv.smooth_dfdt.S_std(n_cell) = sqrt(mean(temp_trace.^2));
    end

end