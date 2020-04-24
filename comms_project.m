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

n = 100000;
f = linspace(0, BW, n);
Gf_fft = fft(gt, n);
figure(1)
plot(f, abs(Gf_fft));

% subplot(2,1,1)

Gf = .004*sinc((.004*f)/2).^2 .* exp(-1i*pi*2*f*.004) - .004*sinc((.002*f)/2).^2 .* exp(-1i*pi*2*.005*f);
figure(2)
plot(f, abs(Gf))
% subplot(2,1,2)

legend('show')

% I-4
gt_sq_int = @(t) abs(2*tripuls(t - .004, .004) - 4*tripuls(t - .005, .002)).^2;
E_gt = integral(gt_sq_int, 0, 1)

Gf_sq_int = @(f) abs((.004*sinc((.004*f)/2).^2 .* exp(-1i*pi*2*f*.004) - .004*sinc((.002*f)/2).^2 .* exp(-1i*pi*2*f*.005)).^2);
E_gf = integral(Gf_sq_int, -1000000, 1000000)

% I-5
G_xcorr = xcorr(Gf);
figure(3)
plot(linspace(-1000, 1000, length(G_xcorr)), G_xcorr)

G_ESD = abs(Gf).^2;
figure(4)
plot(f, G_ESD)

% II-1


