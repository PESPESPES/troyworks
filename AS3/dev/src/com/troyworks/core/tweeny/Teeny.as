
/**
* ...
* 
* Test with zero duration
* Test with multiple sequential tweens with step 
* @author Troy Gardner
* @version 0.1
*/

package com.troyworks.core.tweeny {
	import flash.display.*;	
	import flash.events.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.utils.*;

	public class Teeny {
		
		static var stage:Stage;
		//view
		protected var $v:DisplayObject;
		// view bounding rectangle
		var $vB:Rectangle;
		//view rotation
		var $vR:Number;
		//shadow object for debugging
		//var $s:DisplayObject = new Sprite();

		public var st:Number = 0; //start animation  time	
		public var ct:Number = NaN; //current animation time
		public var lt:Number = NaN; //current animation time
		var t:Number; //calc for normalized tween time
		
		public var isPlaying:Boolean = false;
		
		var dur:Number = 0; //duration
		var _delay:Number = 0;
		public var useStepClock:Boolean = false;
		var stepClockTime:Number =0;
		/* loop counters*/
		var i:String;
		var j:int;
		var l:int;

		/* easing array */
		var ess:Array = new Array();
		/* work array */
		static var X:Object = new Object();
		var W:Array = new Array();
		var F:Number = 0;
		
		
		
		
		public var loops:Number = 0;
		public var loopsLeft:Number = 0;
		public var autoRewind:Boolean = false;

		public var ease:Function;
		public var onComplete:Function; //The function that should be triggered when this tween has completed
		public var onCompleteParams:Array; //An array containing the parameters that should be passed to the this.onComplete when this tween has finished.
		static var _all:Dictionary;
		public var id:Number = 0;
		protected static var IDZ:Number = 0;
		
		/////////////////////////////////////////////////////////////////////
		////          ANIMATOR                                     //////////
		/////////////////////////////////////////////////////////////////////

		public function Teeny() {
			id = IDZ++;
			if(_all == null){
				_all = new Dictionary();
			}
		}
		

		public function set target(dObj:DisplayObject):void {
			$v = dObj;
			if($v != null){
				//trace("setting target " + dObj.name);
				if(stage == null &&  $v.stage != null){
					stage = $v.stage;
				}
				if (_all[dObj] == undefined) {
					_all[dObj] = new Dictionary();
				}
				_all[dObj][this] = this;
	
				if(stage != null){
					stage.addEventListener(Event.ENTER_FRAME, updatePlayhead);
				}
	
				$vB = $v.getBounds($v);
				$vR = $v.rotation;
				a1 = $v.alpha;
			}else{
				if(stage != null){
					stage.removeEventListener(Event.ENTER_FRAME, updatePlayhead);
				}
			}
		}
		public static function removeTween(tw:Teeny = null):void {
			if (tw != null && _all[tw.$v] != undefined) {
				tw.stop();
				delete _all[tw.$v][tw];
			}
		}
		
		public static function killTweensOf($tg:Object = null):void {
			if ($tg != null && _all[$tg] != undefined) {
				var twz:Dictionary = _all[$tg];
				for(var i in twz){
					twz[i].stop();
				}
				delete _all[$tg];
			}
		}
		
		public function set duration(end:Number){
			dur = end * 1000;
		}
		public function set delay(tInSecs:Number){
			_delay = (tInSecs * 1000);
			ct = NaN;		
		}


		function gotoT(t:Number){

			lt = ct;	
		
			//range check
			if(0 <= t && t <= dur){
				ct = t;
			}else if(t < 0){
				ct = 0;
			}else if(dur< t){
				ct = dur;
			}
			if(lt != ct){
			//		trace("render " + lt + " "  + ct );
					if (0 <=  ct  && ct <=  dur) {
						//------- CORE RENDER ------------//
			//			trace("ct " + ct + " / " + aaTF.right +"...");

						
						
						////get easing function
						if(dur == 0){
							t = 1;
						}else{
							if (ease != null) {
								t = ease(ct,0,1,dur);
							} else {
								//default/linear
								t = ct/dur;
							}
						}
					//	trace("ct " + ct + " " + aaTF.left+ " "  + t + "%");
						////BROADCAST CHANGE//////
						l = W.length;
					//	trace("broadcasting " + l);
						if(l>0){
							while (l--) {
							//	easeMatrix(t);
								//easeAlpha(t);
								//easeFilters(t);
								//easeColors(t);
								//easeFunctions(t);
							///	trace(" - " +l + " " + W[l]);
								W[l](t);
							}
						}else{
							return;
						}
					}else {
						//ERROR shouldn't be here
						trace("error ct " + ct + " / " + dur);
					}
					if ( ct == dur) {
							//------- FINISHED ------------//
							changed = false;
							//trace("stopping tween");
				//			trace("END " + ( getTimer() - st));
						//	trace("END x:" + $v.x + "  y:" + $v.y + " w:" + $v.width + " h:" + $v.height + " " + $v.rotation + " alpha " + $v.alpha);
						//	stage.removeEventListener(Event.ENTER_FRAME, updatePlayhead);
							a1 = $v.alpha;
							if(loops > 0){
						//		trace("looping...");
								if(loopsLeft-- > 0){
									gotoT(-1);
								}
							}else if( autoRewind){
						//		trace("autoRewind and Stop");
								stepClockTime = 0;
								gotoT(-1);
								stop();
							}else{
						//		trace("stopped at end");
								stop();
							}
							if (onComplete != null) {
							//	trace("calling onCOmplete");
								onComplete.apply(null, onCompleteParams);
							}
					}				
			}
		}
		public function gotoAndPlay(t:Number):void{
			gotoT(t);
			play();
		}
		public function gotoAndStop(t:Number):void{
			gotoT(t);
			stop();
		}
		public function play():void{
		//	trace("PLAY x:" + $v.x + "  y:" + $v.y + " w:" + $v.width + " h:" + $v.height + " " + $v.rotation + " alpha " + $v.alpha);
			isPlaying  = true;
			if(stage != null){
				//stage.addEventListener(Event.ENTER_FRAME, updatePlayhead);
			}
			st = NaN;
		}
		public function stop():void{
			isPlaying  = false;
			if(stage != null){
				//stage.removeEventListener(Event.ENTER_FRAME, updatePlayhead);
			}
		}
		
		function updatePlayhead(evt:Event) {
			if(!isPlaying){
				return;
			}
			if(isNaN(st)){
				//st = getTimer() + _delay;
				stepClockTime = -_delay;
				st = (useStepClock)?(0 - _delay) : (getTimer() + _delay);
			//	trace(id + ".RESETTING EPOCH " + getTimer());
			//	toString();

				//------- SETTING UP ------------//
				if(F ==0){
					trace("Warning No listeners/changes!");
					return;
				}
				
				//trace("setting up ct " + ct + " dur " + dur);
				W = new Array();
				onSetupTween();
				if (F & 2) {
				//	trace("- matrixEase");
					W.push(easeMatrix);
				}
				if (F & 4) {
					W.push(easeAlpha);
				}
				if(F & 8){
					W.push(easeSound);
				}
				if(F & 16){
					W.push(easeColorT);
				}
				F = 0;
				
			}
			///update elapsed time and project it into the 
			var epT = (useStepClock)? stepClockTime++:  (getTimer() - st );
			//trace("elapsed (" + useStepClock +") " + epT);
			gotoT( epT);

		}
		public function onSetupTween(){
			
		}
		/////////////////////////////////////////////////////////////////////
		//           MODULAR PLUGINS
		//  feel free to comment out the blocks you don't need to reduce file
		// size
		/////////////////////////////////////////////////////////////////////
		var use1:Boolean = false;
		var m1:Matrix = new Matrix();
		var m2:Matrix= new Matrix();
		var C:Matrix= null;

		var changed:Boolean = false;
		//start
		var A:Matrix = new Matrix();
		//desired end
		var Z:Matrix= new Matrix();
		//delta
		var D:Matrix= new Matrix();

		var _k:String;
		var snapToWholePixel:Boolean = false;
		//------------ CORE DisplayObject --------------------------------
		function easeMatrix(t) {
		//	trace("easeMatrix " +t);
			//----------- displayObject visual component parameters -------------------
			//Tranform Matrix
			//See: http://www.senocular.com/flash/tutorials/transformmatrix/
			//Thanks Senocular!
			use1 = !use1;
			C = (use1)? m1:m2;
			C.a  = A.a +( D.a* t);
			C.b  = A.b +( D.b* t);
			C.c  = A.c +( D.c* t);
			C.d  = A.d +( D.d* t);
			C.tx  = A.tx +( D.tx* t);
			C.ty  = A.ty +( D.ty * t);
			$v.transform.matrix= C;
		}
		function cleanupEaseMatrix(){
			///////////stopping tween /////////////////////////
			// might be finished might be interrupted
			///////////////////SNAP TO WHOLE PIXELS/////////////
			// useful for text and thin line clarity
			// needs to happen at end as scale also affects 
			if(snapToWholePixel){
				$v.x = Math.round($v.x);
				$v.y = Math.round($v.y);
					
				$v.height = Math.round($v.scaleY *  $vB.height);
				$v.width = Math.round($v.scaleX *  $vB.width);
			//trace("SNAP to " + $v.height + " " + _disObj.width );
			}
		}

		function setMz2(nextMatrix:Matrix){
			D.a  = Z.a - A.a;
			D.b  = Z.b - A.b;
			D.c  = Z.c - A.c;
			D.d  = Z.d - A.d;
			D.tx  = Z.tx - A.tx;
			D.ty  = Z.ty - A.ty;			
			F |= 2;
			////////////////////////////
			//JumpTo  $v.transform.matrix =  mE;
		}
		function setMz($dx:Number = 0, $dy:Number = 0, $sX:Number = 0, $sY:Number = 0, rotationChange:Number = 0):void {
		//	trace("setMz " + $dx + "  " + $dy);
			if(!changed){
			//	trace("SNAPSHOT MATRIX");
				A = $v.transform.matrix;
					D.a=	Z.a  = A.a;
					D.b=	Z.b  = A.b;
					D.c=	Z.c  = A.c;
					D.d=	Z.d  = A.d;
					D.tx=	Z.tx  = A.tx;
					D.ty=	Z.ty  = A.ty;
			}else{
				D.a  = Z.a;
				D.b  = Z.b;
				D.c  = Z.c;
				D.d  = Z.d;
				D.tx  = Z.tx;
				D.ty  = Z.ty;		
			}
			//////////////////////
			if ($sX != 0  || $sY != 0) {
				if ($sX != 0) {
					//trace("cur " + curScaleX + " " + $sX + " " + scaleXBegin);
					Z.a  = (D.a+ $sX) ;
				}
				if ( $sY != 0) {
					//trace("curScaleY" + curScaleY + " " + $sY);
					Z.d  = (D.d + $sY);
				}
				///////// correct ////////////////////////
				//get rotation, set it to desired
				Z.rotate( -(Math.atan2(Z.b, Z.a) *(180/Math.PI) -$v.rotation)*Math.PI/180);
				Z.tx = D.tx;
				Z.ty = D.ty;

			}
			if (rotationChange !=0) {
				//trace("doingRotation");
				Z.rotate(rotationChange * Math.PI/180);
				Z.tx = D.tx;
				Z.ty = D.ty;
			}
			if ($dx != 0) {
			//	trace("updating $dx");
				Z.tx += $dx;
			}
			if ($dy != 0) {
			//	trace("updating $dy");
				Z.ty += $dy;
			}
			changed = true;
			D.a=	Z.a  - A.a;
			D.b=	Z.b  - A.b;
			D.c=	Z.c  - A.c;
			D.d=	Z.d  - A.d;
			D.tx=	Z.tx  - A.tx;
			D.ty=	Z.ty  - A.ty;		
			F |= 2;
		}



		//------------------ ALPHA ---------------------------------------
		var a1:Number;
		var a2:Number;
		public var hideOnAlphaZero:Boolean = true;
		function easeAlpha(t) {
		//	trace("easeAlpha " +t);
			$v.alpha =  a1 + (a2*t);
			
			if(hideOnAlphaZero){
				$v.visible = !($v.alpha  < .02);
			}
		}
		public function set alpha(end) {
			a2 = end -$v.alpha;
			F |= 4;
		}
		//------------------ COLOR --------------------------------------
		var useAcT:Boolean = false;
		var cT:ColorTransform; //current calc
		var cT1:ColorTransform = new ColorTransform();
		var cT2:ColorTransform = new ColorTransform();
		var ctA:ColorTransform; //current
		var ctD:ColorTransform = new ColorTransform();// differnece
		var ctZ:ColorTransform = new ColorTransform();// desired

		function easeColorT(t){
			
			useAcT = !useAcT;
			cT = (useAcT)?cT1:cT2;
			//trace("doColorTransform " + $v);
			//cross fade values from current color to end color, linearly based on the eased point in time.
			cT.redMultiplier = ctA.redMultiplier  + (ctD.redMultiplier * t);
			cT.greenMultiplier = ctA.greenMultiplier  + (ctD.greenMultiplier * t);
			cT.blueMultiplier = ctA.blueMultiplier  + (ctD.blueMultiplier * t);
			cT.alphaMultiplier = ctA.alphaMultiplier  + (ctD.alphaMultiplier  * t);

			cT.redOffset = ctA.redOffset  + (ctD.redOffset * t);
			cT.greenOffset = ctA.greenOffset  + (ctD.greenOffset * t);
			cT.blueOffset = ctA.blueOffset  + (ctD.blueOffset * t);
			cT.alphaOffset = ctA.alphaOffset  + (ctD.alphaOffset * t);

			$v.transform.colorTransform = cT;
		}

		public function set colorTransform( aCt:ColorTransform){
			ctZ = aCt;
			F |= 16;
		}
		//------------------SOUND -----------------------------------------
		
	
		//var sO:Boolean = (	X["8"] =  easeSound);
		var _sndT:SoundTransform = new SoundTransform();
		public var soundChannel:SoundChannel;
		var volumeChange:Number = 0;
		var panChange:Number = 0;
		var volumeBegin:Number = 0;
		var panBegin:Number = 0;


		function easeSound(t){
			if(volumeChange != 0){
				_sndT.volume = volumeBegin +  (t* volumeChange);						
			}
			if(panChange != 0){
				_sndT.pan = panBegin + (t * panChange);
			}
			if(soundChannel != null){
				soundChannel.soundTransform = _sndT;
			}else if($v is Sprite){
				//only Sprites have soundTransform
				Sprite($v).soundTransform = _sndT;
			}
		}
	}
}