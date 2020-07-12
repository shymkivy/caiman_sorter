function est = f_cs_extract_h5_data(file_loc, dims)          
    dataset_path = '/estimates';  
    
    error_log = {};

    % recereate A
    A_data = h5read(file_loc,[dataset_path '/A/data']);
    A_indices = h5read(file_loc,[dataset_path '/A/indices']) + 1; % python offset
    A_indptr = h5read(file_loc,[dataset_path '/A/indptr']);
    A_shape = h5read(file_loc,[dataset_path '/A/shape']);

    A = zeros(A_shape', 'single');
    contours = cell(numel(A_indptr)-1,1);
    for ii = 1:numel(A_indptr)-1         
        temp_indices = A_indices(A_indptr(ii)+1:A_indptr(ii+1));

        A(temp_indices,ii) = A_data(A_indptr(ii)+1:A_indptr(ii+1));

        [y_temp, x_temp] = ind2sub(dims, temp_indices);
        indx_temp = boundary(x_temp, y_temp);
        contours{ii} = [x_temp(indx_temp),y_temp(indx_temp)];
    end

    est.A = A;
    est.contours = contours;


    % recreate C
    est.C = h5read(file_loc,[dataset_path '/C'])';
    est.F_dff = h5read(file_loc,[dataset_path '/F_dff'])';
    est.R = h5read(file_loc,[dataset_path '/R'])';
    est.S = h5read(file_loc,[dataset_path '/S'])';
    est.YrA = h5read(file_loc,[dataset_path '/YrA'])';


    % comp evaluation
    est.SNR_comp = h5read(file_loc,[dataset_path '/SNR_comp']);
    est.cnn_preds = h5read(file_loc,[dataset_path '/cnn_preds']);
    est.r_values = h5read(file_loc,[dataset_path '/r_values']);


    % background
    est.sn = h5read(file_loc,[dataset_path '/sn']);
    % spatial background
    est.b = h5read(file_loc,[dataset_path '/b']);
    % temporal background
    est.f = h5read(file_loc,[dataset_path '/f']);

    est.g = h5read(file_loc,[dataset_path '/g']);

    % index of good and bad
    est.idx_components = h5read(file_loc,[dataset_path '/idx_components']);
    est.idx_components_bad = h5read(file_loc,[dataset_path '/idx_components_bad']);

    if iscell(est.idx_components)
        if strcmp(est.idx_components{1}, 'NoneType')
            %no index assigned
            est.idx_components = 0:(A_shape(2)-1);
            est.idx_components_bad = [];

            est.SNR_comp = zeros(A_shape(2),1);
            est.cnn_preds = zeros(A_shape(2),1);
            est.r_values = zeros(A_shape(2),1);

            error_log = {error_log; 'Components were not evaluate in caiman'};
        end
    end

    est.idx_components = est.idx_components + 1; % python offset
    est.idx_components_bad = est.idx_components_bad + 1; % python offset

    % extact params
    hinfo = h5info(file_loc);

    init_params = struct;
    for n_pg = 1:numel(hinfo.Groups(2).Groups)
        [~, g_name, ~] = fileparts(hinfo.Groups(2).Groups(n_pg).Name);
        init_params.(g_name) = struct;
        for n_pgg = 1:numel(hinfo.Groups(2).Groups(n_pg).Datasets)
            [~, gd_name, ~] = fileparts(hinfo.Groups(2).Groups(n_pg).Datasets(n_pgg).Name);
            init_params.(g_name).(gd_name) = h5read(file_loc, [hinfo.Groups(2).Groups(n_pg).Name '/' hinfo.Groups(2).Groups(n_pg).Datasets(n_pgg).Name]);
        end
    end

    %

    eval_params.SNR_lowest_thresh =  double(h5read(file_loc, '/params/quality/SNR_lowest'));
    eval_params.SNR_thresh =         double(h5read(file_loc, '/params/quality/min_SNR'));
    eval_params.cnn_lowest_thresh =  double(h5read(file_loc, '/params/quality/cnn_lowest'));
    eval_params.cnn_thresh =         double(h5read(file_loc, '/params/quality/min_cnn_thr'));
    eval_params.rval_lowest_thresh = double(h5read(file_loc, '/params/quality/rval_lowest'));
    eval_params.rval_thresh =        double(h5read(file_loc, '/params/quality/rval_thr'));
    
    est.eval_params_caiman = eval_params;
    est.init_params_caiman = init_params;
    est.extraction_error_log = error_log;
end