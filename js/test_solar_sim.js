var logger = log4javascript.getLogger("tsol3dmolLogger");

var secondsPerDay = 24*60*60;


var testEarthMoonPosition = function(divId) {
    logger.debug('testEarthMoonPosition');

    var earthPosX = [];
    var earthPosY = [];
    var moonPosX = [];
    var moonPosY = [];

    for (var t = 0; t < 365*secondsPerDay; t += secondsPerDay) {
        ep = earthPosition(t);
        earthPosX.push(ep[0]);
        earthPosY.push(ep[1]);

        mp = moonPosition(t);
        moonPosX.push(mp[0]);
        moonPosY.push(mp[1]);
    }

    var earthTrace = {x:earthPosX, y:earthPosY, name:'Earth'};
    var moonTrace = {x:moonPosX, y:moonPosY, name:'Moon'};
    var data = [earthTrace, moonTrace];
    Plotly.newPlot(divId, data);
};


var testCalculateForce = function(divId) {
    logger.debug('testCalculateForce');

    var r = [1, 0];
    var rB = [0, 0];

    var inverseGc = 1.0/gravitationalConstant;

    var f = calculateForce(r, rB, inverseGc);
    logger.debug('happy path');
    logger.debug('f: ' + f);
    console.assert(f[1] == 0.0, 'expected y-component of f to be zero');
    console.assert(f[0] < 0.0, 'expected x-component of f to negative (attractice)');

    var data = [];
    for (var i = 0; i < 8; i++) {
        var angle = i * Math.PI / 4;
        var angleDegrees = i * 45;
        r = [Math.cos(angle), Math.sin(angle)];

        f = calculateForce(r, rB, inverseGc/2.0);

        s = numeric.add(r, f);

        var trace = {x:[r[0], s[0]], y:[r[1], s[1]],
            name:("angle: " + angleDegrees), text:["start", "end"]};
        data.push(trace);
    }
    Plotly.newPlot(divId, data);
};


var testCalculateTotalForce = function() {
    logger.debug('testCalculateTotalForce');

    var t =  0;
    var r = earthPosition(t);
    r[0] = r[0] + 1000;

    var f = calculateTotalForce(r, t);
    logger.debug('happy path');
    logger.debug('f: ' + f);
    console.assert(f.length == 2, 'expected force vector to be length 2');
};


var testParticleDifferential = function() {
    logger.debug('testParticleDifferential');

    var t =  0;
    var r = earthPosition(t);
    r[0] = r[0] + 1000;

    var y0 = [2, 3, r[0], r[1]];
    var y = particleDifferential(t, y0);
    logger.debug('happy path:');
    logger.debug('y: ' + y);
    console.assert(y.length == 4, 'expected differential vector to be length 4');
    console.assert(y[0] < 0.0, 'based on initial position expected acceleration in x to be negative');
    console.assert(y[1] == 0.0, 'based on initial position expected acceleration in y to be zero');
    console.assert(y[2] == 2);
    console.assert(y[3] == 3);
};
