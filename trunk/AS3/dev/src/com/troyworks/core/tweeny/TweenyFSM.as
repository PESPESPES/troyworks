/**
* Tweeny is a simple playhead for Penner based transitions, which can be thought of a time of timeline
* 
* 	var tw:Tweeny = Tweeny.getATweeny(mc, time);	
	tw.addEventListener(Tweeny.TRANSITIONED_NAME, EventAdapter.create(tweenTweeny,[mc, 0]));
	for(var i in props){
		if(i != "delay"){
			tw[i] = props[i];
		}
	}
	tw.ease = Strong.easeIn;	
	tw.startFromBeginning();

* 
* @author Troy Gardner (troy@troyworks.com)
* @version 0.1
*/

package com.troyworks.core.tweeny {
	import com.troyworks.core.Signals;
	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.core.cogs.Fsm;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.getTimer;	

	//import com.troyworks.data.TweenEquations;

	
	
	
	public class TweenyFSM extends Fsm {
		public static var stage:Stage;
		/* cache the signals for clarity in code and performance reasons */
		public static const ENTER_FRAME:Signals= Signals.ENTER_FRAME;
		public static const TRANSITION_START:Signals = Signals.TRANSITION_START;
		public static const TRANSITION_START_NAME:String =Signals.TRANSITION_START.name;
		public static const TRANSITION_PROGRESS:Signals = Signals.TRANSITION_PROGRESS;
		public static const TRANSITION_PROGRESS_NAME:String = Signals.TRANSITION_PROGRESS.name;
		public static const TRANSITIONED:Signals = Signals.TRANSITIONED;
		public static const TRANSITIONED_NAME:String = Signals.TRANSITIONED.name;
		public static const RECYCLED_NAME:String = "RECYCLED";
		
		private var _disObj:DisplayObject;
		private var _notifyStart:Boolean = false;
		private var _notifyProgress:Boolean = false;
		private var _notifyEnd:Boolean = false;
		
		public static var pool:Array = new Array();
		private var _myListeners:Object = new Object();
		
		
		public var recycleOnComplete:Boolean = false;
		public var fresh:Boolean = true;
		
		public var doX:Boolean = false;
		/* @param b (egin)		Starting value /offset.*/
		public var xBegin:Number= 0;
		/* @param c (hange) 		Change needed in value. (desired end value - start value)*/
		public var xChange:Number= 0;
		
		
		public var doY:Boolean = false;
		public var yBegin:Number= 0;
		public var yChange:Number= 0;
		

		public var doScaleX:Boolean = false;
		public var scaleXBegin:Number= 0;
		public var scaleXChange:Number= 0;
		private var curScaleX:Number = 0;
		
		public var doScaleY:Boolean = false;
		public var scaleYBegin:Number= 0;
		public var scaleYChange:Number= 0;
		private var curScaleY:Number = 0;

		public var doWidth:Boolean = false;	
		public var o_width:Number= 0;
		public var widthBegin:Number= 0;
		public var widthChange:Number= 0;
		
		
		public var doHeight:Boolean = false;
		public var o_height:Number= 0;
		public var heightBegin:Number= 0;
		public var heightChange:Number= 0;
		

		public var doRotation:Boolean = false;
		public var rotationBegin:Number = 0;
		public var rotationChange:Number = 0;
		private var curRotation:Number = 0;
		
		public var doAlpha:Boolean = false;
		public var alphaBegin:Number = 0;
		public var alphaChange:Number = 0;
		public var hideOnAlphaZero:Boolean = false;

		public var doColorTransform:Boolean = false;
		public var colorTranformBegin:ColorTransform;
		private var _colorTranform:ColorTransform;
		
		public var doMatrixTransform:Boolean = true;
		public var matrixBegin:Matrix;
		private var _matrixLast:Matrix;
		private var _matrix:Matrix;
		/////// temp vars
		private var _a:Number;
		private var _b:Number;
		private var _c:Number;
		private var _d:Number;
		private var _tx:Number;
		private var _ty:Number;
		private var _a2:Number;
		private var _b2:Number;
		private var _c2:Number;
		private var _d2:Number;
		private var _tx2:Number;
		private var _ty2:Number;
		
		private var _aa:Number;
		private var _bb:Number;
		private var _cc:Number;
		private var _dd:Number;
		private var _xx:Number;
		private var _yy:Number;
		
		public var snapToWholePixel:Boolean = false;

		public static const SOUND_VOLUME_MIN:Number = 0;
		public static const SOUND_VOLUME_MAX:Number = 1;
		public var doSoundVolume:Boolean = false;
		public var volumeBegin:Number = 0;
		public var volumeChange:Number = 0;
		public static const SOUND_PAN_FULL_LEFT:Number = -1;
		public static const SOUND_PAN_CENTER:Number = 0;
		public static const SOUND_PAN_FULL_RIGHT:Number = 1;
		public var doSoundPan:Boolean = false;
		public var panBegin:Number = 0;
		public var panChange:Number = 0;
		private var _sndT:SoundTransform = new SoundTransform();
		
		public var soundChannel:SoundChannel ;
		
		
		// a special nonvisual function that can be called //
		public var callFn:Boolean = false;
		public var fnBegin:Number = 0;
		public var fnChange:Number = 0;
		
		
		
		private var calc:Number;
		private var _f:Function = None.easeInOut;
		private var _fHasXtraArgs:Boolean = false;
		/* optional easing args */
		private var _fA:Array;

		private var _inc:Number;
		private var _forward:Boolean = true;
		

		/* @param target function */
		private var _tgSetFn:Function =null;
		private var _tgGetFn:Function =null;


		/* Time with the tweening equasions involves converting global time (getTimer)
		 * to local time (starting at zero), meaning in practical terms getTimer
		 * 
		 * is always used as absolute time, but it's always relative to the start datestamp
		 * and the values passed to easing function are relative to that start datestamp
		 * 
		 * Date Time 
		 * getTimer Time 100.....200....300....400 ((in getTimer))
		 *                        ^tBegin(in getTimer)============^tEnd
		 * Local/Relative Time     0[========== tDuration ========>]d
		 * Local/Relative Time     [ct.........range is here.........]
		 * 
		/* @param tBegin (time Begin) */
		private var tBegin:Number = 0;
		/* @param ct (time)		Current time (in frames or seconds)., should always start at zero for forward*/
		private var ct:Number= 0;
		/* @param d (uration)		Expected easing duration (in frames or seconds) from 0*/

		private var d:Number =1;
		private var tDuration:Number = 1;
		private var tEnd:Number = 1;
		public var delay:Number = 0;
		private var startAnimTime:Number;
		
		public static const TIMER_STEP:String = "TIMER";
		public static const TIMER_GET_TIMER:String = "GET_TIMER";
		public static const TIMER_TIMESTAMP:String = "TIMER_TIMESTAMP";
		public var timerMode:String = TIMER_GET_TIMER;
		
		var curGetT:Number;
		var lastGetT:Number;
		var resetTimer:Boolean = false; 
		private static const PI_180:Number = Math.PI/180;
		private var _point:Point = new Point();
		
		private var Am:Matrix = new Matrix();
		private var Bm:Matrix= new Matrix();
		private var Cm:Matrix= null;
		private var useA:Boolean = false;
		public var onComplete:Function; //The function that should be triggered when this tween has completed
		public var onCompleteParams:Array; //An array containing the parameters that should be passed to the this.onComplete when this tween has finished.

		
		private static const _enterEvent:CogEvent = new CogEvent(CogEvent.Eventttt_COG_PRIVATE_EVENT, Signals.ENTER_FRAME);
		
		public function TweenyFSM(initStateName:String="s_noMovementNeeded", smName:String = "Tweeny") {
			super(((initStateName==null)?  "s_noMovementNeeded":initStateName), ((smName==null)? "Tweeny":smName));
		}
		public static function easeNone (t:Number, b:Number, c:Number, d:Number):Number {
			return c*t/d + b;
		}
		public function setInit(target:Object, duration:Number):void{
			setTarget(target);
			this.duration = duration;
			initStateMachine();
		}
		public static function getATweeny(target:Object, duration:Number, initObj:Object = null ):Tweeny{
			var t:Tweeny;
			if(pool.length > 0){
				t = pool.shift();
			//	trace("cache: existing Tweeny " + t.getStateMachineName());
				return t;
			}else{
				t =  new Tweeny();
				t.target = target as DisplayObject;
				t.dur = duration;//(target, duration);
				//t.recycleOnComplete = false;
			//	trace("cache: new Tweeny " + t.getStateMachineName());
				return t;
			}
		}
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
		  if(_myListeners[type] == null){
			  _myListeners[type] = [listener];
		  }else{
			  _myListeners[type].push(listener);
		  }
		  super.addEventListener(type,listener,useCapture, priority, useWeakReference);
		}
		public function removeAllListeners():void{
			for(var i in _myListeners){
				var evtName:String = i;
				var listeners:Array = _myListeners[i];
				while(listeners.length > 0){
					removeEventListener(evtName, listeners.shift());
				}
			}
		}
		public static function to(target:Object, duration:Number, initObj:Object = null):Tweeny{
			var ty:Tweeny = new Tweeny();
			ty.target = DisplayObject(target);
			ty.duration = duration;
			
		//	ty.initStateMachine();
			ty.gotoAndPlay(0);
			return ty;
		}

		public function startFromBeginning():void{
			//trace("startFromBeginning");
			resetTimer = true;
			switch(timerMode){
				case TIMER_GET_TIMER:
					resetTimer = true;
					ct = 0;
					d = (tDuration * 1000);
					break;
				case TIMER_STEP:
					_inc = 1;
					ct = tBegin;
				break;
				case TIMER_TIMESTAMP:
				break;

			}
			if(doMatrixTransform){		
				matrixBegin = _disObj.transform.matrix.clone();
				//updateEndMatrix();
				_a = matrixBegin.a;
				_b = matrixBegin.b;
				_c = matrixBegin.c;
				_d = matrixBegin.d;
				_tx = matrixBegin.tx;
				_ty = matrixBegin.ty;
				//////////////////////
				var mE:Matrix =matrixBegin;
					if(doScaleX  || doWidth || doHeight || doScaleY){
					//trace("doingScaling");
					_a2 =1;
					_d2 =1;
					if(doScaleX  || doWidth){							
						if(doScaleX){
			//				trace("cur " + curScaleX + " " + scaleXChange + " " + scaleXBegin);
							_a2 = (_a+ scaleXChange) ;
							}else if(doWidth){
						//		trace(widthBegin  + " " +  widthChange + " doing Width  " + ( widthBegin + widthChange) + " " +o_width);
								_a2 = ((widthBegin + widthChange)/o_width) *_a ;
							}
							//	trace("scale a " + _a);
							}
						if(doHeight || doScaleY){
							if(doScaleY){
								//trace("curScaleY" + curScaleY + " " + scaleYChange);
								_d2  = (_d + scaleYChange);
							}else if(doHeight){
								_d2 = ((heightBegin +heightChange)/ o_height )*_d;
								//trace("doing Height " + _d + " " + heightBegin + " c " + heightChange);
							}
						}
						mE.a = _a2;
						mE.d = _d2;
						///////// correct ////////////////////////
						//get rotation, set it to desired
						mE.rotate( -(Math.atan2(mE.b, mE.a) *(180/Math.PI) -rotationBegin)*PI_180);
						mE.tx = _tx;
						mE.ty = _ty;
					}				
					if(doRotation){
						//trace("doingRotation");
						mE.rotate(rotationChange* PI_180);
						mE.tx = _tx;
						mE.ty = _ty;
					}
					if(doX || doY){
						mE.translate((doX)?xChange:0, (doY)?yChange:0);
					}
					//	mE.tx = px;
					//	mE.ty = py;
					
					//trace("MATRIXMATH: _matrixEnd " + mE);	
					_matrix = mE;
					_a2 = mE.a;
					_b2 = mE.b;
					_c2 = mE.c;
					_d2 = mE.d;
					_tx2 = mE.tx;
					_ty2 = mE.ty;
					////////////////
					_aa = _a2 - _a;
					_bb = _b2 - _b;
					_cc = _c2 - _c;
					_dd = _d2 - _d;
					_xx = _tx2 - _tx;
					_yy = _ty2- _ty;

			}
				/////////////// SETUP //////////////////////////////
					 //trace(getStateMachineName()+".s_movementNeeded ENTER " + (getTimer()- lastGetT));
					//trace(tBegin + " / " + ct+ " / " + d + " " + (ct-tBegin));
					//lastGetT = getTimer();
					//trace("doX " + doX + " doY " + doY + " doHeight " + doHeight + " doWidth " + doWidth + " sx " + doScaleX + " sy " + doScaleY +" doRotation "+ doRotation); 
					//starting move/tween
					if(_disObj == null && _tgSetFn == null){
						return;
					}
				
					if(stage == null){
						throw new Error("Tweeny needs a reference to the stage to run, please set \r\t\t 'Tweeny.stage= stage;' \r\tor pass in a valid displayObject");
					}
					

					if(hasEventListener(TRANSITION_START_NAME)){
						dispatchEvent(getTweenyEvent(TRANSITION_START_NAME));
					}
					_notifyProgress = hasEventListener(TRANSITION_PROGRESS_NAME);
					_notifyEnd = hasEventListener(TRANSITIONED_NAME);

			//wait to start, as this may be being called
			//from an exit event.
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			if(delay > 0){
				//	trace("starting with delay");
				startAnimTime = getTimer() + (delay* 1000);
			}
		}
		public function startFromEnd():void{
			var a:Number = tBegin;
			tBegin = d;
			ct = d;
			d = a;
			_inc = -1;
			tran(s_movementNeeded); 
		}
	/*
     * Rounds a target number to a specific number of decimal places.
     * @see Math#round
     */
    public static function roundToPrecision(number:Number, precision:int = 3):Number
    {
        var decimalPlaces:Number = Math.pow(10, precision);
        return Math.round(decimalPlaces * number) / decimalPlaces;

    }
	public function notClose(number1:Number, number2:Number):Boolean
	{
		
		
		var difference:Number = (number1 > number2)? number1 - number2: number2 - number1;

		//trace(1 + " " + difference );
		var res:Boolean =.1 < difference ;
		//trace("notClose" + res);
		return res;

	}

		public function setTarget(target:Object):void{
			if(target is DisplayObject){
				setStateMachineName(target.name +":"+getStateMachineName());
				_disObj = target as DisplayObject;
				matrixBegin = _disObj.transform.matrix.clone();
				scaleXBegin = _disObj.scaleX;
				scaleYBegin = _disObj.scaleY;
				var rect:Rectangle = _disObj.getBounds(_disObj);
				o_width = rect.width;
				o_height = rect.height;
				
				if(!stage &&  _disObj.stage != null){
					stage = _disObj.stage;
				}
				setBeginValsFromTarget();
			}else if (target is SoundChannel){
				soundChannel = target as SoundChannel;
			}else if (target is Function){
				_tgSetFn = target as Function;				
			}
		}
		
		
		public function set startTime(start:Number):void{
			//avoid div by zero for some of the easing tweens
			tBegin = start;
		}
		public function set endTime(end:Number):void{
			tDuration = end - tBegin;
			if(tDuration == 0){
				//some easing params don't like t to be zero
				tDuration =.0000001;
			}
		}
		public function set duration(durationInTime:Number):void{
			//some easing params don't like t to be zero

			tDuration = (durationInTime == 0)?.0000001:durationInTime;
		}
		public function set incrementTime(increment:Number):void{
			_inc = increment;
		}
		protected function getTweenyEvent(type:String):TweenyEvent{
			var res:TweenyEvent = new TweenyEvent(type);
			// start time is 0, currenttime is 0 to duration
			res.currentTime = ct;
			res.duration = d;
			
			res.beginVal = 0;
			res.curVal = calc;
			res.endVal = 1;
			return res;
		}
		public function setBeginValsFromTarget():void{
			if(_disObj != null){
				xBegin = _disObj.x;
				yBegin = _disObj.y;
				alphaBegin = _disObj.alpha;
				curScaleX =   _disObj.scaleX;
				curScaleY =   _disObj.scaleY;
				widthBegin =  (curScaleX  * o_width);
				heightBegin =  (curScaleY  * o_height);
				
				rotationBegin = _disObj.rotation;
				colorTranformBegin = _disObj.transform.colorTransform;
				//matrixBegin = _disObj.transform.matrix.clone();
				if(soundChannel != null){
					volumeBegin =  soundChannel.soundTransform.volume;
					panBegin =  soundChannel.soundTransform.pan;	
				}else if(_disObj is Sprite){
					volumeBegin =  Sprite(_disObj).soundTransform.volume;
					panBegin =  Sprite(_disObj).soundTransform.pan;	
				}
			}
			if(_tgGetFn != null){
				fnBegin = _tgGetFn();
			}
		}
		
		
		public function set x(end:Number):void{
			xChange =   (end -xBegin);
			doX = notClose(xChange, 0);
		}
		public function set y(end:Number):void{
			yChange =  (end -yBegin);
			doY = notClose(yChange, 0);
		}
		public function set scaleX(end:Number):void{
		//	trace("scaleX " + end + " " + curScaleX);
			scaleXChange = ( end -curScaleX);
		//	trace("scaleX D:" + scaleXChange + " desired: " + end + " cur:" +curScaleX);

			doScaleX = notClose(scaleXChange, 0);
		}
		public function set scaleY(end:Number):void{
			scaleYChange =(  end -curScaleY);
			doScaleY = notClose(scaleYChange, 0);
		}
		public function set width(end:Number):void{
			widthChange = ( end -widthBegin);
		//	trace("!!!!widthChange " + widthChange + " end " + end + " " + widthBegin);
			doWidth = notClose(widthChange, 0);
		}
		public function set height(end:Number):void{
			heightChange = ( end -heightBegin);
			//trace("heightChange: " + heightChange + " desired: " + end + " from: " + heightBegin);
			doHeight = notClose(heightChange, 0);
		}
		public function set rotation(end:Number):void{
			rotationChange = (end -rotationBegin);
			doRotation = notClose(rotationChange, 0);
		}
		public function set alpha(end:Number):void{
			alphaChange = (end -alphaBegin);
			doAlpha = notClose(alphaChange,0);
		}
		public function set fnEnd(end:Number):void{
			fnChange = end -fnBegin ;
			callFn = true;
		}
		// set red, green, and blue with normal numbers
		// r, g, b between 0 and 255 
		//updated to AS3.0 by tg
		public function setColor (rgbHex:Number):void{
			if(_colorTranform == null){
				_colorTranform = new ColorTransform();
			}
			_colorTranform.color = rgbHex;
			doColorTransform = true;
		}
		public function set colorTranform(colorTrans:ColorTransform):void{
			_colorTranform = colorTrans;
			doColorTransform = true;
		}
		public function set volume(end:Number):void{
			volumeChange= roundToPrecision(end -volumeBegin);
			doSoundVolume = notClose(volumeChange, end);
		}
		public function set pan(end:Number):void{
			panChange =roundToPrecision( end -panBegin);
			//trace(end + " panChange " + panChange);
			doSoundPan = notClose(panChange, end);
		}

		////////////////////////////////////////////////////
		public function set ease(fn:Function):void{
			_f = fn;
		}
		public function set easingFunctionArgs(ary:Array ):void{
			_fA = ary;
			_fHasXtraArgs = ((_fA != null )&&( _fA.length > 0));
		}


		public function recycle():void{
			this.fresh = false;
			pool.push(this);
			removeAllListeners();
		}
		///////////////////  STATE ACCESSORS ///////////////////////
		public function noMovementIsNeeded():Boolean{
			return isInState(s_noMovementNeeded);
		}
		public function movementIsNeeded():Boolean{
			return isInState(s_movementNeeded);
		}
		///////////////////// STATES ///////////////////////////////
		/*.................................................................*/
		public function s_noMovementNeeded(e : CogEvent):Object {
			switch (e.sig) {
				case SIG_ENTRY :
		//		trace("noMovementNeeded ENTER");
					return null;
				case SIG_EXIT :
		//			trace("noMovementNeeded EXIT");
					return null;
			}
			return  null;
		}
		/*.................................................................*/
		public function s_movementNeeded(e : CogEvent):Object {
		//	trace("s_movementNeeded " + e.sig.name);
			switch (e.sig) {
				case SIG_ENTRY :

					return null;
				case SIG_EXIT :

					
					return null;
			}
			return  null;
		}
		public function onEnterFrame(evt:Event = null):void{
		//	trace("onEnterFrame-------------");
	////////////////// PRESTART ///////////////////////////
					//trace(getStateMachineName()+".s_movementNeeded ENTERFRAME " + (getTimer()- lastGetT));
					curGetT = getTimer();
					if(curGetT < startAnimTime ){
					//	trace("not time to start");
						return;
					}
					//////////// FIRST START /////////////////////////////
					if(resetTimer){
						//necessary to make sure funcation at time zero is called.
						tBegin = curGetT;
						resetTimer = false;
					}
					////////////// GET LATEST TIMER ///////////////////////////////

				/*	switch(timerMode){
						case TIMER_STEP:
							if(_forward){
								ct += _inc;
							}else{
								ct -= _inc;
							}
						break;
						case TIMER_GET_TIMER:*/
						ct = curGetT - tBegin;
						if(ct > d){
							ct =d;
						}
/*						break;
						case TIMER_TIMESTAMP:
						break;

					}*/
			       ////////////////////// CALC BASED ON TWEEN //////////////////
					if(_fHasXtraArgs){
						//////////// NON-STANDARD TWEENS with Extra Params (e.g. Elastic, Back) //////////////
						calc = _f.apply(null,[ct,0,1,d].concat(_fA ));
					}else{
						//////////// MOST STANDARD TWEENS //////////////
						calc = _f(ct,0,1,d);
					}
					
					//trace(tBegin + " / " + ct+ " / " + d + " " + (ct-tBegin));
					//some easing params don't like t to be zero
					//ct = (ct == 0)?.0000001:ct;
					//tried using bitflags, booleans are faster.

						
					//with(_disObj){
						
					//}
					//----------- displayObject visual component parameters -------------------
										//Tranform Matrix
					//See: http://www.senocular.com/flash/tutorials/transformmatrix/
					//Thanks Senocular!
					if(doMatrixTransform){
						useA = !useA;
						Cm = (useA)? Am:Bm;
						
						Cm.a =  _a + (_aa*calc);
						Cm.b = _b + (_bb*calc);
						Cm.c = _c + (_cc*calc);
						Cm.d = _d + (_dd*calc);
						Cm.tx = _tx + (_xx*calc);
						Cm.ty = _ty + (_yy*calc);
						
						
//						_disObj.transform.matrix.concat( mi);
						_disObj.transform.matrix= Cm;
					}

		/*			//-------------- Sound ------------------------------
					if(doSoundVolume){
						_sndT.volume = volumeBegin +  (calc * volumeChange);						
					}
					if(doSoundPan){
						_sndT.pan = panBegin + (calc * panChange);;
					}
					if((doSoundPan || doSoundVolume) ){
						
						if(soundChannel != null){
							soundChannel.soundTransform = _sndT;
						}else if(_disObj is Sprite){
							//only Sprites have soundTransform
							Sprite(_disObj).soundTransform = _sndT;
						}
					}
					
					//TODO: Filters ----------------------------------
				
					if(doAlpha){
						_disObj.alpha = alphaBegin +  (calc * alphaChange);
						if(hideOnAlphaZero){
							_disObj.visible = !(_disObj.alpha == 0);
						}
					}

					//-------------- Color ------------------------------
					if(doColorTransform){
						//trace("doColorTransform " + _disObj);
						//cross fade values from current color to end color, linearly based on the eased point in time.
						var dR:Number = colorTranformBegin.redMultiplier  + ((_colorTranform.redMultiplier - colorTranformBegin.redMultiplier) * calc);
						var dG:Number = colorTranformBegin.greenMultiplier  + ((_colorTranform.greenMultiplier - colorTranformBegin.greenMultiplier) * calc);
						var dB:Number = colorTranformBegin.blueMultiplier  + ((_colorTranform.blueMultiplier - colorTranformBegin.blueMultiplier) * calc);
						var dA:Number = colorTranformBegin.alphaMultiplier  + ((_colorTranform.alphaMultiplier - colorTranformBegin.alphaMultiplier) * calc);

						var oR:Number = colorTranformBegin.redOffset  + ((_colorTranform.redOffset - colorTranformBegin.redOffset) * calc);
						var oG:Number = colorTranformBegin.greenOffset  + ((_colorTranform.greenOffset - colorTranformBegin.greenOffset) * calc);
						var oB:Number = colorTranformBegin.blueOffset  + ((_colorTranform.blueOffset - colorTranformBegin.blueOffset) * calc);
						var oA:Number = colorTranformBegin.alphaOffset  + ((_colorTranform.alphaOffset - colorTranformBegin.alphaOffset) * calc);

						_disObj.transform.colorTransform = new ColorTransform(dR,dG,dB,dA,oR,oG,oB,oA);
					}
					
					//-------------- Filters ------------------------------
					
					////----------- Non-visual components ---------------
					if(callFn){
						_tgSetFn( fnBegin +  (calc * fnChange));
					}
					/////////////////// ACCUMULATE FORCES //////////////////
					// ? is it possible to have multipe tweens in competiton for the same
					// target, blending them? (e.g. necessary for Score and particle with multiple forces)
					
					///////////////////CLEAN UP /////////////////////////////
					// TODO: implement pluggable collision detect cleanup
					//
					

					if(_notifyProgress){		
						dispatchEvent( getTweenyEvent(TRANSITION_PROGRESS_NAME));
					} */
					//trace(ct + " " + d);
					if(ct >= d){	
						stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					//	trace("tran1 " + tran + " s_noMovementNeeded " + s_noMovementNeeded);
						requestTran(s_noMovementNeeded);
						
						if (onComplete != null) {
							onComplete.apply(null, onCompleteParams);
						}
						///////////stopping tween /////////////////////////
						// might be finished might be interrupted
						///////////////////SNAP TO WHOLE PIXELS/////////////
						// useful for text and thin line clarity
						// needs to happen at end as scale also affects 
						if(snapToWholePixel){
							_disObj.x = Math.round(_disObj.x);
							_disObj.y = Math.round(_disObj.y);
					
							_disObj.height = Math.round(_disObj.scaleY *  o_height);
							_disObj.width = Math.round(_disObj.scaleX *  o_width);
							//trace("SNAP to " + _disObj.height + " " + _disObj.width );
						}
						
						if(ct >= d){
							//trace("finished Tween " );
							//finished moving
							//_disObj.width = 400;
							//_disObj.height = 5;
							// snap to the staged positions
							if(_notifyEnd){
								dispatchEvent( getTweenyEvent(TRANSITIONED_NAME));
							}

							if(recycleOnComplete){
							//	trace(" recycling " + getStateMachineName());
								recycle();
							}
						}
						setBeginValsFromTarget();
					}
					lastGetT = curGetT;
		}
	}
	
}
