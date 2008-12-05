package com.troyworks.controls.tcursor { 
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import com.troyworks.ui.CollisionDetection;
	/**
	 * The script to do a mouse replacement,
	 * can be used with Object.egisterClass or can be
	 *  passed in a linkage ID and will create itself on the root timeline
	 *  based on the static field DEPTH.
	 *  
	 * 
	 //Object.registerClass("GlovedHandCursor", com.troyworks.ui.CustomCursor);
	
	new com.troyworks.ui.CustomCursor("GlovedHandCursor");
	stop();
	
	 *  
	 * @author Troy Gardner
	 */
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	public class CustomCursor extends MovieClip {
		public static var DEPTH : Number = 16111;
		public static var ageOfUser : Number = 5;
		public static var rightHanded : Boolean = true;
		public static var isToggle : Boolean = true;
		public static var DEBUG:Boolean = false;
		public static var XRAY : Boolean = false;
		public static var USE_DROPSHADOW : Boolean = true;
		public var isToggled : Boolean = false;
		public var isDown : Boolean = false;
		protected var _owidth : Number;
		protected var _oheight : Number;
		protected var rotRate : Number = 100;
		public static var hittests : Array = new Array();
		public static var instance : CustomCursor;
		public var drawin : MovieClip;
		public var overArray : Array = new Array();
		public var activeArray : Array = new Array();
	
		protected var animate : Boolean = true;
		public var handmode : String = "open";
		protected var m_collisionCheckOn:Boolean = true;
	
		protected var lockUI : Boolean = false;
		public var lockUIAfterLoad:Boolean = false;
		
		protected function CustomCursor(linkage : String, aAgeOfUser : Number, aToggle : Boolean){
			trace("new CustomCursor " + this.name);
			if(linkage == null && this.name != null){
				//on stage already
			}else{
				//attach linkage. 
				if(linkage  == null){
					linkage = "cursor";
				}
			}
		}
		public static function getInstance(linkage : String, aAgeOfUser : Number, aToggle : Boolean):CustomCursor{
			Object.registerClass(linkage, com.troyworks.ui.CustomCursor);
			if(CustomCursor.instance == null){
				CustomCursor.DEPTH =  _root.getNextHighestDepth();
				var cc:CustomCursor = 	CustomCursor(_root.attachMovie(linkage, linkage +"_mc", CustomCursor.DEPTH, {x:_root.mouseX, y:_root.mouseY}));
				cc.drawin = CollisionDetection.getDebugMC();
				CustomCursor.instance = cc;
			}
			return CustomCursor.instance;
		}
		public function onLoad() : void{
			trace("ERROR CustomCursor onload " + this.handmode + " " + lockUI);
	
			Mouse.hide();
			CustomCursor.instance = this;
			//Mouse.addListener(this);
			stop();
	
		//	width = height = 100-( ageOfUser * 10) + 12;
		//	_owidth = width;
		//	_oheight = height;
			//alpha = 30;
			if(USE_DROPSHADOW){
				var drop : DropShadowFilter = new DropShadowFilter(10, 45, 0x000000, .6,5,5, .6);
				this.filters = [drop];	
			}
			updateUI(this.handmode);
			if(lockUIAfterLoad){
				lockUI = true;
			}
		}
		public function set collisionCheckOn(val:Boolean):void{
				m_collisionCheckOn = val;
				if(m_collisionCheckOn){
					onMouseMove();
				}
			}
			public function get collisionCheckOn():Boolean{
				return m_collisionCheckOn;
			}
		public function makeHandFingerPoint(lock:Boolean) : void{
			if(lock != null){
				lockUI = lock;
			}
			this.handmode = "point";
			updateUI("point");
			trace("CustomCursor makeHandFingerPoint " + this.handmode);
		}
		public function makeHandOpenPalm(lock:Boolean) : void{
			if(lock != null){
				lockUI = lock;
			}
			this.handmode = "open";
			updateUI("open");
			isToggled = false;
		}
		public function makeHandPinch(lock:Boolean) : void{
			if(lock != null){
				lockUI = lock;
			}
			this.handmode = "pinch";
			updateUI("pinch");
		}
		public function addToHitTest(o : Object) : void{
			hittests.push(o);
		}
		public function clearSelected():void{
			for (var i : Number = 0; i < activeArray.length; i++) {
				var _mc:MovieClip = MovieClip(activeArray.pop());
				_mc.onRollOut();
				_mc.cursorIsOver = false;
				
			}
		}
		public function onMouseMove(evt : Object) : void{
	
			//trace("onMouseMove");
			this.x = _root.mouseX;
			this.y = _root.mouseY;
			if(animate){
				var px : Number = _root.mouseX/(stage.stageWidth*.9);
			//trace("px " + px);
				if(true){
					if(!isDown){
						if(rotRate < 100){
							rotRate+=2;
						}
						this.rotation = (px * rotRate) - 20;
					}else{
						if(rotRate > 40){
							rotRate-=2;
						}
			
						this.rotation = (px * rotRate) - 20;
					}
				}
			}
			if(collisionCheckOn){	
			drawin.graphics.clear();
			var hit:Boolean = false;
			var len = hittests.length;
			while(len--){
				var target_mc = hittests[len];
				if(target_mc.customCursorCollisionCheckOn == null || target_mc.customCursorCollisionCheckOn){
				var collisionRect : Rectangle = CollisionDetection.checkForCollision(this,target_mc,10);
			//	trace("performED rollOver ShapeOnShape hittest " + target_mc.name + " " + collisionRect);
				if (collisionRect) {
					hit = true;
						updateUI("point");
					if(!target_mc.cursorIsOver){
						trace("AAAAAAAAAAAAAAAAROLLOVER SUCCESS AAAAAAAAAAAAAAAAAAAAAAAAAAAAA w: " + collisionRect.width + " _w" + _owidth );
						target_mc.onRollOver();
						target_mc.cursorIsOver = true;
						activeArray.push(target_mc);
					}
					////UPDATE COLLISION XRAY //
					if(collisionRect.width <= _owidth -10){
						with (drawin) {
							if(XRAY){
								graphics.beginFill(0x00FF00,50);
								graphics.lineStyle(0,0x00FF00,60);
								graphics.moveTo(collisionRect.x,collisionRect.y);
								graphics.lineTo(collisionRect.x+collisionRect.width,collisionRect.y);
								graphics.lineTo(collisionRect.x+collisionRect.width,collisionRect.y+collisionRect.height);
								graphics.lineTo(collisionRect.x,collisionRect.y+collisionRect.height);
								graphics.lineTo(collisionRect.x,collisionRect.y);
							}
						}
					}
	
				}else if(target_mc.cursorIsOver){
					trace("BBBBBBBBBBBBBBBBBBBB ROLLOUT BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
					updateUI("open");
				//	target_mc.alpha = 100;
					target_mc.cursorIsOver = false;
					for (var i : String in activeArray) {
						var _mc : MovieClip = MovieClip(activeArray[i]);
						_mc.onRollOut();
						activeArray.splice(Number(i),1);
					}
				}	
				}
			}
			if(hit && XRAY){
			this.alpha = 40;
			}else{
				this.alpha = 100;
			}
			updateAfterEvent(evt);
			}
		}
		public function onMouseDown() : void{
			trace("onMouseDown");
			if(isToggle){
				isToggled = !isToggled;
				if(isToggled){
					isDown = true;
					updateUI("closed");
				}else{
					isDown = false;
					updateUI("open");
				}
			}else{
				isDown = true;
				updateUI("closed");
			}
	
			for(var i in activeArray){
				activeArray[i].onPress();
			}
		}
		public function onMouseUp() : void{
			trace("onMouseUp");
			if(!isToggle){
				isDown = false;
				trace("click " + activeArray.length);
				this.updateUI("open");
			}
			for(var i in activeArray){
				activeArray[i].onRelease();
			}
		}	
		public function updateUI(toState:String):void{
			if(lockUI){
			}else{
				this.gotoAndStop(toState);
			}
		}
	}
}