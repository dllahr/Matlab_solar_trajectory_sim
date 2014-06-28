function [TOUT, YOUT] = solve_just_earth(y0, tspan)
%function [TOUT, YOUT] = solve_just_earth(y0, tspan)

%mass_sun = 1989100000e21;
mass_earth = 5973.6e21;
%mass_moon = 73.5e21;
G = 6.674e-11;


function y_prime = rocket(t, y)
	r = y(3:4);
	dist = sqrt(r' * r);
	r_norm = r / dist;
	a = -r_norm * G * mass_earth / (dist^2);

	y_prime(1:2, 1) = a;
	y_prime(3:4, 1) = y(1:2);
end


[TOUT, YOUT] = ode45(@rocket, tspan, y0);

end

