function f_cs_save_ops(app)

app.ops = f_cs_collect_ops(app);
ops = app.ops;
try 
    if ~exist(app.ops_path, 'file')
        save(app.ops_path, 'ops');
    else
        save(app.ops_path, 'ops', '-append');
    end
    f_cs_update_log(app, ['Ops saved in: ' app.ops_path]);
catch
    f_cs_update_log(app, ['Unable to save ops in ' app.ops_path]);
end

end