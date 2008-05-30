
/**
* Tny, the smallest tweening engine with Sound, Color and delay support 
* I could figure out how to build. Currently 1949 bytes, 
*  If you turn off Sound it's 1871 bytes, if you take out color+ alpha even smaller.
* 
* Note that it's a step/frame based clock instead of a duration based clock, and minimum 1-2 frames accurate, so should not be used for uber-precise time
* tweening, but will garuantee every pulse through the range of time is hit. Presumeably if your looking at uber-small, you're willing to give up a few features.
* In addition since it uses a frame based clock as the number of particles increase, the slower
* the rendering is, and the slower the animation will go, but it won't drop frames.
* 
* That said the 't' property gives the current percent done, which can be polled if necessary to kick off other things.
* 
* 
* Since it extends from Sprite, it shares the same properites:
* 
* x, y, scaleX, scaleY, alpha, width, height, etc.
* 
* ease : the easing function 
* delay : time before starting in seconds
* duration:  time in seconds to ease, 0 = jump instantly, reset duration to start it again.
* color:  the hex value to tint to 0xRRGGBB
* colorP: 0-100; the percentage of tint to apply 10= 10%
* 
* polling t will get you the current percent played, t will be negative if there is a delay.
* 
* onStart: the function to callback when time > 0.
* onStartParams : array e.g. [1,2,3] will call the onStart(1,2,3);
* onComplete: the function to callback when time == d;
* onCompleteParams: array e.g. [1,2,3] will call the onComplete(1,2,3);
* 
* @author Troy Gardner troy@troyworks.com http://www.troyworks.com/tweeny/
* @version 0.1
*/

