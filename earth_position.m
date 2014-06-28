function r_earth = earth_position(t)
%function r_earth = earth_position(t)

%average of max and min distance between earth and sun:
%(152098232 + 147098290)/2 = 149598261 km
amplitude = 149598261 * 1000;  %in meters

%frequency:  R*omega = speed
%omega = speed/R
%omega = (29.78 km/s) / (149598261 km) = 1.9907e-07 / s
omega = 1.9907e-07;  %in inverse seconds


%assume earth has a ciruclar orbit
%x component is specified by cos, y component is specified by sin
%units in meters
r_earth = [amplitude * cos(omega*t) 
amplitude * sin(omega*t)];

end


