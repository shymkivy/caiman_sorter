function cell_data = f_cs_gather_est_cell_data(est, proc, n_cell)

num_comp = size(est.C,1);

cell_data = struct();
cell_data.n_cell = n_cell;

fields1 = fields(est);
for n_fl = 1:numel(fields1)
    field_temp = fields1{n_fl};
    siz1 = size(est.(field_temp));
    if siz1(1) == num_comp
        cell_data.(field_temp) = est.(field_temp)(n_cell,:);
    elseif siz1(2) == num_comp
        cell_data.(field_temp) = est.(field_temp)(:,n_cell);
    end
end

fields1 = fields(proc);
for n_fl = 1:numel(fields1)
    field_temp = fields1{n_fl};
    siz1 = size(proc.(field_temp));
    if siz1(1) == num_comp
        cell_data.(field_temp) = proc.(field_temp)(n_cell,:);
    elseif siz1(2) == num_comp
        cell_data.(field_temp) = proc.(field_temp)(:,n_cell);
    end
end

end