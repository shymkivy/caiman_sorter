function f_cs_plot_gaus_kernel(sigma, frame_rate)

dt = 1000/double(frame_rate);

sigma_frames = sigma/dt;
% make kernel
kernel_half_size = ceil(sqrt(-log(0.05)*2*sigma_frames^2));
gaus_win = -kernel_half_size:kernel_half_size;
plot_t = gaus_win*dt;
gaus_kernel = exp(-((gaus_win).^2)/(2*sigma_frames^2));
gaus_kernel = gaus_kernel/sum(gaus_kernel);

plot(plot_t, gaus_kernel);
title(sprintf('Gaussian kernel; sigma = %dms',  sigma));
xlabel('Time (ms)'); axis tight;


end