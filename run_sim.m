clear

earth_radius = 6371000;  % in meters

%set the initial position of the rocket to be on the surface of the earth
r0 = earth_position(0);  %this sets it to be at the center of the earth
r0(1) = r0(1) + earth_radius;  %offset by the radius of the earth in the position x direction

%specify initial conditions
%hit the moon:
%s0 = 12000;  %initial speed in meters/second
%theta=8.24*pi/180;  %initial angle with respect to positive x direction.  in radians
%tspan = [0 40e4];  %time to run calculation for - in seconds

%moon hits the rocket
%s0 = 11100;
%theta=25*pi/180;
%tspan = [0 40e4];

%affected by gravity of moon, returns near earth
s0 = 11103;
theta=25*pi/180;
tspan = [0 360*24*3600];

%dump trash into the sun
%s0 = 29.78e3;
%theta = -90*pi/180;
%tspan = [0 90*24*3600];
%r0(1) = r0(1) + 100000;


%note y0(1) is velocity in x direction (in meters/second)
%y0(2) is velocity in the y direction - this is set to match the earth's velocity in y-direction at t=0  (in meters/second)
%	plus the initial velocity of the rocket in the y-direction\
%y0(3) is the initial position on the x-axis (in meters)
%y0(4) is the initial position on the y-axis (in meters)
y0 = [s0*cos(theta) 
(29.78e3 + s0*sin(theta))
r0(1)
r0(2)];

%run the simulation
[tout, yout] = solve_rocket(y0, tspan);


%extract the trajectory of the rocket
R(:,1) = yout(:,3) + r0(1);
R(:,2) = yout(:,4) + r0(2);


%calculate the position of the earth and the moon for each time in the simulation
for ind = 1:length(tout)
	R_earth(ind, :) = earth_position(tout(ind))';
	R_moon(ind, :) = moon_position(tout(ind))';
end


%calculate the relative position of the rocket and the moon
rel_moon = R - R_moon;
%calculate the relative distance between the rocket and the moon
dist_moon = sqrt(sum(rel_moon.^2'));


%figure(1)
%plot(tout, yout(:,1), '.')
%figure(2)
%plot(tout, yout(:,2), '.')
%figure(3)
%plot(tout, yout(:,3), '.')
%figure(4)
%plot(tout, yout(:,4), '.')

%plot the position of the earth, the moon and the rocket
figure(5)
clf
hold on
plot(R(:,1), R(:,2), '.')
plot(R_earth(:,1), R_earth(:,2), 'g')
plot(R_moon(:,1), R_moon(:,2), 'k')


%plot the relative position of the rocket and the moon
figure(6)
plot(rel_moon(:,1), rel_moon(:,2), '.')


%plot the distance between the rocket and the moon as a function of time
figure(7)
plot(tout, dist_moon, '.')


%find the minimum distance between the rocket and the moon and the index of the time it occurred at
[min_moon, t_min] = min(dist_moon)

