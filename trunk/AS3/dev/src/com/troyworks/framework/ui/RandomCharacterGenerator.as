package com.troyworks.framework.ui { 
	
	/**
	 * @author Troy Gardner
	 */
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	public class RandomCharacterGenerator extends MovieClip {
	
		public var config : Object;
		public var characters : Array;
		public var _owidth : Number;
		public var _oheight : Number;
	
		protected var _ox : Number;
	
		protected var _oy : Number;
		public function RandomCharacterGenerator() {
		  super();
			characters = new Array();
		}
		public function onLoad() : void{
			trace("onLoad");
			_owidth = width;
			_oheight = height;
			_ox = x;
			_oy = y;
			var characteRoster : Array = new Array();
			var c = config.numberOfTypesOfCharacters;
			var link_ary : Array = config.linkageIDs.concat();
			while(c--){
				var a = Math.round( Math.random()*(link_ary.length-1));
				var act = link_ary[a];
				link_ary.splice(a,1);
				trace("adding " + a + " " + act);
				characteRoster.push(act);
			}
			var minScale : Number = config.minScale;
			var difScale : Number = config.maxScale - config.minScale;
			////attach particles
			var cnt = Number(config.numberOfCharacters);
			while(cnt--){
				var i = Math.round(Math.random()* (characteRoster.length -1));
				var link : String = characteRoster[i];
				trace("using character " + link);
				var initObj : Object = new Object();
				trace("THIS W " + _owidth + " H " + _oheight);
				initObj.x = Math.random() * _owidth * .9 ;
				initObj.y = Math.random() * _oheight * .9;
				trace("using X " + initObj.x + " " + initObj.y);
				initObj._ox = initObj.x;
				initObj._oy = initObj.y;
				var rndS : Number = Math.random()* difScale;
				initObj.scaleX = minScale + rndS;
				initObj.scaleY = minScale + rndS;
				initObj.id = cnt;
				initObj.friction = (config.friction == null)?.95:config.friction;
				initObj.vx = Math.random()*config.speed - config.speed/2;
				initObj.vy = Math.random()*config.speed - config.speed/2;
				var _mc:MovieClip = this.attachMovie(link, link+cnt,this.getNextHighestDepth(), initObj);
				rangeCheckX(_mc);
				rangeCheckY(_mc);
				characters.push(_mc);
			}
			trace("charactersp  " + characters.length + " \r\t " + characters.join("\r\t"));
			
		}
		public function activate():void{
			onEnterFrame = onEnterFrameHandler;
			
		}
		public function deactivate():void{
			onEnterFrame = null;
			delete(onEnterFrame);
		}
		
		public function onEnterFrameHandler() : void{
			trace("animate");
			for (var i : Number = 0; i < characters.length; i++) {
				var _mc : MovieClip = MovieClip(characters[i]);
				
				 if (Math.random()<config.jitter) {
					_mc.vx += Math.random()*config.speed-config.speed/2;
					_mc.vy += Math.random()*config.speed-config.speed/2;
				  }
				  if(config.mouseAttraction !=0 && config.mouseXpadding < mouseX && mouseX < (width -config.mouseXpadding) && config.mouseYpadding < mouseY && mouseY < height -config.mouseYpadding){
					//trace("Mouse is Over");
					var xdif = _mc.x - mouseX;
					var ydif = _mc.y - mouseY;
					var dist : Number = Math.sqrt(xdif*xdif+ydif*ydif);
					if(dist <= config.mouseSphere){
						var activation : Number = Math.max(.01, Math.min(dist/config.mouseSphere, 1));
						var att = (Math.cos(Math.PI/2 *activation)* config.mouseAttraction) -.8;
					//trace(_mc.id + "dist " + dist + " " + activation + " att " + att);
						_mc.vx -= ((dist > 0)? att: -1 * att)*(xdif >0)?1:-1;
						_mc.vy -= ((dist > 0)? att: -1 * att)*(ydif >0)?1:-1;
					}
				  	
				  }
				  //limit on speed.
				  if(config.maxSpeed != 0){
					_mc.vx = Math.min(_mc.vx, config.maxSpeed);
					_mc.vy = Math.min(_mc.vy, config.maxSpeed);
				  }
				var px = _mc.x;
				var py = _mc.y;
				_mc.x +=  _mc.vx;
				_mc.y +=  _mc.vy;
				
			//	_mc.vx *= _mc.friction;
			//	_mc.vy *= _mc.friction;
				var dX = _mc.x - px;
				var dY = _mc.y - py;
	
				var theta = Math.atan2(dY, dX) *180 / Math.PI  ;
				var t60 = (theta < 0)?theta + 360: theta;
	//trace(" theta " + theta + " " + t60);
	
				if(235 <t60 && t60 <= 315){
					_mc.gotoAndStop("up");
					_mc.rotation = theta +90;
					//_mc.rotation =0;
				}else if(45 <t60 && t60 <= 135){
					_mc.gotoAndStop("down");
					_mc.rotation = theta -90; 
				}else if(135<  t60 &&  t60 <=235 ){
					_mc.gotoAndStop("left");
					_mc.rotation = 0;
				}else{// if(315< t60  && t60 <= 45){
					_mc.gotoAndStop("right");
					_mc.rotation = 0;
				}
				/*if(_mc.vx >0){
					_mc.width = -1 * _mc.width;
				}else{
					_mc.width = Math.abs( _mc.width);
					
				}*/
	
				  ////////////////////////////////
				  // Range check  //////////////
				  /////////////////////////////
				//_mc.alpha = 20;
				var b : Object = _mc.getBounds(this);
				rangeCheckX(_mc, b);
				rangeCheckY(_mc, b);
	
	
				}
		}
		public function rangeCheckX(_mc : MovieClip, bounds : Object) : Boolean{
			
		//	trace("RangeCheckX 0[" + _mc.id + " X " + _mc.x + " X2 "  + (_mc.x + _mc.width) + "  ]" + _owidth);
				  if (bounds.xMin  < 0){
				//		trace("BELOW X");
						//	_mc.alpha = 100;
				//		_mc.alpha = 30;
				_mc.vx = Math.abs(_mc.vx) + Math.random()* 2;
				var adj : Number = (bounds.xMin < 0)? bounds.xMin:0;
					//	_mc.x =  0 -adj + _mc.vx;
				return false;
				  }else if(_owidth < bounds.xMax ) {
				//		trace("****ABOVE W");
				//			_mc.alpha = 30;
				_mc.vx = (Math.abs(_mc.vx) + Math.random()* 2) * -1;
				var adj : Number = (bounds.xMax > 0)? bounds.xMax - _mc.x:0;
					//	_mc.x =  _owidth -  adj;
				return false;
				  }else{
				//  	_mc.alpha = 100;
			//	  	trace("PASSED " + _owidth);
				  }
			return true;
		}
		public function rangeCheckY(_mc : MovieClip, bounds : Object) : Boolean{
			//trace("RangeCheckY " + _mc.id + " Y " + _mc.y + " Y2 " + (_mc.y + _mc.height));
				  if (bounds.yMin  < 0){
					 // 	trace("BELOW Y");
				_mc.vy =  Math.abs(_mc.vy);
				//	 var adj:Number = (bounds.yMin < 0)? bounds.yMin:0;
				//	_mc.y =  0 -adj + _mc.vy;
				return false;
				  }else if( _oheight < bounds.yMax){
				  	//	trace("****ABOVE Y");
				_mc.vy = Math.abs(_mc.vy) * -1;
			//		var adj:Number = (bounds.yMax < 0)? bounds.yMax:0;
			//		_mc.y =  _oheight -  adj;
				return false;
				  }
			return true;
		}
		public function onUnload() : void{
			trace("onOnLoad");
			
		}
	}
}