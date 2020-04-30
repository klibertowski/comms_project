% Intro to Communications
% Project Spring 2020

% Stephen Hargreaves
% Kevin Libertowski
% Gretchen Woodling

clc
format compact

g1 = @(t) (1000*t - 2).^2;
g2 = @(t) (-5000*t + 22).^2;
g3 = @(t) (3000*t - 18).^2;

% Energy of g(t)
E_gt = integral(g1, .002, .004) + integral(g2, .004, .005) + integral(g3, .005, .006);

% g(t)^2
gt_sq = @(t) abs((2*tripuls(t - .004, .004) - 4*tripuls(t - .005, .002))).^2;

% Plot of g(t)
% t = 0:.0001:.04;
% gt = 2*tripuls(t - .004, .004) - 4*tripuls(t - .005, .002);
% plot(t, gt)

% Energy from triangular pulse waveform
E_tripuls = integral(gt_sq, 0, .006);

% G(f)^2
Gf_sq = @(f) abs((.004*sinc((.004*f)/2).^2 .* exp(-1i*pi*2*f*.004) - .004*sinc((.002*f)/2).^2 .* exp(-1i*pi*2*f*.005)).^2);

% Setup for while loop
E_ess = 0;
B_step = .1;
B_ess = B_step;

format long

% while E_ess < .99*E_gt
%     B_ess = B_ess + B_step;
%     E_ess = integral(Gf_sq, -B_ess, B_ess)
% end

% calculated from while loop
B_ess_cal = 694.2;

% oversample essential bandwidth
BW = 1400;

t = 0:1/BW:.04;
gt = 2*tripuls(t - .004, .004) - 4*tripuls(t - .005, .002);
stem(t, gt)
title('I-2 Discrete plot of g(t)')

n = 100000;
f = linspace(0, BW, n);
Gf_fft = fft(gt, n);
figure(1)
plot(f, abs(Gf_fft));
title('I-3 |G(f)| Fast Fourier Transform')

% subplot(2,1,1)

Gf = .004*sinc((.004*f)/2).^2 .* exp(-1i*pi*2*f*.004) - .004*sinc((.002*f)/2).^2 .* exp(-1i*pi*2*.005*f);
figure(2)
plot(f, abs(Gf))
title('?')

% I-4
gt_sq_int = @(t) abs(2*tripuls(t - .004, .004) - 4*tripuls(t - .005, .002)).^2;
E_gt = integral(gt_sq_int, 0, 1);

Gf_sq_int = @(f) abs((.004*sinc((.004*f)/2).^2 .* exp(-1i*pi*2*f*.004) - .004*sinc((.002*f)/2).^2 .* exp(-1i*pi*2*f*.005)).^2);
E_gf = integral(Gf_sq_int, -1000000, 1000000); 

% I-5
G_xcorr = xcorr(gt);
figure(3)
plot(linspace(-1000, 1000, length(G_xcorr)), G_xcorr)
title('I-5 Autocorrelation Function')

G_ESD = abs(Gf).^2;
figure(4)
plot(f, G_ESD)
title('I-5 Energy Spectral Density |G(f)|^2')

% II-1
fc = 500;
fs = 2*(B_ess + fc);

BW = 1400;
Wc = 2*pi*fc;

t = 0:1/BW:.04;
gt_DSB = (2*tripuls(t - .004, .004) - 4*tripuls(t - .005, .002)).*cos(Wc*t);
figure(5)
plot(t, gt_DSB)
title('II-1 Double Sideband, Suppressed Carrier, f = 500Hz')

f = linspace(-2*BW, 2*BW, n);
f_1 = f - fc;
f_2 = f + fc;
Gf_1 = .004*sinc((.004*f_1)/2).^2 .* exp(-1i*pi*2*f_1*.004) - .004*sinc((.002*f_1)/2).^2 .* exp(-1i*pi*2*.005*f_1);
Gf_2 = .004*sinc((.004*f_2)/2).^2 .* exp(-1i*pi*2*f_2*.004) - .004*sinc((.002*f_2)/2).^2 .* exp(-1i*pi*2*.005*f_2);
Gf_DSB = abs(Gf_1) + abs(Gf_2);
figure(6)
plot(f, Gf_DSB)
title('II-1 Coherent Demodulation f = 500Hz')

% II-2
BW = 1400;
fc = 500;
Wc = 2*pi*fc;

t = linspace(0, .04, n);
lpf = fir1(20, B_ess/(fs/2), 'low');
demod = filter(lpf, 1, abs(Gf));
figure(7)
plot(linspace(-fs/2, fs/2, n), demod)
title('II-2 Double Sideband, Suppressed Carrier, f = 500Hz')

