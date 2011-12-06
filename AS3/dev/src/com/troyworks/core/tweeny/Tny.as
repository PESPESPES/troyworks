
/**
 * Tny, the smallest tweening engine with Sound, Color and delay support 
 * I could figure out how to build. Currently 1871 bytes -4K bytes depending on what's commented on/off
 * It's unfortunately grown a bit to be safer for broader useage and optimization.
 * 
 * In operation it can be conceptualized as an array of properties to apply to a target,
 * through a transform function, the target is generally a displayObject, but can be a model object. There can
 * only be one target.
 * 
 * the property list can be adjusted as needed to or not. It's basically a command stack exectuted per frame
 * e.g. 
 *   0 setup context1
 *   1 calcprop1
 *   2 calcprop2
 *   3 finish.
 *   4 setup context2
 *   5 calcpropA
 *   6 calcpropB
 *   7 finish.
 *   
 * Note that the internal stack/prop list is walked backwards for performance reasons.
 * The setup and finish commands are necesary as various operations like matrix transforms
 * have to be assembled prior to setting them on the client.
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
 * Here's an example of non-visible tweening
 * EXAMPLE: Nonvisible property Tweening
import  com.troyworks.core.tweeny.Tny;

var obj:Object = new Object();
obj.difficulty = 5;
obj.sillyNess = 3;
var tny:Tny = new Tny(null, false);
tny.setHeartBeat(this); // display object
tny.trg = obj;
tny.addUserProps(["difficulty", "sillyNess"]);
tny.usrA.difficulty =0;
tny.usrA.sillyNess =3;
tny.usrZ.difficulty =100;
tny.usrZ.sillyNess =50;
tny.duration = 5;
	
addEventListener(Event.ENTER_FRAME, onENTER_FRAME);
	
function onENTER_FRAME(evt:Event):void{
trace("onENTER_FRAME " + obj.difficulty + " " + obj.sillyNess);
}
 * @author Troy Gardner troy@troyworks.com http://www.troyworks.com/tweeny/
 * @version 1.1
 * 
 * TODO
 *  staggered tweens?
 *  call functions?
 *  processing strings as time e.g. 1.5second, 1500ms
 *  oscillating tweens eases
 *  TextField properties tween
 *  relative change
 *  retarget while running
 *  stepped function
 *  random ease
 *  osillator easy
 */

