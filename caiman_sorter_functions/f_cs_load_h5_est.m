function est = f_cs_load_h5_est(file_loc, dims, dataset_path, disc_offset)

error_log = {};

file_info = h5info(file_loc);

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

% Per-cell contours for plotting — computed from the sparse A.
est.A = A;
est.contours = f_cs_compute_contours_from_A(A, dims);

% load C
est.C = h5read(file_loc,[dataset_path '/C'])';
sizC = size(est.C);

est_idx = strcmpi('/estimates', {file_info.Groups.Name});
est_keys = {file_info.Groups(est_idx).Datasets.Name};

fields1 = {'S', 'YrA', 'F_dff', 'R'};
siz1 = sizC;
[est, error_log] = if_copy_fields(est, fields1, siz1, file_loc, dataset_path, est_keys, error_log);

% comp evaluation
siz1 = [sizC(1), 1];
fields1 = {'SNR_comp', 'cnn_preds', 'r_values'};
[est, error_log] = if_copy_fields(est, fields1, siz1, file_loc, dataset_path, est_keys, error_log);

siz1 = [2, sizC(1)];
fields1 = {'g'};
[est, error_log] = if_copy_fields(est, fields1, siz1, file_loc, dataset_path, est_keys, error_log);

% noise, spatial background, temporal background, index of good and bad
fields1 = {'sn', 'b', 'f', 'idx_components', 'idx_components_bad'};
for n_fl = 1:numel(fields1)
    fl1 = fields1{n_fl};
    if sum(strcmpi(fl1, est_keys))
        est.(fl1) = h5read(file_loc,[dataset_path '/' fl1]);
    else
        est.(fl1) = [];
        error_log = [error_log; {sprintf('%s does not exist in estimates', fl1)}];
    end
end

make_idx_good = if_check_empty(est.idx_components);
make_idx_bad = if_check_empty(est.idx_components_bad);

% NB: returned indices are in the COMBINED-pile frame — `+1` is the
% Python→MATLAB 1-based shift, `+disc_offset` shifts the discarded pile
% past the good pile so `f_cs_extract_h5_data.m` can use them as-is.
if make_idx_good
    %no index assigned
    est.idx_components = (1:A_shape(2)) + disc_offset;
    if disc_offset
        est.idx_components_bad = (1:A_shape(2))+disc_offset;
    else
        est.idx_components_bad = [];
    end
    error_log = [error_log; {'Components were not evaluated in caiman'}];
elseif make_idx_bad && ~make_idx_good
    %no index assigned
    est.idx_components = est.idx_components + 1 + disc_offset; % python offset + pile shift
    if disc_offset
        est.idx_components_bad = (1:A_shape(2))+disc_offset;
    else
        est.idx_components_bad = [];
    end

    error_log = [error_log; {'Components were not evaluated in caiman'}];
else
    est.idx_components     = est.idx_components     + 1 + disc_offset; % python offset + pile shift
    est.idx_components_bad = est.idx_components_bad + 1 + disc_offset;
end

is_empty = if_check_empty(est.b);
if is_empty
    % MATLAB-internal: b is (n_bg, n_pixels), f is (n_frames, n_bg) —
    % transposed relative to CaImAn-Python's shapes. The bkg formula in
    % f_cs_initialize_GUI_params.m relies on these orientations.
    est.b = zeros(1, size(A,1));
    est.f = zeros(size(est.C,2), 1);
    error_log = [error_log; {'b and f were not evaluated in caiman'}];
end

est.error_log = error_log;

end

function is_empty = if_check_empty(var)
    % Check isempty FIRST, then index — otherwise `var{1}` on an empty
    % cell throws before the empty branch fires.
    is_empty = 0;
    if isempty(var)
        is_empty = 1;
        return;
    end
    if iscell(var)
        if strcmp(var{1}, 'NoneType')
            is_empty = 1;
        end
    elseif ischar(var)
        if strcmp(var, 'NoneType')
            is_empty = 1;
        end
    end
end

function [est, error_log] = if_copy_fields(est, fields_in, size_check, file_loc, dataset_path, fields_available, error_log)

for n_fl = 1:numel(fields_in)
    fl = fields_in{n_fl};
    if sum(strcmpi(fields_available, fl))
        temp1 = h5read(file_loc,[dataset_path '/' fl]);
        if sum(size(temp1') == size_check) == 2
            est.(fl) = temp1';
        elseif sum(size(temp1) == size_check) == 2
            est.(fl) = temp1;
        else
            est.(fl) = zeros(size_check);
            error_log = [error_log; {sprintf('%s not evaluated in caiman, size mismatch', fl)}];
        end
    else
        est.(fl) = zeros(size_check);
        error_log = [error_log; {sprintf('%s does not exist', fl)}];
    end
end


end
