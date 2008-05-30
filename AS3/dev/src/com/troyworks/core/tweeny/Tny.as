
/**
* Tny, the smallest tweening engine with Sound, Color and delay support 
* I could figure out how to build. Currently 1871 bytes- 2186 bytes depending on what's commented on/off
* 
* Note that it's a step/frame based clock instead of a duration based clock, and minimum 1-2 frames accurate, so should not be used for uber-precise time
* tweening, and that if the fps of the player is at 30 fps and it takes 1 second duration, that 30 frames will be rendered
* regardlesss if it takes longer.but will garuantee every pulse through the range of time is hit. Presumeably if your looking at uber-small, you're willing to give up a few features.
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
* @version 1.0
*/

package com.troyworks.core.tweeny {
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.media.SoundTransform;
	import flash.utils.describeType;
	import flash.utils.getTimer;
	
	public class Tny extends Sprite{
		
		/* the clip to affect */
		var trg:DisplayObject;
		var isSprite:Boolean = false;
		/* the frames per second of the movie */
		var fps:Number;

		/* easing function */
		public var ease:Function = Linear.easeIn;
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
		var _ls:SoundTransform= new SoundTransform();

		var _am:Matrix = new Matrix();
		var _ac:ColorTransform = new ColorTransform();
		var _as:SoundTransform = new SoundTransform();
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
		var fc:Number =0;
		//frame duration in millisecondes
		var fd:Number =0;
		/* 
		 * ensure that 0 and 1 are hit, but nothing below or above 
		 * sometimes important for logging and collision detection 
		 * 
		 * */
		//public var quantized:Boolean = false;
		/* since this is a frame based clock, animations by default
		 * lock step say 0,1,2,3,4,5 when many are on the screen with identical duration
		 * and the intended look is not meant to be like ripples
		 * turn lockstep off and a random variation per step will be added 
		 * eg. lockstop ON
		 *  a)  |  |  |  | 
		 *  b)  |  |  |  |
		 *  c)  |  |  |  | 
		 *   
		 * lockstep OFF
		 *  a)   |  |  |  | 
		 *  b)  |  |  |  |
		 *  c)    |  |  |  | 
		 * * */
		public var lockStep:Boolean = false;
		
		/* active is longer than start and finish */
		public var isActive:Boolean = false;
		public var hasStarted:Boolean = false;
		public var isFinished:Boolean = false;
		
		public var onStart:Function; //The function that should be triggered when this tween has completed
		public var onStartParams:Array; //An array containing the parameters that should be passed to the this.onComplete when this tween has finished.

		public var onComplete:Function; //The function that should be triggered when this tween has completed
		public var onCompleteParams:Array; //An array containing the parameters that should be passed to the this.onComplete when this tween has finished.
		public var colorTransform:ColorTransform = new ColorTransform();
		
		
		public function Tny(targetD:DisplayObject = null) {
			
			super();
			
			if(p == null){
				p = new Array();
				addVarsOf(new SoundTransform());
				addVarsOf(new ColorTransform());
				addVarsOf( new Matrix());
			//	trace("------------------");
			//	trace("p " + p.join("\r"));
			}
			if(targetD != null && targetD.stage == null){
				trace("WARNING invalid stage, Tny won't be able to start");
			}
			target = targetD;

		}
	/*  2100 with these on, 1949 with them off.
	 * public static function to(trg:DisplayObject, dur:Number, propsO:Object):Tny{
			var tw:Tny = new Tny(trg);
			tw.duration = dur;			
			for (var i in propsO) {
				tw[i] = propsO[i];
			}
			return tw;
		}*/
		public function set props(pObj:Object):void{
			//trace("setting prop " + pObj );
			for (var i in pObj) {
			//	trace("setting prop " + i );
				this[i] = pObj[i];
			}
		}
		/*
		 * A hex RGB color value.
		 */
		public function set color(rgb:Number):void{
			colorTransform.color = rgb;
		}
		/* giving it a value of 0, will reset the color transform from 
		 * whatever 
		 * other values are between -100 to 100;
		 */
		public function set colorP(percent:Number){
			trace("setting colorP " + percent);
			if(percent == 0){
				colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
			}else{
				colorTransform.redMultiplier = colorTransform.greenMultiplier = colorTransform.blueMultiplier = 1 - percent/100;
			}
		}
		public function set target(v:DisplayObject):void{
		
			trg = v;
			
			if(trg == null){
				isFinished = true;
				return;
			}else{
				if(isNaN(fps) && trg.stage != null){
				//	trace("setting FPS!");
					trg.stage.addEventListener("enterFrame", onPulse);//, false, 0, true);
					fps = trg.stage.frameRate;
				}
			//	trace("setting target " + v.name + " " + v);
			    transform.matrix = trg.transform.matrix.clone();
				colorTransform = new ColorTransform();
				v.transform.colorTransform.concat(colorTransform);
				soundTransform = new SoundTransform();
				isSprite = trg  is Sprite;
			//	trace("isSprite? "  + isSprite);
				hasStarted = false;
				isFinished = false;
				isActive = false;
			}
		}
		public function get target():DisplayObject{
			return trg;
		}
		public function set delay(del:Number):void{
		/*	if(isNaN(del)){
				return;
			}*/
			dl = del * 1000;
		//	trace("delay"  + dl + " " + del + " " + fps);
		}
		/*************************************
		*             |<--- d --->|
		*             |0---------100
		* 1 frame :   [-------------] <- not possible in Tny as it would require two passes in the render loop
		* 2 frames:   [1-----][2----] <-- minimal
		* 3 frames:   [0--][1--][2--];
		*/

		public function set duration(dur:Number):void{
		/*	if(isNaN(dur)){
				return;
			}*/
			isActive = true;
			hasStarted = false;
			isFinished = false;
			if(dur == 0){
				//jump to end
				st = -1;
				d = 1;
				onPulse(null);
			}else{

				//this will be called every frame
				// so duration will be frames: = dur (in seconds)* fps;
				// increment equals duration/ fps/
		
			//	trace("duration " + dur + " at  " + fps + " fps");
			     fd = 1000/fps;
				d = (dur* 1000) - fd; // how many frames it will take to get there, keeping in mind that the start frame and end frame take up space.
				d = (d< (2*fd))?(2*fd):d; // minimum 2 frame duration
				st = getTimer() + dl;
				t = -dl ;//+ (Math.random() * fd); // if we have a delay, setup the delay as a percentage of the time (as we increment in percent)
			}
		//	trace("t " + t + " " + dl + " " + d + " dur " + dur);
	
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
				

	//	trace(trg.name +" onPulse "+ t + "% " + d + " " + isActive + " " + trg + " " + ts );
			if(!isActive  || (trg == null)){
			//	trace(" invalid ");
				return;
			}
					t = getTimer() -st;
			//trace(trg.name +" w "+ t);
			j = p.length;
			
			if(t < 0){
			//	trace(trg.name +" wait  ----- "+ t);
				return;
			}else if(t >= 0 && !hasStarted){
				//start
			/*	if(quantized){
					t = 0;
				}*/
				
				_am = trg.transform.matrix.clone();
				_ac = new ColorTransform();
				_ac.concat(trg.transform.colorTransform);

				if(isSprite){
					var stf:SoundTransform = Sprite(trg).soundTransform;
					_as = new SoundTransform(stf.volume, stf.pan);
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
		//	if(t == 0){
		//		t = .000000000000001;
		//	}
//trace(" t " + t + " " + dd);
			if(t >= (d - (fd * .5))){
				// finished
		//trace(trg.name +" isFinishing "+ t + "% " + d  + " "  +(getTimer() - st) );
				
				isFinished = true;
			//	trace(isFinished +" isFinished set? ");
			/*	if(quantized){
					t = 1;
				}*/
			}
	//		fc++;
		//trace(trg.name +" active "+ (t/d) + "% "+ t +"/" + d + " " + fc++);
	//	trace(trg.name +" active "+ t + "% " + d + " frame: " + fc + " " + + (getTimer() - st));
	       var pc:Number = Math.min(t/d, 1);
			tt = ease(pc, 0, 1, 1);
			//	trace(trg.name +" active2 "+ pc+ "% " + t +"/" + d +"=  " + tt );	
			while(--j > -1){
				k = p[j];
				//trace(j + " = " + k);
				/////////// SETUP /////////////
				if(j == 19){
			//		trace("setting up Matrix");
					c = _lm;
					a = _am;
					z = this.transform.matrix;
				}else if(j == 13){
				//	trace("setting up ColorTransform");
					c = _lc;
					a = _ac;
					z = colorTransform;
					z.alphaMultiplier = transform.colorTransform.alphaMultiplier;
					z.alphaOffset = transform.colorTransform.alphaOffset;
				} else if(j<= 5 && !isSprite){
					//skip sound
					//trace("skipping sound");
					t+=ts;
					break;
				}else if(j == 5  && isSprite){
				//	trace("setting up SoundTransform");
					c = _ls;
					a = _as;
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
				trace("finishing ColorTransform----------" + trg.transform.colorTransform.alphaMultiplier );
					_lc = trg.transform.colorTransform;
					trg.transform.colorTransform = c as ColorTransform;
					trg.visible = trg.transform.colorTransform.alphaMultiplier > .15;
				}else if( j == 0 && isSprite){
			//		trace("finishing SoundTranform----------");
					_ls = Sprite(trg).soundTransform;
					Sprite(trg).soundTransform = c as SoundTransform;
				}
				
			}
			//	trace(trg.name +" active3 "+ t + "% " + d );
			//	trace("finished? " + trg.name+ " " + isFinished);
			if(isFinished){
			//	trace("finished " + trg.name);
		//	trace("finished " + trg.name  + " in " + (getTimer() - st));
			
				isActive = false;
				if (onComplete != null) {
				//	trace("calling onComplete " + onComplete + " " + onCompleteParams);
					onComplete.apply(null, onCompleteParams);
				}
				return;
			}
			//	trace(trg.name +" active4 "+ t + "% " + d );
			t+=ts;

		}
	}
	
}