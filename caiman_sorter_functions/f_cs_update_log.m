function f_cs_update_log(app, new_text)
    app.log = [sprintf('%d : %s\n', app.log_line, new_text) app.log ];
    app.LogTextArea.Value = app.log;
    app.log_line = app.log_line + 1;
    drawnow; pause(0.05);
end