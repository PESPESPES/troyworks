package com.troyworks.ui { 
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class LayoutAnchor extends MovieClip {
		public var iAmAPlaceholder:Boolean = true;
		public var depth2:Number;
		public function LayoutAnchor() {
			super();
		}
		public function onLoad():void{
		
			visible = false;
			setDepth();
		}
		public function setDepth():Number{
					var a:Number = String(this.name).indexOf("ph");
			var b:Number = String(this.name).indexOf("_");
			depth2 = parseInt(String(this.name).substring(a+2, a+2+b))+ 24;
			trace("LayoutAnchor " +depth2);
			return depth2;
		}
		public function getXYPosition():MCInitObject{
			var p:MCInitObject = new MCInitObject();
			p.x = x;
			p.y = y;
			return p;
		}
		public function getXYWHPosition():MCInitObject{
			var p:MCInitObject = new MCInitObject();
			p.x = x;
			p.y = y;
			p.width = width;
			p.height = height;
			return p;
		}
		
	}
}