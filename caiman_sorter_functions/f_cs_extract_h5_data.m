function est = f_cs_extract_h5_data(file_loc, dims)          
dataset_path = '/estimates';  

error_log = {};

%% load components
est_good = f_cs_load_h5_est(file_loc, dims, dataset_path);

num_good_comp = numel(est_good.contours);

%%
hinfo = h5info(file_loc);

%% check if components were already discarded into discarded pile

est_idx = strcmpi('/estimates', {hinfo.Groups.Name});
disc_comp_idx = strcmpi('discarded_components', {hinfo.Groups(est_idx).Datasets.Name});
add_disc = 0;
if ~sum(disc_comp_idx)
    add_disc = 1;
else
    if ~isempty(hinfo.Groups(est_idx).Datasets(disc_comp_idx).Dataspace.Size)
        add_disc = 1;
    end
end


if add_disc
    dataset_path_discard = '/estimates/discarded_components';
    A_data_disc = h5read(file_loc,[dataset_path_discard '/A/data']);
    if numel(A_data_disc) > 0
        est_bad = f_cs_load_h5_est(file_loc, dims, dataset_path_discard, num_good_comp);

        % combine
        est.A = [est_good.A, est_bad.A];
        est.contours = [est_good.contours; est_bad.contours];
        est.C = [est_good.C; est_bad.C];
        if iscell(est_bad.F_dff)
            if strcmp(est.idx_components{1}, 'NoneType')
                est.F_dff = [est_good.F_dff; zeros(size(est_bad.C))];
            end
        else
            est.F_dff = [est_good.F_dff; est_bad.F_dff];
        end
        est.R = [est_good.R; est_bad.R];
        est.S = [est_good.S; est_bad.S];
        est.YrA = [est_good.YrA; est_bad.YrA];
        est.SNR_comp = [est_good.SNR_comp; est_bad.SNR_comp];
        est.cnn_preds = [est_good.cnn_preds; est_bad.cnn_preds];
        est.r_values = [est_good.r_values; est_bad.r_values];
        est.SNR_comp = [est_good.SNR_comp; est_bad.SNR_comp];
        est.sn = est_good.sn;
        est.b = est_good.b;
        est.f = est_good.f;
        est.g = [est_good.g, est_bad.g];
        est.idx_components = est_good.idx_components;
        est.idx_components_bad = est_bad.idx_components_bad;
        error_log = [est_good.error_log; est_bad.error_log];
    else
        est = est_good;
    end
else
    est = est_good;
end

%% extact params


init_params = struct;
for n_pg = 1:numel(hinfo.Groups(2).Groups)
    [~, g_name, ~] = fileparts(hinfo.Groups(2).Groups(n_pg).Name);
    init_params.(g_name) = struct;
    for n_pgg = 1:numel(hinfo.Groups(2).Groups(n_pg).Datasets)
        [~, gd_name, ~] = fileparts(hinfo.Groups(2).Groups(n_pg).Datasets(n_pgg).Name);
        init_params.(g_name).(gd_name) = h5read(file_loc, [hinfo.Groups(2).Groups(n_pg).Name '/' hinfo.Groups(2).Groups(n_pg).Datasets(n_pgg).Name]);
    end
end

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