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
E_gt = integral(g1, .002, .004) + integral(g2, .004, .005) + integral(g3, .005, .006)

% g(t)^2
gt_sq = @(t) abs((2*tripuls(t - .004, .004) - 4*tripuls(t - .005, .002))).^2;

% Plot of g(t)
t = 0:.000001:.006;
gt = 2*tripuls(t - .004, .004) - 4*tripuls(t - .005, .002);
plot(t, gt)

% Energy from triangular pulse waveform
E_tripuls = integral(gt_sq, 0, .006)

% G(f)^2
Gf_sq = @(f) abs((.004*sinc((pi*.004*f)/2).^2 .* exp(-1i*pi*2*f) - .004*sinc((pi*.002*f)/2).^2 .* exp(-1i*pi*5*f)).^2);

% Setup for while loop
E_ess = 0;
B_step = 10;
B_ess = B_step;

format long

while E_ess < .99*E_eq
    B_ess = B_ess + B_step;
    E_ess = integral(Gf_sq, -B_ess, B_ess)
end