function est = f_cs_load_h5_est(file_loc, dims, dataset_path, disc_offset)

error_log = {};

A_data = h5read(file_loc,[dataset_path '/A/data']);
A_indices = h5read(file_loc,[dataset_path '/A/indices']) + 1; % python offset
A_indptr = h5read(file_loc,[dataset_path '/A/indptr']);
A_shape = h5read(file_loc,[dataset_path '/A/shape']);

if ~exist('disc_offset', 'var')
    disc_offset = 0;
end

% A = zeros(A_shape', 'single');
% contours = cell(numel(A_indptr)-1,1);
% for ii = 1:numel(A_indptr)-1         
%     temp_indices = A_indices(A_indptr(ii)+1:A_indptr(ii+1));
% 
%     A(temp_indices,ii) = A_data(A_indptr(ii)+1:A_indptr(ii+1));
% 
%     [y_temp, x_temp] = ind2sub(dims, temp_indices);
%     indx_temp = boundary(x_temp, y_temp);
%     contours{ii} = [x_temp(indx_temp),y_temp(indx_temp)];
% end

% get A
cell_coeffs = zeros(numel(A_data),1);
for ii = 1:numel(A_indptr)-1 
    cell_coeffs(A_indptr(ii)+1:A_indptr(ii+1)) = ii;
end
A = sparse(double(A_indices), cell_coeffs, double(A_data), double(A_shape(1)), double(A_shape(2)));

% get concours for plots
contours = cell(numel(A_indptr)-1,1);
for ii = 1:numel(A_indptr)-1 
    temp_indices = A_indices(A_indptr(ii)+1:A_indptr(ii+1));
    [y_temp, x_temp] = ind2sub(dims, temp_indices);
    indx_temp = boundary(x_temp, y_temp);
    contours{ii} = [x_temp(indx_temp),y_temp(indx_temp)];
end

est.A = A;
est.contours = contours;

% load C
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

make_idx_good = if_check_empty(est.idx_components);
make_idx_bad = if_check_empty(est.idx_components_bad);

if make_idx_good
    %no index assigned
    if disc_offset
        est.idx_components = [];
        est.idx_components_bad = (1:A_shape(2))+disc_offset;
    else
        est.idx_components = 1:A_shape(2);
        est.idx_components_bad = [];
    end
    error_log = {error_log; 'Components were not evaluated in caiman'};
elseif make_idx_bad && ~make_idx_good
    %no index assigned
    if disc_offset
        est.idx_components_bad = (1:A_shape(2))+disc_offset;
    else
        est.idx_components_bad = [];
    end

    error_log = {error_log; 'Components were not evaluated in caiman'};
else
    est.idx_components = est.idx_components + 1; % python offset
    est.idx_components_bad = est.idx_components_bad + 1; % python offset
end

is_empty = if_check_empty(est.SNR_comp);
if is_empty
    est.SNR_comp = zeros(A_shape(2),1);
    error_log = {error_log; 'SNR was not evaluated in caiman'};
end

is_empty = if_check_empty(est.cnn_preds);
if is_empty
    est.cnn_preds = zeros(A_shape(2),1);
    error_log = {error_log; 'CNN predictions were not evaluated in caiman'};
end

is_empty = if_check_empty(est.r_values);
if is_empty
    est.r_values = zeros(A_shape(2),1);
    error_log = {error_log; 'R-values were not evaluated in caiman'};
end

is_empty = if_check_empty(est.b);
if is_empty
    est.b = zeros(1,size(A,1));
    est.f = zeros(size(est.C,2),1);
    error_log = {error_log; 'b and f were not evaluated in caiman'};
end

est.error_log = error_log;

end

function is_empty = if_check_empty(var)

is_empty = 0;
if iscell(var)
    if strcmp(var{1}, 'NoneType')
        is_empty = 1;
    end
end
if ischar(var)
    if strcmp(var, 'NoneType')
        is_empty = 1;
    end
end
if isempty(var)
    is_empty = 1;
end

end
