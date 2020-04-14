g1 = @(t) (1000*t - 2).^2;
g2 = @(t) (-5000*t + 22).^2;
g3 = @(t) (3000*t - 18).^2;

E_eq = integral(g1, .002, .004) + integral(g2, .004, .005) + integral(g3, .005, .006);

gt_sq = @(t) abs((2*tripuls(t - .004, .004) - 4*tripuls(t - .005, .002))).^2;
E_tripuls = integral(gt_sq, 0, .006);

Gf_sq = @(f) abs((.004*sinc((pi*.004*f)/2).^2 .* exp(-1i*pi*2*f) - .004*sinc((pi*.002*f)/2).^2 .* exp(-1i*pi*5*f)).^2);

E_ess = 0;
B_step = 10;
B_ess = B_step;

format long

while E_ess < .99*E_eq
    B_ess = B_ess + B_step;
    E_ess = integral(Gf_sq, -B_ess, B_ess)
end
