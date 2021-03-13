function est = f_cs_load_h5_est(file_loc, dims, dataset_path, disc_offset)

error_log = {};

A_data = h5read(file_loc,[dataset_path '/A/data']);
A_indices = h5read(file_loc,[dataset_path '/A/indices']) + 1; % python offset
A_indptr = h5read(file_loc,[dataset_path '/A/indptr']);
A_shape = h5read(file_loc,[dataset_path '/A/shape']);

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

if iscell(est.idx_components)
    if strcmp(est.idx_components{1}, 'NoneType')
        %no index assigned
        if ~exist('disc_offset', 'var')
            est.idx_components = 0:(A_shape(2)-1);
            est.idx_components_bad = [];
        else
            est.idx_components = [];
            est.idx_components_bad = (0:(A_shape(2)-1))+disc_offset;
        end

        error_log = {error_log; 'Components were not evaluated in caiman'};
    end
elseif ischar(est.idx_components)
    if strcmp(est.idx_components, 'NoneType')
        %no index assigned
        if ~exist('disc_offset', 'var')
            est.idx_components = 0:(A_shape(2)-1);
            est.idx_components_bad = [];
        else
            est.idx_components = [];
            est.idx_components_bad = (0:(A_shape(2)-1))+disc_offset;
        end

        error_log = {error_log; 'Components were not evaluated in caiman'};
    end
end

if iscell(est.idx_components_bad)
    if strcmp(est.idx_components_bad{1}, 'NoneType')
        %no index assigned
        if ~exist('disc_offset', 'var')
            est.idx_components_bad = [];
        else
            est.idx_components_bad = (0:(A_shape(2)-1))+disc_offset;
        end

        error_log = {error_log; 'Components were not evaluated in caiman'};
    end
elseif ischar(est.idx_components_bad)
    if strcmp(est.idx_components_bad, 'NoneType')
        %no index assigned
        if ~exist('disc_offset', 'var')
            est.idx_components_bad = [];
        else
            est.idx_components_bad = (0:(A_shape(2)-1))+disc_offset;
        end

        error_log = {error_log; 'Components were not evaluated in caiman'};
    end
end

est.idx_components = est.idx_components + 1; % python offset
est.idx_components_bad = est.idx_components_bad + 1; % python offset

if iscell(est.SNR_comp)
    if strcmp(est.SNR_comp{1}, 'NoneType')
        est.SNR_comp = zeros(A_shape(2),1);
        error_log = {error_log; 'SNR was not evaluated in caiman'};
    end
elseif ischar(est.SNR_comp)
    if strcmp(est.SNR_comp, 'NoneType')
        est.SNR_comp = zeros(A_shape(2),1);
        error_log = {error_log; 'SNR was not evaluated in caiman'};
    end
end

if iscell(est.cnn_preds)
    if strcmp(est.cnn_preds{1}, 'NoneType')
        est.cnn_preds = zeros(A_shape(2),1);
        error_log = {error_log; 'CNN predictions were not evaluated in caiman'};
    end
elseif ischar(est.cnn_preds)
    if strcmp(est.cnn_preds, 'NoneType')
        est.cnn_preds = zeros(A_shape(2),1);
        error_log = {error_log; 'CNN predictions were not evaluated in caiman'};
    end
elseif isempty(est.cnn_preds)
    est.cnn_preds = zeros(A_shape(2),1);
    error_log = {error_log; 'CNN predictions were not evaluated in caiman'};
end

if iscell(est.r_values)
    if strcmp(est.r_values{1}, 'NoneType')
        est.r_values = zeros(A_shape(2),1);
        error_log = {error_log; 'R-values were not evaluated in caiman'};
    end
elseif ischar(est.r_values)
    if strcmp(est.r_values, 'NoneType')
        est.r_values = zeros(A_shape(2),1);
        error_log = {error_log; 'R-values were not evaluated in caiman'};
    end
end

if iscell(est.b)
    if strcmp(est.b{1}, 'NoneType')
        est.b = zeros(1,size(A,1));
        est.f = zeros(size(est.C,2),1);
        error_log = {error_log; 'b and f were not evaluated in caiman'};
    end
elseif ischar(est.b)
    if strcmp(est.b, 'NoneType')
        est.b = zeros(1,size(A,1));
        est.f = zeros(size(est.C,2),1);
        error_log = {error_log; 'b and f were not evaluated in caiman'};
    end
end

est.error_log = error_log;

end