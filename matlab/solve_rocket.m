function [TOUT, YOUT] = solve_rocket(y0, tspan)
%function [TOUT, YOUT] = solve_rocket(y0, tspan)

%y0(1) is the velocity in the x-axis
%y0(2) is the velocity in the y-axis
%y0(3) is the position on the x-axis
%y0(4) is the position on the y-axis

mass_sun = 1989100000e21;  % in kg
mass_earth = 5973.6e21;  % in kg
mass_moon = 73.5e21;  % in kg
G = 6.674e-11;  % in N (meters^2 / kg^2)

earth_radius = 6371000;  % in meters
moon_radius = 1731100;  % in meters
sun_radius = 696000000;  % in meters

%the initial position of the rocket in the solar frame of reference
r0 = y0(3:4);

%set the initial position to be zero so that we run the calculation relative to
%the initial position of the rocket
y0(3:4) = [0
0];


%use this function to calculate the derivative at any time of the velocity and position of the rocket
%	based on the time (t) and current velocity and position of the rocket
%
%	y_prime(1) is the time derivative of the velocity in the x-axis (== the acceleration in x)  (in meters / second^2) 
%	y_prime(2) is the time derivative of the velocity in the y-axis (== the acceleration in y)  (in meters / second^2)
%	y_prime(3) is the time derivative of the position in the x-axis (== the velocity in x)  (in meters / second)
%	y_prime(4) is the time derivative of the position in the y-axis (== the velocity in y)  (in meters / second)
function y_prime = rocket(t, y)
	%position of the rocket relative to its initial position
	r = y(3:4);

	%position of the rocket in the solar frame of reference
	r_solar = r + r0;

	%position of the rocket relative to the moon
	r_moon = moon_position(t) - r_solar;
	%distance between the rocket and the moon
	dist_moon = sqrt(r_moon' * r_moon);

	%position of the rocket relative to the earth
	r_earth = earth_position(t) - r_solar;
	%distance between the rocket and the earth
	dist_earth = sqrt(r_earth' * r_earth);

	%position of the rocket relative to the sun
	r_sun = -r_solar;
	dist_sun = sqrt(r_sun' * r_sun);

	if dist_earth <= earth_radius  %check for collision with the earth
		params = earth_all(t);
		y_prime = params(1:4);
	elseif dist_moon <= moon_radius %check for collision with the moon
		params = moon_all(t);
		y_prime = params(1:4);
	elseif dist_sun <= sun_radius  %check for collision with the sun
		y_prime = [0 0 0 0]';
	else
		%calcualte the acceleration on the rocket due to the moon
		r_norm_moon = r_moon / dist_moon;
	        a_moon = r_norm_moon * G * mass_moon / (dist_moon^2);

		%calculate the acceleration on the rocket due to the earth
		r_norm_earth = r_earth / dist_earth;
	        a_earth = r_norm_earth * G * mass_earth / (dist_earth^2);

		%calculate the acceleration on the rocket due to the sun
		r_norm_sun = r_sun / dist_sun;
		a_sun = r_norm_sun * G * mass_sun / (dist_sun^2);

		%the derivative of the velocity is the sum of all the accelerations
		y_prime(1:2, 1) = a_moon + a_earth + a_sun;
		%the derviative of the position is the velocity
		y_prime(3:4, 1) = y(1:2);
	end
end


%solve the differential equation
[TOUT, YOUT] = ode45(@rocket, tspan, y0);

end

