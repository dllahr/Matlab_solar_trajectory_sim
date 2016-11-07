function y_prime = rocket(t, y)
%function y_prime = rocket(t, y)

mass_sun = 1989100000e21;
mass_earth = 5973.6e21;
mass_moon = 73.5e21;
G = 6.674e-11;

r = y(3:4);

r_moon = moon_position(t) - r;
dist_moon = sqrt(r_moon' * r_moon);
r_norm_moon = r_moon / dist_moon;
f_moon = r_norm_moon * G * mass_moon / (dist_moon^2);

r_earth = earth_position(t) - r;
dist_earth = sqrt(r_earth' * r_earth);
r_norm_earth = r_earth / dist_earth;
f_earth = r_norm_earth * G * mass_earth / (dist_earth^2);

r_sun = -r;
dist_sun = sqrt(r_sun' * r_sun);
r_norm_sun = r_sun / dist_sun;
f_sun = r_norm_sun * G * mass_sun / (dist_sun^2);

y_prime(1:2, 1) = f_moon + f_earth + f_sun;
y_prime(3:4, 1) = y(1:2);

end

