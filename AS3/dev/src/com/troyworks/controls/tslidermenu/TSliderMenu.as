package com.troyworks.controls.tslidermenu {
	import flash.events.Event;	
	import flash.events.MouseEvent;	
	import flash.display.DisplayObject;	
	import flash.display.Sprite;	
	import flash.display.MovieClip;	
	
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
		import com.troyworks.core.tweeny.*;
		var slidingTray : Sprite;
		var slidingTraySize : Sprite;
		var view:Sprite;
		var slidingTrayTny : Tny;
		var activationRadius : Number = 40;
		var defaultScale : Number = 1;
		var enlargedScale : Number = 2;
		var config:Object = new Object();	
		var hideTraySize:Boolean = true;
		var drawSlider:Boolean  = false;
		var drawSliderColor:Number = 0xcccccc;
		var drawSliderAlpha:Number = .7; 
		public function TSliderMenu(view:Sprite = null, initObj:Object = null) {
			trace("EEEEEEEEEEEEEEEEEE new TSliderMenu EEEEEEEEEEEEEEEEEEEEEE " );
			this.view = view;
			//if(view.hasOwnProperty("config")){
			//	trace("has config Object");
			//}else{
			//	trace("has NO config Object");
			//}
			Object(view).config = initObj;
			view.addEventListener(Event.ENTER_FRAME, onFrame1);
		}
		public function onFrame1(evt:Event = null):void{
			trace("new TSliderMenu.onFrame1********************************" );
			view.removeEventListener(Event.ENTER_FRAME, onFrame1);
			var cfg:Object = Object(view).config;
			try{
				trace("ACCESSING INSIDE OF FRAME2 " + cfg);
				if(cfg!= null){
				  for(var i:String in cfg) {
				  	trace(" setting " + i + " = " +cfg[i]);
		            this[i] = cfg[i];
		        }
				}
			}catch(err:Error){
			}
			if(view != null){
				setView(view);
			}
		
		}
		public function setView(mc : Sprite) : void {
			view = mc;
			slidingTray  = new Sprite();
			slidingTray.name = "slidingTray";
			slidingTraySize = view.getChildByName("sliderTraySize") as Sprite;
			trace("LandscaptNav============================ " + slidingTraySize);

		
			for (var i : int = 0;i < view.numChildren; i++) {
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
			
			slidingTrayTny  = new Tny(slidingTray);

			trace("LandscaptNav============================" + slidingTray.numChildren);

			view.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			//addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			
			var dx : Number;
		}

		function onEnterFrameHandler(evt : Event = null) : void {
			var dx:Number = slidingTraySize.x - ((slidingTray.width - slidingTraySize.width) * slidingTraySize.mouseX / slidingTraySize.width);
			slidingTray.x -= (slidingTray.x - dx) / 6;
			if(drawSlider){
				slidingTray.graphics.clear();
				slidingTray.graphics.beginFill(drawSliderColor, drawSliderAlpha);
				slidingTray.graphics.drawRect(0, 0, slidingTray.width, 5);
			}
			for (var i : int = 0;i < slidingTray.numChildren; i++) {
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

		function onMouseMoveHandler(evt : Event = null) : void {
			trace("onMouseMoveHandler");
			slidingTrayTny.x = slidingTraySize.x - ((slidingTray.width - slidingTraySize.width) * slidingTraySize.mouseX / slidingTraySize.width);
			slidingTrayTny.ease = Bounce.easeOut;
			slidingTrayTny.duration = .5;
		}

		function onRollOverHandler(evt : Event) : void {
			slidingTray.swapChildren(evt.target as DisplayObject, slidingTray.getChildAt(slidingTray.numChildren - 1));
		}
	}
}
