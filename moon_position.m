function r_moon = moon_position(t)
%function r_moon = moon_position(t)

%average of max and min distance between moon and earth 385000 km:
amplitude = 385000 * 1000;  %in meters

%frequency:  R*omega = speed
%omega = speed/R
%omega = (1.023 km/s) / (385000 km) = 2.571e-06 / s
omega = 2.6571e-06;  %in inverse seconds

%assume moon has a circular orbit around the earth
%calculate its position relative to the earth
%x component is given by cos, y component is given by sin
%in meters
r_moon_relative = [amplitude * cos(omega*t)
amplitude * sin(omega*t)];

r_earth = earth_position(t);  %in meters

%the absolute position of the moon is given by adding the position relative to the earth
%to the position of the earth
%in meters
r_moon = r_moon_relative + r_earth;

end


