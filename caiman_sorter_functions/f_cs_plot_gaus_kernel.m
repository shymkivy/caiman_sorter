function f_cs_plot_gaus_kernel(sigma_frames, win_frames, dt)

gaus_win = (1:win_frames) - (win_frames+1)/2;
plot_t = gaus_win*dt;
gaus_kernel = exp(-((gaus_win).^2)/(2*sigma_frames^2));
gaus_kernel = gaus_kernel/sum(gaus_kernel);
figure; 
plot(plot_t, gaus_kernel);
title(['Gaussian kernel; sigma=' num2str(dt*sigma_frames) 'ms']);
xlabel('Time (ms)');

end