﻿package com.troyworks.ui {
	import flash.media.SoundMixer;	

	import com.troyworks.events.EventWithArgs;	
	import com.troyworks.events.EventTranslator;	
	import com.troyworks.core.tweeny.Tny;	
	import com.troyworks.logging.TraceAdapter;	

	import flash.utils.Dictionary;
	import flash.geom.Rectangle;	
	import flash.display.Shape;	
	import flash.display.Bitmap;	

	import com.troyworks.controls.ttooltip.OBO_ToolTip;	

	import flash.text.TextFormat;	
	import flash.text.TextFieldAutoSize;	
	import flash.display.DisplayObjectContainer;	
	import flash.text.TextFieldType;	

	import com.troyworks.ui.FlowControlEvent;

	//import fl.controls.RadioButton;	

	import flash.utils.Dictionary;	
	import flash.display.Sprite;	
	import flash.filters.GlowFilter;	
	import flash.text.TextField;	
	import flash.events.KeyboardEvent;	
	import flash.events.MouseEvent;	
	import flash.events.IEventDispatcher;	
	import flash.display.MovieClip;

	import com.troyworks.events.EventAdapter;

	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.utils.setTimeout;	

	/**
	 * FlowControl is a 3 part utility to help create fast prototypes 
	 * either using Frame navigation or Stack visibility manipulation
	 * 
	 * 1) Is to create 'clickables' aka Flows, interactive wireframes.
	 * 
	 * Clickables are low-fidelty prototypes that are created from
	 * whiteboard sessions, simple wireframes, napkins...you name it.  They of course
	 * can be higher fidelity, using real graphics, richer state buttons.
	 * 
	 * The basic ideas is that all the core states are represented by scans/photos, 
	 * sliced up appropriately these are imported into flash either.  Hotspots are created (typically using
	 * an (InvisiButton) to help the choose your own adventure feel, the only thing that is
	 * required is labelling frames for application states, and giving buttons 
	 * suitable instance names:
	 * 
	 * By giving any SimpleButton the following instance names, they are 'autowired' 
	 * into calling the appropriate event/action. They provide the familiar MovieClip API
	 * but don't require any actionscript.
	 * 
	 * AUTOBUTTONS:
	 * 
	 *  goto_XXX   | gotoAndPlay_  | gotoAndStop_]
	 *  play_ |  play_in_mS )
	 *  next
	 *  prev
	 *  home
	 *  
	 *  next
	nextFrame_
	prev
	prevFrame_
	nextScene_ 
	prevScene_
	play_  
	stop_
	gotoAndStop_XXX
	gotoAndPlay_XXX 
	XXX_autoBtn
	 * 
	 * KEYSTROKES
	 *   ESC- goto first frame
	 *   LEFT - prev frame
	 *   RIGHT - next frame.
	 * 
	 * FEATURES:
	 *    detects via onChildAdded, scoped to this clip
	 *    remove listeners leaving a frame
	 * 
	 * //TODO highlight buttons that don't go anyplace valid
	 * //TODO (optional) ignore buttons who's parent isn't this scope
	 * //TODO support other clickable types besides buttons.
	 * //TODO Heatmap/visited links (count, breadcrumbs)
	 * 
	 * TO USE,
	 * 1) in your FLA extend FlowControl.
	 * 2) copy this into a class and have your Document level class use the following
	 *
	package {
	import com.troyworks.ui.*;
	public dynamic class UI extends FlowControl{
	public function UI(){
	super();
	setView(this,true);
	}
	}
	}
	 * 
	 * @author Troy Gardner (troy@troyworks.com)
	 */
	dynamic public class FlowControl extends MovieClip {
		//public var output_txt : TextField;
		public var lastFrame : int = -1;
		public var errorFilter : GlowFilter = new GlowFilter(0xFF0000, 80);

		public var QA : Sprite;
		public var timers : Dictionary = new Dictionary();

		private var _enableFrameDebugger : Boolean;
		public var debuggerUI_mc : MovieClip;

		//////////////// MOVIE CLIP ////////////////////
		public var initFrameScripts : Object;

		public var labelledFrameInitScripts : Object;
		public var labelledFrameUnLoadedScripts : Object;

		public var activeFrames : Object = new Object();
		public var frameLabelToNumberIdx : Object;
		public var lastFrameNumber : Number;
		public var view : MovieClip;

		///////// OPTIONS ///////////////////
		public var preloadingRequired : Boolean = true;
		public var autoPlay : Boolean = false;
		public var watchAddedAndRemovedEvents : Boolean = true;
		public var showDebugUI : Boolean = false;
		public var debugShowChildAdded : Boolean = false;
		public var debugShowChildRemoved : Boolean = false;

		private var currentToolTip : TextField;
		private var _toolTip : OBO_ToolTip;
		public var fadeClip : Sprite;
		private var fadeClipTny : Tny;
		public var fadeClipColor : Number = 0xFFFFFF; 
		public var nextAction : Function;
		public var enableToolTips : Boolean = true;
		public var stopAllSoundsBetweenNav : Boolean = false;

		public var classMap : Dictionary = new Dictionary(true);

		//	public static var trace : Function = TraceAdapter.SOSTracer;

		public function FlowControl() {
			super();
			trace("FlowControl****************************************************");
			if(loaderInfo != null && loaderInfo.url != null) {
				trace("setting up as solo");
				view = this;
				view.stop();
				preloadingRequired = false;
				//note addFrameScript doesn't pick up configuration options
				// on frame1
				addEventListener(Event.ENTER_FRAME, onRenderFirstFrame);
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}else {
				trace("waiting on UI");				
			}
			
			
			//	trace(hasOwnProperty("config") + "  config " + hasOwnProperty("config2") );

			frameLabelToNumberIdx = new Object();
			initFrameScripts = new Object();
		}

		/* view should have frame1 completely loaded by then */
		function onAddedToStage(evt : Event) : void {
			trace("FlowControl.onAddedToStage ***********************" + this);
			trace("parent " + this.parent + " stage  " + this.stage);
			setView(this);
		}

		public function onRenderFirstFrame(evt : Event = null) : void {
			trace("FlowControl.onRenderFirstFrame ***********************" + view.currentFrame);
			removeEventListener(Event.ENTER_FRAME, onRenderFirstFrame);
			try {
				//	trace(hasOwnProperty("config") + "  config " + this["config"])			
				if(this.config != null ) {
					//call up whatever config is on frame1;
					for(var c:String in this.config) {
						trace("initObj " + c + " = " + this.config[c]);
						this[c] = this.config[c];
					}
				}else {
					trace(" FlowControl using default configuration ");
				}
			}catch(er : Error) {
				trace(" FlowControl couldn't init frame1");
			}
				
			///////////////// SETUP THE DEBUGGING UI ///////////////////////
			//TODO fix the navigator
			if(view.parent == null) { 
				debuggerUI_mc = new MovieClip();
				debuggerUI_mc.name = "debuggerUI_mc";
				view.parent.addChild(debuggerUI_mc);
			}
			view.stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
	
			if(showDebugUI) {
				QA = new Sprite();
				view.parent.addChild(QA);
			}
			if(fadeClip == null) {
				fadeClip = new Sprite();
				fadeClip.graphics.beginFill(fadeClipColor);
				fadeClip.graphics.drawRect(0, 0, view.stage.stageWidth, view.stage.stageHeight);
				fadeClip.graphics.endFill();
				trace("add FadeClip");
				view.parent.addChild(fadeClip);
				
			}
			fadeClipTny = new Tny(fadeClip);
			if(enableToolTips) {
				_toolTip = OBO_ToolTip.createToolTip(this, null, 0x000000, .8, OBO_ToolTip.ROUND_TIP, 0xFFFFFF, 8, false);
			}
			/////////////////////////////////////////////////////////////
			if(preloadingRequired) {
				view.stop();
				trace("waiting for engines to load");
				///////////////////////////////
				// load list of engines / services
				///////////////////////////////
			}else {
					
				trace("requesting NEXT FRAME " + view);
				//	view.gotoAndStop("intro");
				view.nextFrame();
				startFadeDown();
			}
		}

		/* set the actual MovieClip/Sprite we are going to use */
		public function setView(mc : MovieClip, sender : String = null) : void {
			trace("FlowControl.setView" + mc + " " + sender);
			view = mc;
			try {
				//	trace(hasOwnProperty("config") + "  config " + this["config"])			
				if(view.config != null ) {
					//call up whatever config is on frame1;
					for(var c:String in view.config) {
						trace("initObj2 " + c + " = " + view.config[c]);
						this[c] = view.config[c];
					}
				}else {
					trace(" FlowControl using default configuration ");
				}
			}catch(er : Error) {
				trace(" FlowControl couldn't init frame1");
			}
			onRenderFirstFrame();
			if(watchAddedAndRemovedEvents) {
				trace("enabling watch");
				view.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
				view.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
				view.addEventListener(Event.ADDED, onChildAdded);
				view.addEventListener(Event.REMOVED, onChildRemoved);
			}
			////////// LISTEN DEEP INSIDE FOR EVENTS TO HAPPEN /////////////
			//	view.addEventListener(Event.ENTER_FRAME, traceCurrentFrame);
			/*
			 *  goto_XXX   | gotoAndPlay_  | gotoAndStop_]
			 *  play_ |  play_in_mS )
			 *  next
			 *  prev
			 *  home 
			 *  */
			view.addEventListener("play", requestPlay);
			view.addEventListener("stop", requestStop);
			
			view.addEventListener("gotoAndPlay", requestGotoAndPlay);
			view.addEventListener("gotoAndStop", requestGotoAndStop);
	
			//view.addEventListener("next", requestNextFrame);
			view.addEventListener("nextFrame", requestNextFrame);
	
			//view.addEventListener("prev", requestPrevFrame);
			view.addEventListener("prevFrame", requestPrevFrame);
			
			view.addEventListener("nextScene", requestNextScene);
			view.addEventListener("prevScene", requestPrevScene);

		//	onFrameChanged();
		}

		
		
		
		//////////////////////FADE /////////////////////////////////
		protected function startFadeUP(event : Event = null) : void {
			trace("FlowControl.startFadeUP");
			fadeClipTny.alpha = 1;
			fadeClipTny.onComplete = onFadedUP;
			fadeClipTny.duration = .5;
		}

		protected function onFadedUP(event : Event = null) : void {
			trace("FlowControl.onFadedUP");
			if(nextAction != null && nextAction is Function) {
				nextAction();
			}
			if(stopAllSoundsBetweenNav) {
				trace("STOPPING ALL SOUNDS");
				SoundMixer.stopAll();
			}
			startFadeDown();
		}

		protected function startFadeDown(event : Event = null) : void {
			trace("startFadeDown");
			fadeClipTny.alpha = 0;
			fadeClipTny.onComplete = onFadedDown;
			fadeClipTny.duration = .5;
		}

		protected function onFadedDown(event : Event = null) : void {
			trace("onFadedDown");
			fadeClip.visible = false;
		}

		////////////////////// EVENTS /////////////////////////////////
		protected function addedToStage(event : Event = null) : void {
			trace("addedToStage " + event.target);
		}

		protected function removedFromStage(event : Event = null) : void {
			trace("removedFromStage " + event.target);
		}

		///////////////////  WATCHING CHILDREN ////////////////////////
		protected function onChildAdded(event : Event) : void {
			var dO : DisplayObject = DisplayObject(event.target);
			var isButton : Boolean = dO is SimpleButton;
			var isMC : Boolean = dO is MovieClip;
			//var isButton : Boolean = getdO; 
			 
			// || dO is RadioButton;
			if(debugShowChildAdded) {
				trace("Sketch.onChildAdded " + dO.name + " " + isButton);
			}
			if((isButton || isMC ) && validDo(dO)) {
				setupGoto(dO, dO.name);
			}
			
		}

		public function validDo(dO : DisplayObject) : Boolean {

			if(!( dO is Bitmap || dO is Shape) && dO.name.indexOf("instance") == 0) {
				trace("found a bum clip " + dO.name + " " + dO);
				//dO.filters = [errorFilter];
				if(QA != null) {
					QA.graphics.beginFill(0xFF0000, .6);
					var bnd : Rectangle = dO.getBounds(view.stage);
					QA.graphics.drawRect(bnd.x, bnd.y, bnd.width, bnd.height);
					QA.graphics.endFill();
				}
				return false;
			}
			return true;
		}

		protected function onChildRemoved(event : Event) : void {
			var dO : DisplayObject = DisplayObject(event.target);
			var isButton : Boolean = dO is SimpleButton;
			// || dO is RadioButton;
			if(debugShowChildAdded) {
				trace("Sketch.onChildRemoved " + dO.name + " " + isButton);
			}
			
			if(isButton) {	
				takedownGoto(dO, dO.name); 
			}
			if(dO is MovieClip) {
				(dO as MovieClip).stop();
			}
		}
		public function onFrameChanged() : void {
			trace("============ onFrameChanged =============" + currentFrame + " " + lastFrame);
	
			//bind ui items
			var i : int = 0;
			var n : int = numChildren;

			for (;i < n; ++i) {
				var dO : DisplayObject = getChildAt(i);
				var isButton : Boolean = dO is SimpleButton;
				//var isRadio : Boolean = false;
				//dO is RadioButton;	
				trace(i + " " + dO.name + " " + isButton);
				if(isButton && validDo(dO) ) {	
					setupGoto(dO, dO.name, MouseEvent.CLICK); 
				}			
			}
		/*	if(currentFrame == 1) {
				if(preloadingRequired) {
					view.stop();
				///////////////////////////////
				// load list of engines / services
				///////////////////////////////
				}else {
					
					trace("requesting NEXT FRAME " + view);
					//	view.gotoAndStop("intro");
					view.stop();
					view.nextFrame();
				}
			}else {
				if(fadeClip != null) {
					startFadeDown();
				}
			}*/
		}

		public function setupGoto(ie : IEventDispatcher, frame : String, event : String = MouseEvent.CLICK) : void {
			trace("setting up " + frame + " for " + view + "." + (ie as DisplayObject).name + ":" + ie);
			var ary : Array;
			var evtTr : EventTranslator;
			if(frame.indexOf("autoBtn") != -1 ) {
			
				evtTr = new EventTranslator();
				evtTr.scope = view;
				ary = frame.split("_");
				trace("FOUND AUTOBUTTON '" + ary[0] + "'");
				evtTr.evtType = ary[0];
				if(ary.length == 3) {
					evtTr.args = [ary[2]];
				}
				ie.addEventListener(event, evtTr.dispatchEvent);
			}else if(frame.indexOf("play_") == 0) {
				ary = frame.split("_");
				trace("ary: '" + ary.join("','") + "'");
				//if(!ie.hasEventListener(event)) {
				if(ary.length == 1 || (ary.length == 2 && ary[1] == "")) {
					trace(" standard play()");
					//	ie.addEventListener(event, EventAdapter.create(view.play, [], false));
					evtTr = new EventTranslator();
					evtTr.scope = view;
					evtTr.evtType = "play";
					
					ie.addEventListener(event, evtTr.dispatchEvent);
				}else {
					trace(" gotoAndPlay()");
					//ie.addEventListener(event, EventAdapter.create(view.gotoAndPlay, [ary[1]], false));
					evtTr = new EventTranslator();
					evtTr.scope = this;
					evtTr.evtType = "gotoAndPlay";
					evtTr.args = [ary[1]];
					
					ie.addEventListener(event, evtTr.dispatchEvent);
				}
				//}
			}else if(frame == "stop_") {
				evtTr = new EventTranslator();
				evtTr.scope = view;
				evtTr.evtType = "stop";
					
				ie.addEventListener(event, evtTr.dispatchEvent);
			}else if(frame == "next" || frame == "nextFrame_") {
				//	if(!ie.hasEventListener(event)) {
				//ie.addEventListener(event, EventAdapter.create(view.nextFrame, [], false));
				evtTr = new EventTranslator();
				evtTr.scope = view;
				evtTr.evtType = "nextFrame";
					
				ie.addEventListener(event, evtTr.dispatchEvent);
			//	}	 
			}else if(frame == "prev" || frame == "prevFrame_") {
				//	if(!ie.hasEventListener(event)) {
				evtTr = new EventTranslator();
				evtTr.scope = view;
				evtTr.evtType = "prevFrame";
					
				ie.addEventListener(event, evtTr.dispatchEvent);
			//	}	 
			}else if(frame == "prevScene_" ) {
				//if(!ie.hasEventListener(event)) {
				evtTr = new EventTranslator();
				evtTr.scope = view;
				evtTr.evtType = "prevScene";
					
				ie.addEventListener(event, evtTr.dispatchEvent);
			//	}
			}else if(frame == "nextScene_" ) {
				//	if(!ie.hasEventListener(event)) {
				evtTr = new EventTranslator();
				evtTr.scope = view;
				evtTr.evtType = "nextScene";
					
				ie.addEventListener(event, evtTr.dispatchEvent);
			//	}			 				 
			}else {
				ary = frame.split("_");
				trace(" gotoAndStop " + frame + "  '" + ary.join("','") + "'");
				//if(!ie.hasEventListener(event)) {

				
				if(ary.length > 0) {
					if(ary[0] == "gotoAndStop") {
						trace("adding gotoAndStop");
						evtTr = new EventTranslator();
						evtTr.scope = view;
						evtTr.evtType = "gotoAndStop";
						evtTr.args = [ary[1]];
					
						ie.addEventListener(event, evtTr.dispatchEvent);
					}else if(ary[0] == "gotoAndPlay") {
						trace("adding gotoAndPlay");
						evtTr = new EventTranslator();
						evtTr.scope = view;
						evtTr.evtType = "gotoAndPlay";
						evtTr.args = [ary[1]];
					
						ie.addEventListener(event, evtTr.dispatchEvent);
					}
				}else {
					trace("adding gotoAndStop2");
					//ie.addEventListener(event, EventAdapter.create(view.gotoAndStop, [frame], false));
					evtTr = new EventTranslator();
					evtTr.scope = view;
					evtTr.evtType = "gotoAndPlay";
					evtTr.args = [frame];
					
					ie.addEventListener(event, evtTr.dispatchEvent);
				}
                
			//	}
			}
			if(enableToolTips) {
				ie.addEventListener(MouseEvent.ROLL_OVER, toolTipHover);
				ie.addEventListener(MouseEvent.ROLL_OUT, removetoolTipHover);
			}
		}

		//TODO cache the references to EventTranslator and remove them that way.
		public function takedownGoto(ie : IEventDispatcher, frame : String, event : String = MouseEvent.CLICK) : void {
			if(frame.indexOf("play_") == 0 || frame == "_play") {
				var ary : Array = frame.split("_");				
				if(!ie.hasEventListener(event)) {
					if(ary.length == 1) {
				//		ie.removeEventListener(event, EventAdapter.create(view.play, [], false));
					}else {
				//		ie.removeEventListener(event, EventAdapter.create(view.gotoAndPlay, [ary[1]], false));
					}
				}
			}else if(frame == "next" || frame == "nextFrame") {
				if(ie.hasEventListener(event)) {
			//		ie.removeEventListener(event, EventAdapter.create(view.nextFrame, [], false));
				}
			}else if(frame == "prev" || frame == "prevFrame") {
			}else if(frame == "prevScene") {
				//TODO Remove
			}else if(frame == "nextScene") {			
			}else {
				if(ie.hasEventListener(event)) {
			//		ie.removeEventListener(event, EventAdapter.create(view.gotoAndStop, [frame], false));
				}
			}
		}

		public function toolTipHover(evt : MouseEvent) : void {
			
			var txt : TextField = new TextField();
			var str : String = evt.target.name;
			var res : String;
			if(str.indexOf("gotoAnd") == 0) {
				res = str.split("_")[1];
			}else {
				res = str;
			}
			
			if(_toolTip != null) {
				_toolTip.addTip(res);
			}
			
			var tf : TextFormat = new TextFormat();
			txt.width = 50;
			txt.height = 50;
			tf.size = 50;
			tf.color = 0x000000;
			txt.textColor = 0x000000;
			txt.setTextFormat(tf);
			//txt.autoSize = TextFieldAutoSize.CENTER;

			txt.text = "XXXXXXXXXXXXXXXXXXX";
			// res;
			txt.border = true;
			
			txt.x = evt.target.stage.mouseX;
			txt.y = evt.target.stage.mouseY;
		
			trace("toolTipHover! " + res + " at " + txt.x + " " + txt.y);
			trace("view " + view);
			currentToolTip = txt;
			//view.addChild(txt);
		//	view.addEventListener(Event.ENTER_FRAME, moveToolTip);
		}

		public function moveToolTip(evt : Event) : void {
			
			if(currentToolTip != null) {
				trace("moveToolTip" + currentToolTip.stage.mouseX + " " + currentToolTip.stage.mouseY);
				currentToolTip.x = view.mouseX;
				currentToolTip.y = view.mouseY;
			}
		}

		public function removetoolTipHover(evt : MouseEvent) : void {
			
			if(_toolTip != null) {
				_toolTip.removeTip();
			}
		//	view.removeChild(currentToolTip);
		//				view.removeEventListener(Event.ENTER_FRAME, moveToolTip);
		}

		protected function reportKeyDown(event : KeyboardEvent) : void {
			//	trace("Key Pressed: " + String.fromCharCode(event.charCode) +         " (character code: " + event.charCode + ")");
			trace("Key Pressed:character code: " + event.charCode + ", " + event.keyCode + ")");
			//output_txt.text = String(event.charCode);
			var evt : EventWithArgs;
			if (event.keyCode == 37 || event.charCode == 97 ) {
				//LEFT
				//requestPrevFrame();
				evt = new EventWithArgs("prevFrame");
				evt.args = [0];
				view.dispatchEvent(evt);
			} else if (event.keyCode == 39 || event.charCode == 115 || event.charCode == 32) {
				//RIGHT
				//requestNextFrame();
				evt = new EventWithArgs("nextFrame");
				evt.args = [0];
				view.dispatchEvent(evt);
			}else if(event.charCode == 27) {
				//gotoAndStop(1);
				evt = new EventWithArgs("gotoAndStop");
				evt.args = [0];
				view.dispatchEvent(evt); 
			} else {
			//		requestScreenByName(String.fromCharCode(event.charCode));
			}
		}

		///////////////////////////////////////////////////////////////////
		//                      NAVIGATION SECTION 
		////////////////////////////////////////////////////////////////////

		protected function requestNextFrame(event : Event = null) : void {
			//nextFrame();
			trace("requestNextFrame");
			nextAction = EventAdapter.create(view.nextFrame, [], false);
			startFadeUP();
			if(event != null) {
				event.stopImmediatePropagation(); // consumed
			}
		}

		protected function requestPrevFrame(event : Event = null) : void {
			//	prevFrame();
			trace("requestPrevFrame");
			nextAction = EventAdapter.create(view.prevFrame, [], false);
			startFadeUP();
			if(event != null) {
				event.stopImmediatePropagation(); // consumed
			}
		}

		protected function requestNextScene(event : Event = null) : void {
			//nextFrame();
			trace("requestNextScene");
			nextAction = EventAdapter.create(view.nextScene, [], false);
			startFadeUP();
			if(event != null) {
				event.stopImmediatePropagation(); // consumed
			}
		}

		protected function requestPrevScene(event : Event = null) : void {
			//	prevFrame();
			trace("requestPrevScene");
			nextAction = EventAdapter.create(view.prevScene, [], false);
			startFadeUP();
			if(event != null) {
				event.stopImmediatePropagation(); // consumed
			}
		}

		protected  function requestStop(event : Event = null) : void {
			//	prevFrame();
			trace("requestStop");
			nextAction = EventAdapter.create(view.stop, [], false);
			//view.stop();
			startFadeUP();
			if(event != null) {
				event.stopImmediatePropagation(); // consumed
			}
		}

		protected  function requestPlay(event : Event = null) : void {
			//	prevFrame();
			trace("requestPlay");
			nextAction = EventAdapter.create(view.play, [], false);
			//view.play();
			//startFadeUP();
			startFadeUP();
			if(event != null) {
				event.stopImmediatePropagation(); // consumed
			}
		}

		protected  function requestGotoAndPlay(event : EventWithArgs = null) : void {
			//	prevFrame();
			trace("requestGotoAndPlay");
			nextAction = EventAdapter.create(view.gotoAndPlay, event.args, false);
			startFadeUP();
			if(event != null) {
				event.stopImmediatePropagation(); // consumed
			}
		}

		protected  function requestGotoAndStop(event : EventWithArgs = null) : void {
			//	prevFrame();
			trace("requestGotoAndStop");
			nextAction = EventAdapter.create(view.gotoAndStop, event.args, false);
			startFadeUP();
			if(event != null) {
				event.stopImmediatePropagation(); // consumed
			}
		}

		public function onFrameRequest(event : Event) : void {
			trace("onFrameRequest !!!! " + event.target.name + " !!!!!!!!!!");
			var a : Number = event.target.name.indexOf("_mc");
			var nm : String = event.target.name.substring(0, a);
			view.gotoAndStop(nm);
		}

		///////////////////////////////////////////////////////////////////
		//                       UI MANAGEMENT 
		////////////////////////////////////////////////////////////////////
		/*********************************************
		 * Stack based visibility management, as an alternative
		 * to adding/removing from displayList or frame based management
		 * 
		 */
		public static function hideExcept(disObjCon : DisplayObjectContainer, except : Array = null, dontProcess : Array = null) : void {
			var i : int = 0;
			var  n : int = disObjCon.numChildren;
			var ii : int = 0;
			var nn : int = (except == null) ? 0 : except.length;
			var iii : int = 0;
			var nnn : int = (dontProcess == null) ? 0 : dontProcess.length;
			var dO : DisplayObject;
			var ignore : Boolean;
			var dontChange : Boolean;
			for(;i < n;++i) {
				dO = disObjCon.getChildAt(i);
				ignore = false;
				dontChange = false;
				inner:
				{
				iii = 0;
				for(;iii < nnn;++iii) {
					//trace("checking to ignore " + dO.name + " " +except[ii].name );

					if(dO == dontProcess[iii]) {
							
						//	trace("found something to not ignore");
						dontChange = true;
						break inner;
					}
				}
				ii = 0;
				for(;ii < nn;++ii) {
					//trace("checking to ignore " + dO.name + " " +except[ii].name );

					if(dO == except[ii]) {
							
						//	trace("found something to not ignore");
						ignore = true;
						break inner;
					}
				}
				}
				if(dO != null && !dontChange) {
					
					if(!ignore) {
						dO.visible = false;
					}else {
						dO.visible = true;
					}
				}
			}
		}

		public function inventoryFrames(enableFrameDebugger : Boolean = false) : void {
			activeFrames = new Object();
			frameLabelToNumberIdx = new Object();
			var labelDepth : Number = 0;
			var nm : String = null;
			var fn : Number = -1;
			trace("Inventorying FrameLabels----------------------");
			
			for (var i : int = 0;i < view.currentLabels.length; i++) {
				nm = view.currentLabels[i].name;
				fn = view.currentLabels[i].frame;
				trace(i + " " + nm + " " + fn);
				frameLabelToNumberIdx[nm] = fn;
				
				if (lastFrameNumber == fn) {
					labelDepth++;
				} else {
					labelDepth = 0;
					lastFrameNumber = fn;
				}

				activeFrames[nm] = false;
				/////////////// DEBUGGER ////////////////////////////
				_enableFrameDebugger = enableFrameDebugger;
				
				if(_enableFrameDebugger && view.parent) {
					//////// CREATE DEBUGGING VISUALIZER //////////
					var sp : Sprite = new Sprite();
					sp.name = nm + "_mc";
					sp.graphics.beginFill(0xCCCCCC, 1);
					sp.graphics.drawRect(0, 0, 50, 20);
					var txt : TextField = new TextField();
					txt.name = "txt";
					txt.text = nm;
					txt.type = TextFieldType.DYNAMIC;
					txt.selectable = false;
					txt.mouseEnabled = false;
					//txt.embedFonts = true;
					sp.alpha = .2;
					sp.x = (fn * 60) + 20;
					sp.y = labelDepth * 20;
					sp.addChild(txt);
					sp.buttonMode = true;
					sp.addEventListener(MouseEvent.CLICK, onFrameRequest);
					debuggerUI_mc.addChild(sp);
				}
			}
			trace("onframehandler-----------------------");
			//already on frame so call.

			onEnterFrameHandler(null);
			trace("onframehandler-----------------------222");
		}

		
		
		public function getFrameNumberForFrameLabel(frameLabel : String) : uint {
			return uint(frameLabelToNumberIdx[frameLabel]);
		}

		public function activate() : void {
			view.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}

		public function deactivate() : void {
			view.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}

		public function onEnterFrameHandler(event : Event) : void {
			//trace("onEnterFrameHandler" + view);
			if ( lastFrameNumber != view.currentFrame) {
				/////////////// FRAME HAS CHANGED (not just rerendered) ///////////////////
				var sp : Sprite;
				var nm : String;
				var cnm : String;
				var evt : FlowControlEvent;
				for (var i : int = 0;i < view.currentLabels.length; i++) {
					cnm = view.currentLabels[i].name;
					if (cnm != " " && view.currentLabels[i].frame == view.currentFrame && activeFrames[cnm] != true) {
						activeFrames[cnm] = true;
						///////////// PERFORM ACTIVATION ACTIONS ////////////////
						evt = new FlowControlEvent(FlowControlEvent.ENTERED_FRAME_LABEL);
						evt.frameLabel = cnm;
						var o : Function = initFrameScripts[view.currentFrame];						
						if(o != null) {
							o();
						}
						//	dispatchEvent(evt);
									
						///////////// DEBUGGER //////////////////////
						nm = cnm + "_mc";
																
						if(debuggerUI_mc != null && debuggerUI_mc.numChildren > 0) {
							sp = Sprite(debuggerUI_mc.getChildByName(nm));
							if(sp != null) {
								sp.alpha = 1;
							}
						}
						//sp.visible = true;
					} else if ( activeFrames[cnm] == true && cnm != view.currentLabel) {
						trace("11111111111111111111111111111");

						nm = cnm + "_mc";
						evt = new FlowControlEvent(FlowControlEvent.LEFT_FRAME_LABEL);
						evt.frameLabel = cnm;
						//dispatchEvent(evt);
						activeFrames[cnm] = false;

						if(debuggerUI_mc != null && debuggerUI_mc.numChildren > 0) {
							
							sp = Sprite(debuggerUI_mc.getChildByName(nm));
							//trace("deactivating " +nm  + " " + sp);
							sp.alpha = .2;
						}
					}//sp.visible = false;
				}
				lastFrameNumber = view.currentFrame;
			}
		}

		///////////////// THESE GEMS related to OF oizys and evilzug 
		//http://evilzug.livejournal.com/687066.html
		// these are called PRIOR to children of frames being created
		public function addOnInitFrameScript(frame : *,callback : Function) : void {
			var frameNo : uint = 0;
			if(frame is String) {
				frameNo = getFrameNumberForFrameLabel(frame) - 1;
			}else {
				frameNo = uint(frame);
			}
			initFrameScripts[frameNo] = callback; 
		}

		public function removeOnInitFrameScript(frame : *) : void {
			var frameNo : uint = 0;
			if(frame is String) {
				frameNo = getFrameNumberForFrameLabel(frame) - 1;
			}else {
				frameNo = uint(frame);
			}
			initFrameScripts[frameNo] = null; 
		}

		// these are called AFTER children of frames being created
		public function addOnLoadedFrameScript(frame : *, callback : Function) : void {
			var frameNo : uint = 0;
			if(frame is String) {
				frameNo = getFrameNumberForFrameLabel(frame) - 1;
			}else {
				frameNo = uint(frame);
			}
			trace("frameNo " + frameNo + " addOnLoadedFrameScript " + frame);
			view.addFrameScript(frameNo, callback);
		}

		public function removeOnLoadedFrameScript(frame : *) : void {
			var frameNo : uint = 0;
			if(frame is String) {
				frameNo = getFrameNumberForFrameLabel(frame) - 1;
			}else {
				frameNo = uint(frame);
			}
			view.addFrameScript(frameNo, null);
		}		  
	}
}