package com.troyworks.core.tweeny {
	import flash.system.Capabilities;
	import flash.geom.Transform;
	import flash.display.Stage;	
	import flash.utils.Timer;	
	import flash.events.IEventDispatcher;	
	import flash.events.Event;	
	import flash.display.MovieClip;	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.media.SoundTransform;
	import flash.utils.describeType;
	import flash.utils.getTimer;
	import flash.system.Capabilities;

	public class Tny extends Object {

		/* the clip to affect */
		public var trg : Object;
		protected var isDisplayObject : Boolean = false;
		protected var isSprite : Boolean = false;
		protected var isMovieClip : Boolean = false;
		/* the frames per second of the movie */
		protected var fps : Number;

		/* easing function */
		public var ease : Function = Linear.easeIn;
		/* prop array */
		public var p : Array;

		/* loop iterators */
		protected var i : int = 0;
		protected var j : int = 0;
		protected var k : Object;

		/* begin */
		protected var aa : Object;
		/* current */
		protected var c : Object;
		/* end */
		protected var zz : Object;
		public var usrA : Object = new Object();
		public var usrZ : Object = new Object();
		//	protected var _lm : Matrix = new Matrix();
		protected var _lc : ColorTransform = new ColorTransform();
		protected var _ls : SoundTransform = new SoundTransform();

		protected var _aD : Object = new Object();
		//	protected var _am : Matrix = new Matrix();
		protected var _ac : ColorTransform = new ColorTransform();
		protected var _as : SoundTransform = new SoundTransform();
		//currentFrame
		protected var _aF : Object;
		protected var _cF : Object;
		protected var _cFset : Boolean = false;
		/* current calc time*/
		protected var tt : Number = 0;
		/* current time in percent */
		public var t : Number = 0;
		/* time step */
		protected var ts : Number = 0;
		/* duration */
		protected var d : Number = 0;
		/* delay */
		protected var dl : Number = 0;
		// getTimer Start
		protected var st : Number;
		protected var dd : Number;
		protected var fc : Number = 0;
		//frame duration in millisecondes
		protected var fd : Number = 0;
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
		public var lockStep : Boolean = false;

		/* active is longer than start and finish */
		public var isActive : Boolean = false;
		public var hasStarted : Boolean = false;
		public var isFinished : Boolean = false;

		public var onStart : Function; 
		//The function that should be triggered when this tween has completed
		public var onStartParams : Array; 
		//An array containing the parameters that should be passed to the this.onComplete when this tween has finished.
		public var onProgress : Function;
		public var onProgressParams : Array;
		public var onComplete : Function; 
		//The function that should be triggered when this tween has completed
		public var onCompleteParams : Array; 
		protected var _currentFrame : Number;

		public static var SND_PROPS : Array;
		public static var COLOR_PROPS : Array;
		public static var MATRIX_PROPS : Array;
		public static var MATRIX3D_PROPS : Array;
		public static var USR_PROPS : Array;

		public static const SNDTRANSFORM_START : String = "1";
		public static const SNDTRANSFORM_END : String = "2";
		public static const COLORTRANSFORM_START : String = "3";
		public static const COLORTRANSFORM_END : String = "4";
		public static const MATRIXTRANSFORM_START : String = "5";
		public static const MATRIXTRANSFORM_END : String = "6";
		public static const DISPLAYOBJECT_START : String = "7";
		public static const DISPLAYOBJECT_END : String = "8";
		public static const CURRENTFRAME_START : String = "9";
		public static const CURRENTFRAME_END : String = "10";

		public static const USRP_START : String = "11";
		public static const USRP_END : String = "12";
		protected var hasColorSupport : Boolean = false;
		public static const  VERSION : Number = 1.2;
		public var roundOutput : Boolean = false;
		public var roundPrecision:Number = NaN;
		public static var STAGE : Stage;

		public var x : Number = NaN;
		public var y : Number = NaN;
		public var z : Number = NaN;
		public var height : Number = NaN;
		public var width : Number = NaN;
		public var alpha : Number = NaN;
		public var scaleZ : Number = NaN;
		public var scaleX : Number = NaN;
		public var scaleY : Number = NaN;
		public var rotationZ : Number = NaN;
		public var rotationY : Number = NaN;
		public var rotationX : Number = NaN;
		public var rotation : Number = NaN;
		public var soundTransform : SoundTransform = new SoundTransform();
		//An array containing the parameters that should be passed to the this.onComplete when this tween has finished.
		public var colorTransform : ColorTransform = new ColorTransform();
		public var isF10 : Boolean;

		//	public var transform:Transform;
		public function Tny(targetD : DisplayObject = null, standardProps : Boolean = true) {
			super();
			//	transform = new Transform(null);//new Sprite().transform;
			var ts : String = Capabilities.version.split(" ")[1];
			isF10 = ts.indexOf("10") == 0;
			//trace("Capabilities.version " + Capabilities.version);
			if(!SND_PROPS) {
				staticInit();
			}
			if(p == null && standardProps) {
				p = new Array();
				addMatrixSupport();
				//trace("------------------");
			} else {
				p = new Array();
			}
			if(targetD != null) {
				trace("has a target display object");
				if(targetD.stage == null && STAGE == null) {
					trace("targetD.stage " + targetD.stage);
					//trace("WARNING invalid stage, Tny won't be able to start");
					targetD.addEventListener(Event.ADDED_TO_STAGE, addPulse);
				} else {
					STAGE = targetD.stage;
					setHeartBeat(STAGE);	
				}
			}else if(STAGE != null) {
				setHeartBeat(STAGE);
			}
			x = NaN;
			y = NaN;
			z = NaN;
			height = NaN;
			width = NaN;
			alpha = NaN;
			scaleZ = NaN;
			scaleX = NaN;
			scaleY = NaN;
			rotationZ = NaN;
			rotationY = NaN;
			rotationX = NaN;
			rotation = NaN;
			
			/*trace("x ", x);
			trace("y ", y);
			trace("z ", z);
			trace("alpha ", alpha);
			trace("scaleZ ", scaleZ);
			trace("scaleX ", scaleX);
			trace("scaleY ", scaleY);
			trace("rotationZ ", rotationZ);
			trace("rotationY ", rotationY);
			trace("rotationX ", rotationX);
			trace("rotation ", rotation);*/
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
		public function setHeartBeat(ie : IEventDispatcher, EventName : String = "enterFrame") : void {
			trace("setHeartBeat " + ie);
			ie.addEventListener(EventName, onPulse);
			if(ie is DisplayObject && (ie as DisplayObject).stage) {
				fps = (ie as DisplayObject).stage.frameRate;
			}else if(ie is Timer) {
				fps = 1000 / (ie as Timer).delay;
			}else if(STAGE != null) {
				fps = STAGE.frameRate;
			}
		}

		public function removeHeartBeat(ie : IEventDispatcher, EventName : String = "enterFrame") : void {
			ie.removeEventListener(EventName, onPulse);
		}

		public function addPulse(evt : Event) : void {
			//trace("Tny.addPulsee");
			if(isNaN(fps) && trg.stage != null) {
				//	trace("setting FPS!");
				setHeartBeat(trg.stage, "enterFrame");
				//, false, 0, true);
				fps = trg.stage.frameRate;
			}
		}

		public function staticInit() : void {
			//	trace("Tny.staticInit");
			SND_PROPS = addVarsOf(new SoundTransform(), SNDTRANSFORM_START, SNDTRANSFORM_END, new Array());
			COLOR_PROPS = addVarsOf(new ColorTransform(), COLORTRANSFORM_START, COLORTRANSFORM_END, new Array());
			//MATRIX_PROPS = addVarsOf(new Matrix(), MATRIXTRANSFORM_START, MATRIXTRANSFORM_END, new Array());
			//MATRIX3D_PROPS = addVarsOf(new Sprite(), DISPLAYOBJECT_START, MATRIX3DTRANSFORM_END, new Array());
			//trace("SND " + SND_PROPS.join(",") );
			//trace("CLR " + COLOR_PROPS.join(",") );
			//trace("MTX " + MATRIX_PROPS.join(",") );
		}

		protected function addVarsOf(o : Object, startCtx : String = null, endCtx : String = null, propArray : Array = null) : Array {
			//	trace("addVarsOf " + o);
			var dt : XML = describeType(o);
			var x : XMLList = dt..variable;
			var tA : Array = (propArray == null) ? p : propArray;
			var item : XML;
			if(endCtx) {
				tA.push(endCtx);
			}
			
			for each(item in x) {
				//	trace("item: " + item.@name + " " + item.@type);
				if(item.@type == "Number") {
					tA.push(item.@name);
				//	trace("adding " + item.@name + " to " + tA);
				}
			}
			x = dt..accessor;
			for each(item in x) {
				//  trace("accessor: " + item.@name);
				//	trace ("item.@type" + item.@type);
				//	trace ("item.@access" + item.@access);
				if(item.@access == "readwrite" && item.@type == "Number") {
					tA.push(item.@name);
				}
			}
			if(startCtx) {
				tA.push(startCtx);
			}
			return tA;
		}

		public function addProps(ary : Array) : void {
			if(ary) {
				var args : Array = ary;
				args.unshift(0); 
				//Number to delete
				args.unshift(p.length);
				p.splice.apply(p, args);
				trace("updated props are " + p.join(","));
			}
		}

		public function addSoundSupport() : void {
			//	trace("Tny.addSoundSupport");
			addProps(SND_PROPS);
		}

		public function addColorSupport() : void {
			//	trace("Tny.addColorSupport");
			if(!hasColorSupport) {
				addProps(COLOR_PROPS);
				hasColorSupport = true;
			}
		}

		public function addMatrixSupport() : void {
			//		trace("Tny.addMatrixSupport");
			addProps(MATRIX_PROPS);
		}

		/*	public function addMatrix3DSupport() : void {
		trace("Tny.addMatrix3DSupport");
		addProps(MATRIX3D_PROPS);
		}*/

		/*		public function addDisplayObjectProps() : void {
		var props : String = DISPLAYOBJECT_START + ",alpha,width,height,z,x,y,rotation,rotationX,rotationY,rotationZ,scaleY,scaleX,scaleZ," + DISPLAYOBJECT_END;
		p = props.split(",");
		}
		 */

		public function addUserProps(ary : Array) : void {
			//	trace("Tny.addUserPropsSupport");
			ary.push(USRP_START);
			ary.unshift(USRP_END);
			addProps(ary);
		}

		public function set props(pObj : Object) : void {
			//trace("setting prop " + pObj );
			for (var i:String in pObj) {
				//	trace("setting prop " + i );
				this[i] = pObj[i];
			}
		}

		/*	override public function set alpha(alp : Number) : void {
		super.alpha = alp;
		addColorSupport();
		}

		override public function get alpha() : Number {
		return super.alpha;
		}*/

		/*
		 * A hex RGB color value.
		 */
		public function set color(rgb : Number) : void {
			colorTransform.color = rgb;
			
			addColorSupport();
		}

		/* giving it a value of 0, will reset the color transform from 
		 * whatever 
		 * other values are between -100 to 100;
		 */
		public function set colorP(percent : Number) : void {
			//trace("setting colorP " + percent);
			if(percent == 0) {
				colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
			} else {
				colorTransform.redMultiplier = colorTransform.greenMultiplier = colorTransform.blueMultiplier = 1 - percent / 100;
			}
			addColorSupport();
		}

		
		public function set target(v : DisplayObject) : void {
		
			trg = v;
			
			if(trg == null) {
				isDisplayObject = false;
				isFinished = true;
				return;
			} else {
				isDisplayObject = true;
				if(trg is MovieClip) {
					//				trace("attempting to add vars of MovieClip")
					//addVarsOf(new MovieClip());
					isMovieClip = true;
				}
				addPulse(null);
				//	trace("setting target " + v.name + " " + v);
				//transform.matrix = trg.transform.matrix.clone();
				///	trace("width " + height);trace("width " + height);
				//	trace(" transform.matrix " + transform.matrix);
				//graphics.drawRect(0, 0, trg.width, trg.height);
				colorTransform = new ColorTransform();
				v.transform.colorTransform.concat(colorTransform);
				soundTransform = new SoundTransform();
				isSprite = trg is Sprite;
				//	trace("isSprite? "  + isSprite);
				hasStarted = false;
				isFinished = false;
				isActive = false;
			}
		}

		public function get target() : DisplayObject {
			return trg as DisplayObject;
		}

		public function set currentFrame(cf : Number) : void {
			if(!_cFset) {
				p.push(CURRENTFRAME_END);
				p.push("currentFrame");
				p.push(CURRENTFRAME_START);
				_cFset = true;
				roundOutput = true;
			}
			_currentFrame = cf;
		}

		public function get currentFrame() : Number {
			return _currentFrame;
		}

		public function set delay(del : Number) : void {
			/*	if(isNaN(del)){
			return;
			}*/
			dl = del * 1000;
		//	trace("delay"  + dl + " " + del + " " + fps);
		}

		public function get durationLeft() : Number {
			return t - d;
		}

		/*************************************
		 *             |<--- d --->|
		 *             |0---------100|
		 * 1 frame :   [-------------] <- not possible in Tny as it would require two passes in the render loop
		 * 2 frames:   [1-----][2----] <-- minimal
		 * 3 frames:   [0--][1--][2--];
		 */

		public function set duration(dur : Number) : void {
			/*	if(isNaN(dur)){
			return;
			}*/
			var p2 : Array = new Array();
			if(!isNaN(x)) {	
				p2.push("x");
			}
			if(!isNaN(y)) {
				p2.push("y");
			}
			if(isF10 && !isNaN(z)) {
				p2.push("z");
			}
			if(!isNaN(height)) {
				p2.push("height");
			}
			if(!isNaN(width)) {
				p2.push("width");
			}
			if(!isNaN(alpha)) {
				p2.push("alpha");
			}
			if(!isNaN(scaleZ)) {
				p2.push("scaleZ");
			}
			if(!isNaN(scaleY)) {
				p2.push("scaleY");
			}
			if(!isNaN(scaleX)) {
				p2.push("scaleX");
			}
			if(!isNaN(rotationZ)) {
				p2.push("rotationZ");
			}
			if(!isNaN(rotationY)) {
				p2.push("rotationY");
			}
			if(!isNaN(rotationX)) {
				p2.push("rotationX");
			}
			if(!isNaN(rotation)) {
				p2.push("rotation");
			}
			if(p2.length > 0) {
				p2.unshift(DISPLAYOBJECT_START);
				p2.push(DISPLAYOBJECT_END);
				addProps(p2);	
			}
			
			
			
			
			trace("duration " + dur);
			isActive = true;
			hasStarted = false;
			isFinished = false;
			if(dur == 0) {
				//jump to end
				st = -1;
				d = 1;
				onPulse(null);
			} else {

				//this will be called every frame
				// so duration will be frames: = dur (in seconds)* fps;
				// increment equals duration/ fps/

				//trace("duration " + dur + " at  " + fps + " fps");
				fd = 1000 / fps;
				d = (dur * 1000) - fd; 
				// how many frames it will take to get there, keeping in mind that the start frame and end frame take up space.
				d = (d < (2 * fd)) ? (2 * fd) : d; 
				// minimum 2 frame duration
				st = getTimer() + dl;
				t = -dl ;//+ (Math.random() * fd); // if we have a delay, setup the delay as a percentage of the time (as we increment in percent)
			}
			//trace("t " + t + " " + dl + " " + d + " dur " + dur);
	
//			trace("ts " + ts);
		}

		//	public function setDuration(val:Number):void{
		//		trace("setting Duration");
		//		duration = val;
		//	}
		//	public function get duration():Number{
		//		return d;
		//	}


		/*******************************************
		 *  The primary render loop
		 *  not that the start and finish can be called back in
		 * the same pulse when there is a zero duration.
		 * 
		 * note that when Tny's exist they are always getting the
		 * onPulse, this is to avoid startup of animation overhead.
		 * **/
		public function onPulse(evt : Event = null) : void {
		
			//PROP LISTING trace(p.join(","));

			//	trace(trg.name +" onPulse "+ t + "% " + d + " " + isActive + " " + trg + " " + ts );
			if(!isActive || (trg == null)) {
				//trace(" invalid ");
				return;
			}
			t = getTimer() - st;
			//trace(trg.name +" w "+ t);
			j = p.length;
			
			if(t < 0) {
				//trace(trg.name +" wait  ----- "+ t);
				return;
			}else if(t >= 0 && !hasStarted) {
				//	trace(trg.name + " Tny.Render pulse-----------");
				//start
				/*	if(quantized){
				t = 0;
				}*/

				if(isDisplayObject) {
					/*if(!trg.transform.matrix) {
					//if hits a null.
					return;
					}*/
					/////// CAPTURE START POSITION////////
					_aD.y = trg.y;
					_aD.x = trg.x;
					if(isF10) {
						_aD.z = trg.z;
					}
					_aD.height = trg.height;
					_aD.width = trg.width;
					_aD.alpha = trg.alpha;
					_aD.scaleZ = trg.scaleZ;
					_aD.scaleX = trg.scaleX;
					_aD.scaleY = trg.scaleY;
					_aD.rotationZ = trg.rotationZ;
					_aD.rotationY = trg.rotationY;
					_aD.rotationX = trg.rotationX;
					_aD.rotation = trg.rotation;
					//_am = trg.transform.matrix.clone();
					_ac = new ColorTransform();
					_ac.concat(trg.transform.colorTransform);
				}

				if(isSprite) {
					var stf : SoundTransform = Sprite(trg).soundTransform;
					_as = new SoundTransform(stf.volume, stf.pan);
				}
				if(isMovieClip) {
					_aF = {currentFrame:MovieClip(trg).currentFrame};
					_cF = {currentFrame:1};
				//	trace("ActualFram" + _aF + " " + _cF);
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
			if(t >= (d - (fd * .5))) {
				// finished
				//trace(trg.name +" isFinishing "+ t + "% " + d  + " "  +(getTimer() - st) );

				isFinished = true;
			//	trace(isFinished +" isFinished set? ");
			/*	if(quantized){
					t = 1;
				}*/
			}
			if (onProgress != null) {
				//	trace("calling onComplete " + onComplete + " " + onCompleteParams);
				onProgress.apply(null, onProgressParams);
			}
			//		fc++;
			//trace(trg.name +" active "+ (t/d) + "% "+ t +"/" + d + " " + fc++);
			//	trace(trg.name +" active "+ t + "% " + d + " frame: " + fc + " " + + (getTimer() - st));
			var pc : Number = Math.min(t / d, 1);
			//normalized ease for all props, as these ease calculations
			//are expensive there is no reason to calculate it more than once 
			// for all the props it affects.
			tt = ease(pc, 0, 1, 1);
			var ak : Number;
			
			//	trace(trg.name +" active2 "+ pc+ "% " + t +"/" + d +"=  " + tt );

			while(--j > -1) {
				k = p[j];
				///////////////TRACE///////////////////
				//trace(j + " = " + k);
				/////////// SETUP /////////////
				if(k === CURRENTFRAME_START ) {
					//	trace("setting up current frame");
					///////// frame navigation
					c = _cF;
					aa = _aF;
					zz = this;
					continue;
				}else if (k === DISPLAYOBJECT_START) {
					c = trg;
					aa = _aD;
					zz = this;
					continue;
			/*	}else if(k === MATRIXTRANSFORM_START ) {
					//		trace("setting up Matrix");
					c = _lm;
					aa = _am;
					zz = this;
					continue;*/
				}else if(k === COLORTRANSFORM_START) {
					//	trace("setting up ColorTransform");
					c = _lc;
					aa = _ac;
					zz = colorTransform;
					zz.alphaMultiplier = trg.transform.colorTransform.alphaMultiplier;
					zz.alphaOffset = trg.transform.colorTransform.alphaOffset;
					continue;
				} else if(k === SNDTRANSFORM_START && !isSprite) {
					//skip sound
					//trace("skipping sound");
					t += ts;
					break;
				}else if(k === SNDTRANSFORM_START && isSprite) {
					//	trace("setting up SoundTransform");
					c = _ls;
					aa = _as;
					zz = this.soundTransform;
					continue;			
				}else if(k === USRP_START) {
					//	trace("setting up user Prop trg:" + trg +typeof(trg)+ " " + usrA + " " + usrZ);
					c = trg;
					aa = usrA;
					zz = usrZ;
					continue;			
				}
				/////////// CALC //////////////
				//C = A + (D*t);
				if(isNaN(Number(k)) && c) {
					ak = aa[k];
					//	trace("k,c,ak,tt",k,c,ak,zz,tt);
					trace("calc '" + k + "' " + c[k] + " " + ak + " " + zz[k] + " @ " + tt);
					//current  = start + (delta) * currenteasetime
					//current = start + (end - start) * percent of duration
					c[k] = ak + ((zz[k] - ak) * tt);
					//trace("pcalc '" + k +"' " + c[k]);
					if(roundOutput) {
						if(isNaN(roundPrecision)) {
							c[k] = Math.round(c[k]);
						} else {
							trace("before round " + c[k] + " >  "+ (c[k] * roundPrecision)+ " ->  "+ (c[k] * roundPrecision) + " --> " + (Math.round(c[k] * roundPrecision) / roundPrecision));
							c[k] = Math.round(c[k] * roundPrecision) / roundPrecision;
						}
					}
				}	
				/////////// FINISH ////////////
				if(k === CURRENTFRAME_END ) {
					//		trace("finishing currentFrame " +  Math.round(c.currentFrame));
					(trg as MovieClip).gotoAndStop(c.currentFrame);
				}else if(k === DISPLAYOBJECT_END) {
					//		trace("finishing Matrix");
					//_lm3D = trg.transform.matrix3D;
					//trg.transform.matrix3D = c as Matrix3D;
			/*	}else if(k === MATRIXTRANSFORM_END) {
					//		trace("finishing Matrix");
					_lm = trg.transform.matrix;
					trg.transform.matrix = c as Matrix;*/
				}else if(k === COLORTRANSFORM_END) {
					//trace("finising ColorTransform----------" + trg.transform.colorTransform.alphaMultiplier);
					_lc = trg.transform.colorTransform;
					trg.transform.colorTransform = c as ColorTransform;
					trg.visible = trg.transform.colorTransform.alphaMultiplier > .15;
				}else if(k === SNDTRANSFORM_END && isSprite) {
					//		trace("finishing SoundTranform----------");
					_ls = Sprite(trg).soundTransform;
					Sprite(trg).soundTransform = c as SoundTransform;
				}else if (k === USRP_END) {
				//	trace("finishing userProps");
				}
			}
		//	evt.updateAfterEvent();
			//	trace(trg.name +" active3 "+ t + "% " + d );
			//	trace("finished? " + trg.name+ " " + isFinished);
			if(isFinished) {
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
			t += ts;
		}
	}
}