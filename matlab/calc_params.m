function params = calc_params(amplitude, omega, t)
%function params = calc_params(amplitude, omega, t)

params(1:2,1) = -amplitude * (omega^2) * [cos(omega*t)
sin(omega*t)];

params(3:4,1) = amplitude * omega * [-sin(omega*t)
cos(omega*t)];

params(5:6,1) = amplitude * [cos(omega*t)
sin(omega*t)];

end


