package com.troyworks.commandexample.shapes {

	import flash.display.Shape;

	public class Rectangle extends Shape {
		
		public function Rectangle(color:uint, side:Number) {
			graphics.lineStyle();
			graphics.beginFill(color, 1);
			graphics.drawRect(-side / 2, -side / 2, side, side);
			graphics.endFill();
		}
		
	}
}