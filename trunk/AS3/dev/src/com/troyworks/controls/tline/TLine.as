package com.troyworks.controls.tline {
	import flash.display.DisplayObjectContainer;	
	import flash.display.Graphics;	
	import flash.utils.Proxy;	
	import flash.utils.flash_proxy;	
	import flash.geom.Point;	
	import flash.display.Sprite;
	
	/**
	 * TLine
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Nov 3, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class TLine extends Proxy {
		//public var
		public var p1:Point = new Point(0,0);
		public var p2 : Point = new Point(200, 200);
		public var off : Point = new Point(0,0);
		public var outlineSize : Number = 1;
		public var a : Number = 1;
		public var c : uint = 0xFF0000;
		public var shape:Sprite;
		public var spacing:Number = 1;
		public var graphics : Graphics;

		public function TLine(view : DisplayObjectContainer) {
			trace("Tline " + view);
			shape = new Sprite();
			view.addChild(shape);
			draw();
		}
		public function draw():void{
			trace("draw...");
			shape.graphics.clear();
			
			shape.graphics.lineStyle(outlineSize, c, a);
			shape.graphics.moveTo(p1.x * spacing + off.x, p1.y * spacing + off.y);
			shape.graphics.lineTo(p2.x * spacing + off.x, p2.y * spacing + off.y);
		}
		flash_proxy override function hasProperty(name:*):Boolean{
			//shape.graphics.
			return true;
		}
	}
}
