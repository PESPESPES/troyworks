// a utility to help construct, add, vectors together.
vect2d = function (x, y) {
	this.x = x;
	this.y = y;
};
vect2d.prototype.addV = function(vect) {
	return new vect2d((this.x+vect.x), (this.y+vect.y));
};
vect2d.prototype.subtractV = function(vect) {
	return new vect2d((this.x-vect.x), (this.y-vect.y));
};
vect2d.prototype.length = function() {
	return Math.sqrt((this.x*this.x)+(this.y*this.y));
};
vect2d.prototype.normalize = function() {
	this.scale(1/this.length());
};
vect2d.prototype.dot = function(vector) {
	return (this.x*vector.x)+(this.y*vector.y);
};
vect2d.prototype.scale = function(scaleFactor) {
	this.x *= scaleFactor;
	this.y *= scaleFactor;
};
vect2d.prototype.divideV = function(divFact) {
	this.x /= divFact;
	this.y /= divFact;
};
vect2d.prototype.getDirection = function() {
	//return in degrees instead of radians
	return (Math.atan2(this.y, this.x))*(180/Math.PI);
};
vect2d.prototype.invert = function() {
	//revese direction (for braking, bouncing and fleeing behavior)
	//return new vect2d( -this.x, -this.y);
	this.x = -this.x;
	this.y = -this.y;
};
vect2d.prototype.truncate = function(max) {
	if (this.length()>max) {
		this.scale(max/this.length());
	} else {
		//do nothing.
	}
};