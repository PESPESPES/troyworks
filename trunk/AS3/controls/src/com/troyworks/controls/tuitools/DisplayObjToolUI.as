package com.troyworks.controls.tuitools {
	import com.troyworks.events.EventWithArgs;	
	
	import flash.display.Sprite;	
	import flash.display.DisplayObject;	
	import flash.geom.Rectangle;	
	import flash.geom.Point;	
	import flash.events.Event;	

	import com.troyworks.util.InitObject;	

	import flash.display.MovieClip;		

	import com.troyworks.ui.*;

	/*
	 * ImageControls
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Jun 22, 2009
	 *
	 * DESCRIPTION
	 */

	public class DisplayObjToolUI {
		////////// UCM /////////////////////////////////// 
		public var state : Object;
		public var sharedState : Object;
		protected var view : MovieClip;
		public var initer : InitObject;
		public var registrationPoint_mc : Sprite;
		public var freeScaleTL : Sprite;
		public var freeScaleT : Sprite;
		public var freeScaleTR : Sprite;
		public var freeScaleBL : Sprite;
		public var freeScaleB : Sprite;
		public var freeScaleBR : Sprite;
		public var freeScaleR : Sprite;
		public var freeScaleL : Sprite;

		public function DisplayObjToolUI(viewMC : MovieClip, sharedStateObject : Object = null,  ldrInitObj : Object = null) {
			super();
			view = viewMC;
			trace("PongUI( " + viewMC.name + ") ");
			view.stop();
			initer = new InitObject(this, viewMC, "initObj", null, null, onInited, true);
		}

		public function onInited() : void {
			trace("onInited");
	
			setView(view);
		}

		public function setView(viewMC : MovieClip) : void {
			view = viewMC;
			view.x = 0;
			view.y = 0;
			view.visible = false;
			//player1 = view.getChildByName("player1") as MovieClip;
			//ball1 = view.getChildByName("ball1") as MovieClip;
			//ai1 = view.getChildByName("ai1") as MovieClip;
			//background_mc = view.getChildByName("background_mc") as MovieClip;
			//	view.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
		//	view.stage.addEventListener(Event.ENTER_FRAME, onENTER_FRAME);
	//		view.addEventListener(Event.ENTER_FRAME, onFirstFrameRender);
			view.stage.addEventListener("positionImageControls",onCLIP_CHANGED);
			view.stage.addEventListener("GET_DISPLAYOBJECTTOOL_UI", onGET_DISPLAYOBJECTTOOL_UI);
			onGET_DISPLAYOBJECTTOOL_UI();
		}
		private function onGET_DISPLAYOBJECTTOOL_UI(evt:Event = null):void{
			var evtA : EventWithArgs = new EventWithArgs("SET_DISPLAYOBJECTTOOL_UI");
			evtA.args = [this];
			view.stage.dispatchEvent(evtA);
		}
			
		
		private function onCLIP_CHANGED(evt : EventWithArgs) : void {

			var selectedClip : DisplayObject;
			var selfBounds : Rectangle;
			var _local4 : Rectangle;
			var tL : Point;
			var T : Point;
			var TR : Point;
			var R : Point;
			var L : Point;
			var BL : Point;
			var B : Point;
			var BR : Point;
			var regPoint : Point;
			var _local14 : Point;
			var transforms : Object;
			selectedClip = (view.root as Object).selectedDo;

			if (selectedClip != null) {
				transforms = UIUtil.getCollectiveTransformsToStage(selectedClip);
				if (transforms.visible) {
					view.visible = true;

					//trace("rot " + transforms.rotation);
					//trace("scaleY " + transforms.scaleY);
					//trace("scaleX " + transforms.scaleX);
					selfBounds = selectedClip.getBounds(selectedClip);
					//_local4 = selectedClip.getBounds(stage);
					//trace(((selectedClip.name + " bnds ") + selfBounds));
					tL = new Point(selfBounds.left, selfBounds.top);
					T = new Point((selfBounds.left + (selfBounds.width / 2)), selfBounds.top);
					TR = new Point(selfBounds.right, selfBounds.top);
					R = new Point(selfBounds.right, (selfBounds.top + (selfBounds.height / 2)));
					L = new Point(selfBounds.left, (selfBounds.top + (selfBounds.height / 2)));
					BL = new Point(selfBounds.left, selfBounds.bottom);
					B = new Point((selfBounds.left + (selfBounds.width / 2)), selfBounds.bottom);
					BR = new Point(selfBounds.right, selfBounds.bottom);
					regPoint = evt.args[0];//new Point((selfBounds.left + (selfBounds.width / 2)), (selfBounds.top + (selfBounds.height / 2)));
					_local14 = new Point(selectedClip.parent.x, selectedClip.parent.y);
					//trace(("TL1 " + _local14));
					selectedClip.parent.localToGlobal(_local14);
					//trace(("TL2 " + _local14));
					selectedClip.localToGlobal(tL);
					selectedClip.localToGlobal(T);
					selectedClip.localToGlobal(TR);
					selectedClip.localToGlobal(R);
					selectedClip.localToGlobal(L);
					selectedClip.localToGlobal(BL);
					selectedClip.localToGlobal(B);
					selectedClip.localToGlobal(BR);
					//selectedClip.localToGlobal(regPoint);
					view.x = transforms.x;
					view.y = transforms.y;
					view.rotation = transforms.rotation;
					tL.x *= transforms.scaleX;
					T.x *= transforms.scaleX;
					TR.x *= transforms.scaleX;
					BL.x *= transforms.scaleX;
					B.x *= transforms.scaleX;
					BR.x *= transforms.scaleX;
					R.x *= transforms.scaleX;
					L.x *= transforms.scaleX;
					regPoint.x *= transforms.scaleX;
					tL.y *= transforms.scaleY;
					T.y *= transforms.scaleY;
					TR.y *= transforms.scaleY;
					BL.y *= transforms.scaleY;
					B.y *= transforms.scaleY;
					BR.y *= transforms.scaleY;
					R.y *= transforms.scaleY;
					L.y *= transforms.scaleY;
					regPoint.y *= transforms.scaleY;
					/*tL.x = (tL.x + _local14.x);
					T.x = (T.x + _local14.x);
					TR.x = (TR.x + _local14.x);
					BL.x = (BL.x + _local14.x);
					B.x = (B.x + _local14.x);
					BR.x = (BR.x + _local14.x);
					R.x = (R.x + _local14.x);
					L.x = (L.x + _local14.x);
					regPoint.x = (regPoint.x + _local14.x);
					tL.y = (tL.y + _local14.y);
					T.y = (T.y + _local14.y);
					TR.y = (TR.y + _local14.y);
					BL.y = (BL.y + _local14.y);
					B.y = (B.y + _local14.y);
					BR.y = (BR.y + _local14.y);
					R.y = (R.y + _local14.y);
					L.y = (L.y + _local14.y);
					regPoint.y = (regPoint.y + _local14.y);*/
					view.globalToLocal(BR);
					initFrom(registrationPoint_mc, regPoint);
					initFrom(freeScaleTL, tL);
					initFrom(freeScaleT, T);
					initFrom(freeScaleTR, TR);
					initFrom(freeScaleBL, BL);
					initFrom(freeScaleB, B);
					initFrom(freeScaleBR, BR);
					initFrom(freeScaleR, R);
					initFrom(freeScaleL, L);
			/*graphics.clear();
			graphics.lineStyle(1, 0xFF0000);
			graphics.drawRect(_local4.x, _local4.y, _local4.width, _local4.height);*/
				} else {
					view.visible = false;
				}
			} else {
				view.visible = false;
			}
		}

		function initFrom(mc : Object, init : Object) : void {
			var props : Array = ["x", "y"];
			for (var i : int = 0;i < props.length; i++) {
				//trace("i " + i);
				mc[props[i]] = init[props[i]];
			}
		}
	}
}
