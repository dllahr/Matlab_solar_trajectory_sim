function params = earth_all(t)
%function r_earth = earth_position(t)

%average of max and min distance between earth and sun:
%(152098232 + 147098290)/2 = 149598261 km
amplitude = 149598261 * 1000;

%frequency:  R*omega = speed
%omega = speed/R
%omega = (29.78 km/s) / (149598261 km) = 1.9907e-07 / s
omega = 1.9907e-07;

params = calc_params(amplitude, omega, t);

end


