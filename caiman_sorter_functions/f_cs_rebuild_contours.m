function f_cs_rebuild_contours(app)
% Refresh the per-bin contour overlays from current est.contours +
% proc.comp_accepted + curr_contour_params. Cells are grouped into K bins
% by their contour magnitude, and each bin owns one Line2D per axis whose
% XData/YData is the NaN-separated polygons of all cells in that bin.
%
% Replaces the legacy per-cell Visible/Color manipulation: there used to
% be N Line2D objects per axis (one per cell), now there are K (one per
% color bin). The state model is `est.contours` + `proc.comp_accepted` +
% `curr_contour_params`; mutating any of those + calling this function
% reflects the change on screen.

if isempty(app.est) || isempty(app.proc) || isempty(app.est.contours)
    return;
end
if ~isfield(app.curr_contour_params, 'contour_mag') ...
        || isempty(app.curr_contour_params.contour_mag)
    return;
end

cm = app.curr_contour_params;
K = numel(app.im_accepted_gobj);
n_cells = numel(app.est.contours);

% Clip metric values into [c_lim(1), c_lim(2)] and map to 1..K bins.
contour_mag = max(min(cm.contour_mag, cm.c_lim(2)), cm.c_lim(1));
range = max(cm.c_lim(2) - cm.c_lim(1), eps);
bin_idx = round((contour_mag - cm.c_lim(1)) / range * (K - 1)) + 1;
bin_idx = max(min(bin_idx(:), K), 1);

accepted = logical(app.proc.comp_accepted(:));
visible_global = cm.visible_set;

for k = 1:K
    in_bin = bin_idx == k;
    cells_acc = find(in_bin & accepted);
    cells_rej = find(in_bin & ~accepted);
    [xs_a, ys_a] = local_concat(app.est.contours, cells_acc);
    [xs_r, ys_r] = local_concat(app.est.contours, cells_rej);

    set(app.im_accepted_gobj(k), ...
        'XData', xs_a, 'YData', ys_a, ...
        'Visible', visible_global && ~isempty(xs_a));
    set(app.im_rejected_gobj(k), ...
        'XData', xs_r, 'YData', ys_r, ...
        'Visible', visible_global && ~isempty(xs_r));
end

end


function [xs, ys] = local_concat(contour_cell, cell_idxs)
% NaN-separated concat of selected per-cell polygons. Empty input -> empty.
if isempty(cell_idxs)
    xs = [];
    ys = [];
    return;
end
n = numel(cell_idxs);
parts_x = cell(n, 1);
parts_y = cell(n, 1);
for i = 1:n
    pts = contour_cell{cell_idxs(i)};
    if isempty(pts)
        continue;
    end
    if i < n
        parts_x{i} = [pts(:, 1); NaN];
        parts_y{i} = [pts(:, 2); NaN];
    else
        parts_x{i} = pts(:, 1);
        parts_y{i} = pts(:, 2);
    end
end
xs = vertcat(parts_x{:});
ys = vertcat(parts_y{:});
end