package com.troyworks.core.tweeny {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.media.SoundTransform;
	import flash.utils.describeType;
	import flash.utils.getTimer;
	public class TnyT extends Sprite{
		
		/* the clip to affect */
		var trg:DisplayObject;
		var isSprite:Boolean = false;
		/* the frames per second of the movie */
		var fps:Number;

		/* easing function */
		public var ease:Function;
		/* prop array */
		static var p:Array;
		
		/* loop iterators */
		var i:int = 0;
		var j:int = 0;
		var k:String;
		
		/* begin */
		var a:Object;
		/* current */
		var c:Object;
		/* end */
		var z:Object;
		
		var _lm:Matrix = new Matrix();
		var _lc:ColorTransform = new ColorTransform();
		var _ls:Object = new SoundTransform();
		
		/* current calc time*/
		var tt:Number = 0;
		/* current time in percent */
		public var t:Number = 0;
		/* time step */
		var ts:Number =0;
		/* duration */
		var d:Number = 0;
		/* delay */
		var dl:Number = 0;
		// getTimer Start
		var st:Number;
		var dd:Number;
		//var fc:Number =0;
		public var quantized:Boolean = false;
		
		public var isActive:Boolean = false;
		public var hasStarted:Boolean = false;
		public var isFinished:Boolean = false;
		
		public var onStart:Function; //The function that should be triggered when this tween has completed
		public var onStartParams:Array; //An array containing the parameters that should be passed to the this.onComplete when this tween has finished.

		public var onComplete:Function; //The function that should be triggered when this tween has completed
		public var onCompleteParams:Array; //An array containing the parameters that should be passed to the this.onComplete when this tween has finished.
		public var colorTransform:ColorTransform = new ColorTransform();
		
		
		public function TnyT(targetD:DisplayObject = null) {
			
			super();
			
			if(p == null){
				p = new Array()
				addVarsOf(new SoundTransform());
				addVarsOf(new ColorTransform());
				addVarsOf( new Matrix());
			//	trace("------------------");
			//	trace("p " + p.join("\r"));
			}
			target = targetD;

		}
	/*  2100 with these on, 1949 with them off.
	 * */
	 public static function to(trg:DisplayObject, dur:Number, propsO:Object):TnyT{
			var tw:TnyT = new TnyT(trg);
			tw.duration = dur;			
			for (var i in propsO) {
				tw[i] = propsO[i];
			}
			return tw;
		}
		public function set props(pObj:Object){
			for (var i in pObj) {
				this[i] = pObj[i];
			}
		}
		public function set color(rgb:Number){
			colorTransform.color = rgb;
		}
		public function set colorP(percent:Number){
			colorTransform.redMultiplier = colorTransform.greenMultiplier = colorTransform.blueMultiplier = 1 - percent/100;
		}
		public function set target(v:DisplayObject){
		
			trg = v;
			
			if(trg == null){
				isFinished = true;
				return;
			}else{
				if(isNaN(fps) && trg.stage != null){
					trg.stage.addEventListener("enterFrame", onPulse);//, false, 0, true);
					fps = trg.stage.frameRate;
				}
			
			//	transform.matrix.identity();
				colorTransform = new ColorTransform();
				soundTransform = new SoundTransform();
				isSprite = trg  is Sprite;
				hasStarted = false;
				isFinished = false;
				isActive = false;
			}
		}
		public function get target():DisplayObject{
			return trg;
		}
		public function set delay(del:Number){
		/*	if(isNaN(del)){
				return;
			}*/
			dl = del * fps;
			t = -dl/d;
		//	trace("delay"  + dl + " " + del + " " + fps);
		}
		/*************************************
		*             |<--- d --->|
		*             |0---------100
		* 1 frame :   [-------------] <- not possible in Tny as it would require two passes in the render loop
		* 2 frames:   [1-----][2----]
		* 3 frames:   [0--][1--][2--];
		*/

		public function set duration(dur:Number){
		/*	if(isNaN(dur)){
				return;
			}*/

			//this will be called every frame
			// so duration will be frames: = dur (in seconds)* fps;
			// increment equals duration/ fps/
			dd = dur *1000;
		//	trace("duration " + dur + " at  " + fps + " fps");
			d = (dur* fps) - 1; // Should be Math.ceil, how many frames it will take to get there
			d = (d< 1)?1:d;
			t = -dl/d;
		//	trace("t " + t + " " + dl + " " + d);
			ts = 1/ (d-1); // points crossed - 1 = steps crossed. ts is a percentage to move.
			st = getTimer() + (dl * 1000);
			isActive = true;
			hasStarted = false;
			isFinished = false;
//			trace("ts " + ts);
		}
		protected function addVarsOf(o:Object):void{
			var x:XMLList =  describeType(o)..variable;
			var item:XML;
			for each(item in x) {
             //   trace("item: " + item.@name);
				if(item.@type =="Number"){
					p.push(item.@name);
				}
            }
			 x=  describeType(o)..accessor;
			 for each(item in x) {
              //  trace("accessor: " + item.@name);
			//	trace ("item.@type" + item.@type);
			//	trace ("item.@access" + item.@access);
				if(item.@access=="readwrite" && item.@type =="Number"){
					p.push(item.@name);
				}
            }
		}
		/*******************************************
		 *  The primary render loop
		 *  not that the start and finish can be called back in
		 * the same pulse when there is a zero duration.
		 * **/
		public function onPulse(evt:Object = null):void{
		//	trace("pulse-----------");
			if(!isActive || isFinished || (trg == null)){
			//	trace(" invalid ");
				return;
			}
			t = (getTimer() - st)/dd;
			//trace(trg.name +" w "+ t);
			j = p.length;
			
			if(t < 0){
			//	trace(trg.name +" wait  ----- "+ t);
				t+=ts;
				return;
			}else if(t >= 0 && !hasStarted){
				//start
				if(quantized){
					t = 0;
				}
				hasStarted = true;
				
			//	fc =0;
		//	trace("starting " + trg.name + " " + st);
				if (onStart != null) {
					//	trace("calling onStart");
					onStart.apply(null, onStartParams);
				}
			}
			/////////////////////
						
//trace(" t " + t + " " + dd);
			if(t >= 1|| d == 0){
				// finished
				t = 1;
			}
	//		fc++;
		//trace(trg.name +" active "+ t + "% " + d );
	//	trace(trg.name +" active "+ t + "% " + d + " frame: " + fc + " " + + (getTimer() - st));
			tt = ease(t, 0, 1, 1);
			
			while(--j > -1){
				k = p[j];
			//	trace(j + " = " + k);
				/////////// SETUP /////////////
				if(j == 19){
			//		trace("setting up Matrix");
					c = _lm;
					a = trg.transform.matrix;
					z = this.transform.matrix;
				}else if(j == 13){
				//	trace("setting up ColorTransform");
					c = _lc;
					a = trg.transform.colorTransform;
					z = colorTransform;
					z.alphaMultiplier = colorTransform.alphaMultiplier;
					z.alphaOffset = colorTransform.alphaOffset;
				} else if(j<= 5 && !isSprite){
					//skip sound
					//trace("skipping sound");
						t+=ts;
					return;
				}else if(j == 5  && isSprite){
				//	trace("setting up SoundTransform");
					c = _ls;
					a = Sprite(trg).soundTransform;
					z = this.soundTransform;			
				}
				/////////// CALC //////////////
				//C = A + (D*t);
				c[k] = a[k] + ((z[k] - a[k])*tt);
				/////////// FINISH ////////////
				if(j == 14){
				//	trace("finishing Matrix");
					_lm = trg.transform.matrix;
					trg.transform.matrix = c as Matrix;
				}else if(j ==6){
			//	trace("finishing ColorTransform----------");
					_lc = trg.transform.colorTransform;
					trg.transform.colorTransform = c as ColorTransform;
				}else if( j == 0 && isSprite){
			//		trace("finishing SoundTranform----------");
					_ls = Sprite(trg).soundTransform;
					Sprite(trg).soundTransform = c as SoundTransform;
				}
				
			}
			if(t >= 1 || d == 0){
		//	trace("finished " + trg.name  + " in " + (getTimer() - st));
				isFinished = true;
				isActive = false;
				if (onComplete != null) {
				//	trace("calling onComplete " + onComplete + " " + onCompleteParams);
					onComplete.apply(null, onCompleteParams);
				}
				return;
			}
			t+=ts;

		}
	}
	
}