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
		var view:MovieClip;
		var slidingTrayTny : Tny;
		var activationRadius : Number = 40;
		var defaultScale : Number = 1;
		var enlargedScale : Number = 2;
			
		public function TSliderMenu(viewMC:MovieClip = null) {
			trace("EEEEEEEEEEEEEEEEEE new TSliderMenu EEEEEEEEEEEEEEEEEEEEEE " );
			view = viewMC;
			//if(view.hasOwnProperty("config")){
			//	trace("has config Object");
			//}else{
			//	trace("has NO config Object");
			//}
			view.addEventListener(Event.ENTER_FRAME, onFrame1);
		}
		public function onFrame1(evt:Event = null):void{
			trace("new TSliderMenu.onFrame1********************************" );
			view.removeEventListener(Event.ENTER_FRAME, onFrame1);
			try{
				trace("ACCESSING INSIDE OF FRAME2 " + view.config);
				if(view.config != null){
				  for(var i:String in view.config) {
				  	trace(" setting " + i + " = " + view.config[i]);
		            this[i] = view.config[i];
		        }
				}
			}catch(err:Error){
			}
			if(view != null){
				setView(view);
			}
		
		}
		public function setView(mc : MovieClip) : void {
			view = mc;
			slidingTray  = new Sprite();
			slidingTray.name = "slidingTray";
			trace("LandscaptNav============================ " + view.sliderTraySize);

		
			for (var i : int = 0;i < view.numChildren; i++) {
				var dO : DisplayObject = view.getChildAt(i);
				if (dO != view.sliderTraySize) {
					trace("adding Child " + dO.name);
					defaultScale = dO.scaleX;
					dO.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
					dO.addEventListener(MouseEvent.MOUSE_MOVE, onRollOverHandler);
					slidingTray.addChild(dO);
					i = i - 1;
				}
			}

			view.addChild(slidingTray);
			view.sliderTraySize.visible = false;
			slidingTray.cacheAsBitmap = true;
			//slidingTray.y = 250;// = false;
			
			slidingTrayTny  = new Tny(slidingTray);

			trace("LandscaptNav============================" + slidingTray.numChildren);

			view.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			//addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			
			var dx : Number;
		}

		function onEnterFrameHandler(evt : Event = null) : void {
			var dx:Number = view.sliderTraySize.x - ((slidingTray.width - view.sliderTraySize.width) * view.sliderTraySize.mouseX / view.sliderTraySize.width);
			slidingTray.x -= (slidingTray.x - dx) / 6;
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
			slidingTrayTny.x = view.sliderTraySize.x - ((slidingTray.width - view.sliderTraySize.width) * view.sliderTraySize.mouseX / view.sliderTraySize.width);
			slidingTrayTny.ease = Bounce.easeOut;
			slidingTrayTny.duration = .5;
		}

		function onRollOverHandler(evt : Event) : void {
			slidingTray.swapChildren(evt.target as DisplayObject, slidingTray.getChildAt(slidingTray.numChildren - 1));
		}
	}
}
