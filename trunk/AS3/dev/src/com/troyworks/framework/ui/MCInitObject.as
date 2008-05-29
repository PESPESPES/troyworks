package com.troyworks.framework.ui { 
	/**
	 * @author Troy Gardner
	 */
	public class MCInitObject {
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public function MCInitObject() {
			x = y = width = height = 0;
		}
		public function setTL(tl:Object):void{
			x = tl.x;
			y = tl.y;
		}
		public function setBR(br:Object):void{
			width = br.x - x;
			height = br.y - y;
		}
		public function setBounds(tl:Object, br:Object):void{
			setTL(tl);
			setBR(br);
		}
		
	}
}