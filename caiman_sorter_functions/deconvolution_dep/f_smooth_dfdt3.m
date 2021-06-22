function smooth_dfdt_data = f_smooth_dfdt3(data, do_smooth, sigma_frames, normalize, rectify)
% this calculates derivative of dfof of calcium traces, with Jordans method
% yuriy 5/1/20
%   do_smooth -     do smooth; true(default) or false
%   sigma_frames -  standard deviation of gaussian kernel for smoothing; default = 1
%   normalize -     do normalization; true or false(default)
%   rectify -       do rectification; true(default) or false 
%

if ~exist('do_smooth', 'var') || isempty(do_smooth)
    do_smooth = 1; % default
end

if ~exist('sigma_frames', 'var') || isempty(sigma_frames)
    sigma_frames = 1; % default
end

if ~exist('normalize', 'var') || isempty(normalize)
    normalize = 0; % default
end
if ~exist('rectify', 'var') || isempty(rectify)
    rectify = 1; % default
end

% make kernel
kernel_half_size = ceil(sqrt(-log(0.05)*2*sigma_frames^2));
gaus_win = -kernel_half_size:kernel_half_size;
gaus_kernel = exp(-((gaus_win).^2)/(2*sigma_frames^2));
gaus_kernel = gaus_kernel/sum(gaus_kernel);

% extract the number of cells and the number of frames
num_frames = size(data,2);
num_cells = size(data,1);

smooth_dfdt_data=zeros(num_cells, num_frames);
for n_cell=1:num_cells    % size(data,1)
    temp_data = data(n_cell,:);
    
    % derivative
    temp_data = [0 diff(temp_data)];

    % convolve gaussian
    if do_smooth
        temp_data = conv2(temp_data, gaus_kernel, 'same');
    end
    
    % normalize
    if normalize
        temp_data = temp_data/max(temp_data);
    end
    
    % rectify
    if rectify
        temp_data = max(temp_data,0);
    end
    smooth_dfdt_data(n_cell,:) = temp_data;
end


end