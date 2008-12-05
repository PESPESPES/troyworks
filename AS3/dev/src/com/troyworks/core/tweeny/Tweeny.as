/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core.tweeny {
	import flash.display.*;	
	public class Tweeny extends Teeny{
		
		//tmp holders
		var dx:Number = 0;
		var dy:Number = 0;
		//var dw:Number = 0;
		//var dh:Number = 0;
		var dsY:Number = 0;
		var dsX:Number = 0;
		var dR:Number = 0;
		
		
		public function Tweeny() {
				super();
		}
	/*	public function set shadow(dObj:DisplayObject):void{
			$s = dObj;
		}*/
		public function get totalTime():Number{
			return dur + _delay;
		}	
		public function toString():String{
			trace(-_delay + "> " + 0+ "( " + ct + " )" + dur);
			return null;
		}		
		
		//---------------- setters -------------------
		// you can comment these out if your driving the animator
		// via Matrix Snapshots.
		public function set x(end) {
		//	trace("end " + end + " cx " + $v.x);
			dx = (end -$v.x);
//			setMz(dx);
		//	trace("setX " +dx);
	//		$s.x = end;
			F |= 2;
		}
		public function set y(end) {
			dy = (end -$v.y);
	//		setMz(0,dy);
		//	trace("setY " +dy);
	//		$s.y = end;
			F |= 2;
		}
		public function set scaleX(end) {
			dsX = (end-$v.scaleX);
	//	setMz(0, 0, dsX);
	//		trace("scaleX  " + dx);
	//		$s.scaleX = end;
			F |= 2;
		}
		public function set scaleY(end) {
			dsY = (end-$v.scaleY);
	//		setMz(0, 0, 0, dy);
	//		trace("scaleY " + dy);
	//		$s.scaleY = end;
			F |= 2;
		}

		public function set width(end) {
		
		//	trace("setWidth " + end + " change: " + (end-$vB.width));
			var cw:Number = ($vB.width * $v.scaleX);
			dsX = ((end- cw) /cw);
			//setMz(0, 0, dw);
	//		$s.width = end;
			F |= 2;
		}
		public function set height(end) {

		//	trace("setHeight " + end + " change: " + (end-$vB.height));
			var ch:Number = ($vB.height * $v.scaleY);
			dsY = ((end- ch) /ch);
//			setMz(0, 0, 0, dsY);
	//		$s.height = end;
			F |= 2;
		}
		public function set rotation(end) {
			dR = end - $v.rotation;
//			setMz(0, 0, 0, 0, dr);
		//	trace("setRotation to " + end  + " " + $v.rotation + " " +  dr);
	//		$s.rotation = end;
			F |= 2;
		}
		override public function onSetupTween(){
			if (F & 2) {
			//	trace("- matrixEase");
				setMz(dx, dy, dsX,dsY, dR);
			}
			if(F & 16){
				setupEaseColor();
			}
		}
		//////// ---------------- COLOR --------------------
		function setupEaseColor(){
			ctA	=	$v.transform.colorTransform;
			ctD.redMultiplier = (ctZ.redMultiplier - ctA.redMultiplier);
			ctD.greenMultiplier = (ctZ.greenMultiplier - ctA.greenMultiplier);
			ctD.blueMultiplier = (ctZ.blueMultiplier - ctA.blueMultiplier);
			ctD.alphaMultiplier = (ctZ.alphaMultiplier - ctA.alphaMultiplier);
			
			ctD.redOffset = (ctZ.redOffset - ctA.redOffset);
			ctD.greenOffset = (ctZ.greenOffset - ctA.greenOffset);
			ctD.blueOffset = (ctZ.blueOffset - ctA.blueOffset);
			ctD.alphaOffset = (ctZ.alphaOffset - ctA.alphaOffset);
		}
		public function set color (rgbHex:Number){
			ctZ.alphaMultiplier = $v.transform.colorTransform.alphaMultiplier;
			ctZ.alphaOffset = $v.transform.colorTransform.alphaOffset;
			ctZ.color = rgbHex;
			F |= 16;
		}
		//////////////   SOUND ------------------------
		public function set volume(end:Number):void{
			if(soundChannel != null){
				volumeChange= end -soundChannel.soundTransform.volume;
			}else if($v is Sprite){
				//only Sprites have soundTransform
				volumeChange = end - Sprite($v).soundTransform.volume;
			}
			F |= 8;
		}
		public function set pan(end:Number):void{
			if(soundChannel != null){
				panChange= end -soundChannel.soundTransform.pan;
			}else if($v is Sprite){
				//only Sprites have soundTransform
				panChange = end - Sprite($v).soundTransform.pan;
			}
			F |= 8;
		}
	}
	
}
