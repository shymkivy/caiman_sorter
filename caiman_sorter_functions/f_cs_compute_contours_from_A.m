function contours = f_cs_compute_contours_from_A(A, dims)
% Per-cell outer-boundary contours traced from the sparse spatial-components
% matrix A. Extracted from the inline loop in f_cs_load_h5_est.m so the same
% logic can rebuild contours when a loaded .mat file doesn't include them.
%
%   A    : (n_pixels, n_cells) sparse spatial components
%   dims : [height, width] of the FOV
% Returns (n_cells, 1) cell array; each cell is an (N, 2) [x, y] polygon
% in 1-based MATLAB image coordinates.

n_cells = size(A, 2);
contours = cell(n_cells, 1);
for ii = 1:n_cells
    [px, ~] = find(A(:, ii));
    if isempty(px)
        contours{ii} = zeros(0, 2);
        continue;
    end
    [y_temp, x_temp] = ind2sub(dims, px);
    % Pad degenerate single-row/column ROIs so `boundary` doesn't error.
    if numel(unique(x_temp)) <= 1
        x_temp2 = [x_temp-1; x_temp; x_temp+1];
        y_temp2 = [y_temp;   y_temp; y_temp];
        % `<= dims(2)` so the rightmost valid column survives padding
        % (strict `<` previously dropped edge-ROI cells, leaving too few
        % points for `boundary` to trace).
        idx1 = and(x_temp2 >= 1, x_temp2 <= dims(2));
        x_temp = x_temp2(idx1);
        y_temp = y_temp2(idx1);
    end
    if numel(unique(y_temp)) <= 1
        x_temp2 = [x_temp;   x_temp; x_temp];
        y_temp2 = [y_temp-1; y_temp; y_temp+1];
        idx1 = and(y_temp2 >= 1, y_temp2 <= dims(1));
        x_temp = x_temp2(idx1);
        y_temp = y_temp2(idx1);
    end
    indx_temp = boundary(x_temp, y_temp);
    contours{ii} = [x_temp(indx_temp), y_temp(indx_temp)];
end

end
