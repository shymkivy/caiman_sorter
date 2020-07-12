%% test modulate for all oasis functions. 
col = {[0 114 178],[0 158 115], [213 94 0],[230 159 0],...
    [86 180 233], [204 121 167], [64 224 208], [240 228 66]}; % colors
plot_cvx = true; 

addpath('C:\Users\ys2605\Desktop\matlab\CaImAn\CaImAn-modified\deconvolution');
addpath('C:\Users\ys2605\Desktop\matlab\CaImAn\CaImAn-modified\deconvolution\functions');
%% example 2: foopsi, AR2 model 
g = [1.7, -0.712];         % AR coefficient 
noise = 1; 
T = 3000; 
framerate = 30;     
firerate = 0.5; 
b = 0;              % baseline 
N = 20;              % number of trials 
seed = 3;          % seed for genrating random variables 
[Y, trueC, trueS] = gen_data(g, noise, T, framerate, firerate, b, N, seed); 
y = Y(1,:); 
true_c = trueC(1,:);  %#ok<*NASGU>
true_s = trueS(1,:); 

figure; plot(Y(1,:))
figure; plot(Y(2,:))

[f, xi] = ksdensity(Y(1,:));
figure; plot(xi,f); title('Y(1,:)');


% case 1: all parameters are known 
lambda = 25;


params.p = 2; 
params.B = 300; 
[~, ~, options] = deconvolveCa(y, 'mcmc', params);  %#ok<*ASGLU>
[~, ~, options] = deconvolveCa(y, 'mcmc', params);  %#ok<*ASGLU>
plot_continuous_samples(options.mcmc_results,y);


figure('name', 'FOOPSI, AR2, known: g, lambda', 'papersize', [15, 4]); 
show_results; 
