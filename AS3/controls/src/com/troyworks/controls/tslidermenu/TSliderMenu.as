package com.troyworks.controls.tslidermenu {
	import flash.geom.Rectangle;	
	import flash.events.Event;	
	import flash.events.MouseEvent;	
	import flash.display.DisplayObject;	
	import flash.display.Sprite;	
	import flash.display.MovieClip;	

	import com.troyworks.core.tweeny.*;

	/**
	 * TSliderMenu 
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jul 5, 2008
	 * DESCRIPTION ::
	 *  This is a tsunami styled menu, that scans the items on stage, 
	 *  and creates a slider OSX styled menu, based off some of the examples
	 *  on the web.
	 *  TODO:
	 *  - vertical slider (based on tray 
	 *  - 2D slider (based on tray)
	 *  - radial lensing function
	 *  - horizontal lensing effect function
	 *  - veritical lensing effect function
	 *  - growth in slidingTray based on the lensing function and proximity of mouse
	 *  - point/radio or colum or row or column/row style
	 */
	public class TSliderMenu {

		protected var slidingTray : Sprite;
		protected var slidingTraySize : Sprite;
		public var view : Sprite;
		public var slidingTrayTny : Tny;
		public var activationRadius : Number = 50;
		public var defaultScale : Number = 1;
		public var enlargedScale : Number = 2;
		public var config : Object = new Object();	
		public var hideTraySize : Boolean = true;
		public var drawSlider : Boolean = false;
		public var drawSliderColor : Number = 0xcccccc;
		public var drawSliderAlpha : Number = .7;
		private var hasSetView : Boolean = false;
		private var scrollmode : String = "EDGE";
		protected var velocity : Number;

		public function TSliderMenu(view : Sprite = null, initObj : Object = null) {
			trace("EEEEEEEEEEEEEEEEEE new TSliderMenu EEEEEEEEEEEEEEEEEEEEEE for " + view);
			this.view = view;
			//if(view.hasOwnProperty("config")){
			//	trace("has config Object");
			//}else{
			//	trace("has NO config Object");
			//}
			config = initObj;
			//			Object(view).config = initObj;
			if(view.stage != null) {
				onADDED_TO_STAGE(null);
			} else {
				view.addEventListener(Event.ADDED_TO_STAGE, onADDED_TO_STAGE, false, 0, true);
				view.addEventListener(Event.REMOVED_FROM_STAGE, onREMOVED_FROM_STAGE, false, 0, true);				
			}
		}

		public function onADDED_TO_STAGE(evt : Event) : void {
			trace("TSliderMenu.onADDED_TO_STAGE " + hasSetView);
			if(!hasSetView) {
				trace("TSlider.waiting for Frame1 " + view);
				view.addEventListener(Event.ENTER_FRAME, onFrame1);
			} else {
				trace("TSlider.readded to stage");
				view.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler, false, 0, true);
			}	
		}

		public function onREMOVED_FROM_STAGE(evt : Event) : void {
			trace("TSliderMenu.onREMOVED_FROM_STAGE ");
			view.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}

		public function onFrame1(evt : Event = null) : void {
			trace("new TSliderMenu.onFrame1********************************");
			view.removeEventListener(Event.ENTER_FRAME, onFrame1);
			var cfg : Object = (Object(view).hasOwnProperty("config")) ? Object(view).config : config;
			try {
				trace("ACCESSING INSIDE OF FRAME2 " + cfg);
				if(cfg != null) {
					for(var i:String in cfg) {
						trace(" setting " + i + " = " + cfg[i]);
						this[i] = cfg[i];
					}
				}
			}catch(err : Error) {
			}
			if(view != null) {
				setView(view);
			}
		}

		public function setView(mc : Sprite) : void {
			view = mc;
			view.addEventListener(Event.ADDED_TO_STAGE, onADDED_TO_STAGE, false, 0, true);
			view.addEventListener(Event.REMOVED_FROM_STAGE, onREMOVED_FROM_STAGE, false, 0, true);				
		
			slidingTray = new Sprite();
			slidingTray.name = "slidingTray";
			slidingTraySize = view.getChildByName("sliderTraySize") as Sprite;
			velocity = (slidingTray.width / slidingTraySize.width);			
			trace("TSliderMenu.setView============================ " + slidingTraySize + " velocity " + velocity + " " + view.name);

			for (var i : int = 0;i < view.numChildren;i++) {
				var dO : DisplayObject = view.getChildAt(i);
				if (dO != slidingTraySize) {
					trace("adding Child " + dO.name);
					defaultScale = dO.scaleX;
					dO.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
					dO.addEventListener(MouseEvent.MOUSE_MOVE, onRollOverHandler);
					slidingTray.addChild(dO);
					i = i - 1;
				}
			}
		
			view.addChild(slidingTray);
			//slidingTraySize.visible = false;
			slidingTray.cacheAsBitmap = true;
			//slidingTray.y = 250;// = false;

			slidingTrayTny = new Tny(slidingTray);

			trace("LandscaptNav============================" + slidingTray.numChildren);

			view.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler, false, 0, true);
			//addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			hasSetView = true;
		}

		protected function onEnterFrameHandler(evt : Event = null) : void {
			var dx : Number = slidingTraySize.x - ((slidingTray.width - slidingTraySize.width) * slidingTraySize.mouseX / slidingTraySize.width);
			velocity = (slidingTray.width / slidingTraySize.width);		
			//trace(  view.name + " tray velocity " + velocity);
			var rate : Number = 6;
			var delta : Number = (slidingTray.x - dx);

			if(scrollmode == "CONTINOUSPAN") {
				if(delta > activationRadius) {
					slidingTray.x -= rate;
				}else if (delta < (-1 * activationRadius)) {
					slidingTray.x += rate;
				} else {
					slidingTray.x -= (slidingTray.x - dx) / (15);
				}
			}else if(scrollmode == "AQUADOCK") {
				slidingTray.x -= (slidingTray.x - dx) / (15);
			}else if(scrollmode == "EDGE") {
				
				var bns : Rectangle = slidingTraySize.getBounds(slidingTraySize);
				var re : Number = bns.right - (activationRadius);
				var le : Number = bns.left + (activationRadius );
				
				var needsMove : Boolean = Math.abs(delta) > rate ;
				//	trace("EDGE " + le+ " " + slidingTraySize.mouseX + " " + re + " delta " + delta);  
				if( re < slidingTraySize.mouseX && delta > rate) {
					rate = rate * Math.max((slidingTraySize.mouseX - re) / activationRadius, 0);
					slidingTray.x -= rate ;
				}else if (slidingTraySize.mouseX < le && rate > delta) {
					rate = rate * Math.max((le - slidingTraySize.mouseX) / activationRadius, 0);
					slidingTray.x += rate;
				}
			}
			if(drawSlider) {
				slidingTray.graphics.clear();
				slidingTray.graphics.beginFill(drawSliderColor, drawSliderAlpha);
				slidingTray.graphics.drawRect(0, 0, slidingTray.width, 5);
			}
			for (var i : int = 0;i < slidingTray.numChildren;i++) {
				var dO : DisplayObject = slidingTray.getChildAt(i);
				var xxm : Number = dO.mouseX - activationRadius / 2;
				var yym : Number = dO.mouseY;
				var xm : Number = Math.round((Math.sqrt(xxm * xxm + yym * yym)));
				//if (!mouseIsoverAButton) {

				if (xm < activationRadius) {
					//scale up
					//trace("xm " + xm);
					dO.scaleX = dO.scaleY += ((enlargedScale - (xm / 100)) - dO.scaleY) / 3;
				} else {
					//scale down
					//trace("scale down");
					dO.scaleX = dO.scaleY += (defaultScale - dO.scaleY) / 3;
				}
		//btnWidth += dO.scaleX*miwidth;
			}
		}

		protected function onMouseMoveHandler(evt : Event = null) : void {
			trace("onMouseMoveHandler");
			//	slidingTrayTny.x = slidingTraySize.x - ((slidingTray.width - slidingTraySize.width) * slidingTraySize.mouseX / slidingTraySize.width);
			slidingTrayTny.ease = Bounce.easeOut;
			slidingTrayTny.duration = 10;// * slidingTray.width / slidingTraySize.width;
		}

		protected function onRollOverHandler(evt : Event) : void {
			try{
				slidingTray.swapChildren(evt.target as DisplayObject, slidingTray.getChildAt(slidingTray.numChildren - 1));
			}catch(er:Error){
				
			}
		}
	}
}
