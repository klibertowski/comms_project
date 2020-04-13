g1 = @(t) (1000*t - 2).^2;
g2 = @(t) (-5000*t + 22).^2;
g3 = @(t) (3000*t - 18).^2;

E_total = integral(g1, .002, .004) + integral(g2, .004, .005) + integral(g3, .005, .006)

t = 0:.00001:.006;
% gt = @(t) abs((2*tripuls(t - .004, .004) - 4*tripuls(t - .005, .002))).^2;
gt = 2*tripuls(t - .004, .004) - 4*tripuls(t - .005, .002);

plot(t, gt)
% E_total = integral(gt, 0, .006)

Gf_sq = @(f) abs((-.004*sinc((pi*.002*f)/2).^2 .* exp(-1i*pi*5*f)).^2);

E_ess = 0;
B_step = 10;
B_ess = B_step;

format long

while E_ess < .99*E_total
    B_ess = B_ess + B_step;
    E_ess = integral(Gf_sq, -B_ess, B_ess)
end

% test = abs(integral(Gf, 1, 3))

% f = -2:.001:2;
% Gf = (.004*sinc((pi*.004*f)/2).^2 .* exp(-1i*2*pi*f) + -.004*sinc((pi*.002*f)/2).^2 .* exp(-1i*pi*5*f)).^2;
% Gf = (.004*sinc((pi*.004*f)/2).^2 .* exp(-1i*2*pi*f) + -.004*sinc((pi*.002*f)/2).^2 .* exp(-1i*pi*5*f)).^2;
% 
% plot(f, Gf)
