var terrain, terrainScale, terrainBase, shipX, shipY, shipXVel, shipYVel, gravity, thrust, fuel, fuelMeter, displayFlames, flightData, onGround, justCrashed;

function setup() {
	createCanvas(window.innerWidth, window.innerHeight);

	terrain = [];
	terrainScale = height / 8;
	terrainBase = height / 6;
	for (var i = 0, max = 10.0, increment = max / width; i < max; i += increment) {
		terrain.push(noise(i) * terrainScale + terrainBase);
	}

	shipX = width / 2;
	shipY = 20;
	shipXVel = 0;
	shipYVel = 0;

	gravity = height / 5000;
	thrust = gravity * 2;

	fuel = 1.0;
	fuelMeter = document.getElementById("fuel");

	flightData = document.getElementById("flight-data");

	onGround = false;
	justCrashed = false;
}

function displayShip(x, y, enginesOn) {
	var xSize = 10;
	var ySize = 10;
	var flameHeight = 5;

	fill(255);

	rect(x - xSize / 2, y, xSize, -ySize); // We want the rect to be drawn with the supplied x as the middle and supplied y as the bottom.

	if (enginesOn) {
		fill(255, 127, 0);

		triangle(x - xSize / 2, y, x - xSize / 4, y + flameHeight, x, y);
		triangle(x, y, x + xSize / 4, y + flameHeight, x + xSize / 2, y);
	}
}

function withFuel(fun) {
	if (fuel > 0) {
			fun();
			
			fuel -= 0.003;

			displayFlames = true;
	}
}

function sumXYVelocities(xv, yv) {
	// Uses Pythagoras' theorem to calculate the sum of velocities with a 90 degree angle between them.
	return Math.sqrt(xv * xv + yv * yv)
}

// Computes a point on a circle with specified radius and specified angle (in RADIANS)
function pointOnCircumference(radius, angle) {
	var x = Math.cos(angle) * radius;
	var y = Math.sin(angle) * radius;
}

function difference(x, y) {
	return Math.abs(x - y);
}

function degreesToRadians(x) {
	return x * (Math.pi / 180);
}

function crater(x, velocity) {
	var craterSize = velocity * 10;

	for (var angle = 90; angle < 270; angle += 10) {

	}
}

function draw() {
	displayFlames = false;

	background(0);

	noStroke();

	shipY += shipYVel;
	shipX += shipXVel;

	flightData.innerText = "Velocity: " + sumXYVelocities(shipXVel, shipYVel).toString().substr(0, 5); // Output velocity to flight-data display

	// Handle keypresses and mouse clicks.
	if (keyIsDown(UP_ARROW) || mouseIsPressed || keyIsDown(32)) { // if spacebar pressed, up pressed or mouse down
		withFuel(function() {
			shipYVel -= thrust;
		});
	}

	if (keyIsDown(LEFT_ARROW)) {
		withFuel(function() {
			shipXVel -= thrust;
		});
	}

	if (keyIsDown(RIGHT_ARROW)) {
		withFuel(function() {
			shipXVel += thrust;
		});
	}

	displayShip(shipX, shipY, displayFlames);

	// In p5js higher y values are further down.
	// This means that to get height above terrain
	var heightAboveTerrain = shipY - (height - terrain[Math.round(shipX)]);

	if (heightAboveTerrain < 0) {
		onGround = false;
		shipYVel += gravity;
	} else if (justCrashed) {
		justCrashed = false;

		crater(shipX, sumXYVelocities(shipXVel, shipYVel));
	} else {
		if (!onGround) {
			justCrashed = true;
		}

		onGround = true;
		shipY = height - terrain[Math.round(shipX)];
		// Instead of immediately stopping on impact we make the ship gradually slow down.
		shipYVel /= 2;
		shipXVel /= 1.1;
	}

	for (var i = 0; i < width; i++) {
		var terrainHere = terrain[i];
	
		fill(120)

		rect(i, height, 1, -terrainHere);
	}

	fuelMeter.value = fuel;
	fuelMeter.innerText = "Fuel: " + fuel.toString().substr(0, 4);
}
