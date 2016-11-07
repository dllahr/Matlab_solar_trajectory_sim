function params = moon_all(t)
%function r_moon = moon_position(t)

%average of max and min distance between moon and earth 385000 km:
amplitude = 385000 * 1000;

%frequency:  R*omega = speed
%omega = speed/R
%omega = (1.023 km/s) / (385000 km) = 2.571e-06 / s
omega = 2.6571e-06;

params_rel = calc_params(amplitude, omega, t);

params_earth = earth_all(t);

params = params_rel + params_earth;

end


