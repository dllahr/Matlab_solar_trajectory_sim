
/*
expects numeric.js
expects log4javascript.js
*/

var logger = log4javascript.getLogger("tsol3dmolLogger");

var massSun = 1989100000e21;  //kg
var massEarth = 5973.6e21;  //kg
var massMoon = 73.5e21; //kg
var gravitationalConstant = 6.674e-11; //m^3 / (kg * s^2)


var earthPosition = function(t) {
    //absolute position of the earth using fixed, simple orbit
    //t in seconds, returns array length 2 of position in units of meters

    //average of max and min distance between earth and sun:
    //(152098232 + 147098290)/2 = 149598261 km
    var amplitude = 149598261 * 1000;  //in meters

    //frequency:  R*omega = speed
    //omega = speed/R
    //omega = (29.78 km/s) / (149598261 km) = 1.9907e-07 / s
    var omega = 1.9907e-07;  //in inverse seconds


    //assume earth has a ciruclar orbit
    //x component is specified by cos, y component is specified by sin
    //units in meters
    var rEarth = [amplitude * Math.cos(omega*t), amplitude * Math.sin(omega*t)];

    return rEarth;
};


var moonPosition = function(t) {
    //absolute position of the moon, using fixed, simple orbit
    //t in seconds, returns array of length 2 of position in units of meters

    //average of max and min distance between moon and earth 385000 km:
    var amplitude = 385000 * 1000;  //in meters

    //frequency:  R*omega = speed
    //omega = speed/R
    //omega = (1.023 km/s) / (385000 km) = 2.571e-06 / s
    var omega = 2.6571e-06;  //in inverse seconds

    //assume moon has a circular orbit around the earth
    //calculate its position relative to the earth
    //x component is given by cos, y component is given by sin
    //in meters
    var rMoonRelative = [amplitude * Math.cos(omega*t), amplitude * Math.sin(omega*t)];

    var rEarth = earthPosition(t);  //in meters

    //the absolute position of the moon is given by adding the position relative to the earth
    //to the position of the earth
    //in meters
    var rMoon = numeric.add(rMoonRelative,  rEarth);

    return rMoon;
};


var calculateForce = function(position, bodyPosition, bodyMass) {
    //relative position
    var r = numeric.sub(bodyPosition, position);
    logger.trace("calculateForce r:  " + r);

    var distance = Math.sqrt(numeric.dot(r, r));
    logger.trace("calculateForce distance:  " + distance);

    var rNormalized = numeric.div(r, distance);
    logger.trace("calculateForce rNormalized:  " + rNormalized);

    var coef = gravitationalConstant * bodyMass / (distance * distance);
    var f = numeric.mul(rNormalized, coef);

    return f;
}


var calculateTotalForce = function(r, t) {
    var forceMoon = calculateForce(r, moonPosition(t), massMoon);

    var forceEarth = calculateForce(r, earthPosition(t), massEarth);

    var forceSun = calculateForce(r, [0,0], massSun);

    var forceTotal = numeric.add(forceMoon, forceEarth, forceSun);

    return forceTotal;
}


var particleDifferential = function(t, y) {
    //calculate the differential change in position and velocity of a particle in
    //the solar system, based on the current time and position and velocity
    //t:  time
    //y:  array of velocity and position
    //      y[0]:  dx
    //      y[1]:  dy
    //      y[2]:  x
    //      y[3]:  y

    //position
    var r = [y[2], y[3]];

    var forceTotal = calculateTotalForce(r, t);

    //dy is the change in y
    var dy = [forceTotal[0], //change in velocity in x is the force in the x direction
        forceTotal[1], //change in velocity in y is the force in the y direction
        y[0], //change in position in x is the velocity in x
        y[1]];  //change in position in y is the velocity in y

    return dy;
}
