package  { 
	MovieClip.prototype.getRandomColor = function() {
	import flash.display.MovieClip;
		endColor = "0x";
		for (j == 0; j<6; j++) {
			c = Math.round(Math.random()*16);
			if (c>=0 && c<=9) {
				// c=c
			} else if (c == 10) {
				c = "a";
			} else if (c == 11) {
				c = "b";
			} else if (c == 12) {
				c = "c";
			} else if (c == 13) {
				c = "d";
			} else if (c == 14) {
				c = "e";
			} else if (c == 15) {
				c = "f";
			} else if (c == 16) {
				c = "g";
			}
			endColor = endColor add c;
		}
		trace("color " add endColor);
		j = 0;
		return endColor;
	};
}