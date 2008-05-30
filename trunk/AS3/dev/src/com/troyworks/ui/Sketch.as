package com.troyworks.ui {
	import flash.display.DisplayObjectContainer;	
	import flash.text.TextFieldType;	
	
	import com.troyworks.ui.SketchEvent;

	import fl.controls.RadioButton;	

	import flash.utils.Dictionary;	
	import flash.display.Sprite;	
	import flash.filters.GlowFilter;	
	import flash.text.TextField;	
	import flash.events.KeyboardEvent;	
	import flash.events.MouseEvent;	
	import flash.events.IEventDispatcher;	
	import flash.display.MovieClip;

	import com.troyworks.core.EventAdapter;

	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;	

	/**
	 * Sketch is a 3 part utility to help create fast prototypes 
	 * either using Frame navigation or Stack visibility manipulation
	 * 
	 * 1) Is to create 'clickables' 
	 * Clickables are low-fidelty prototypes that are created from
	 * whiteboard sessions, simple wireframes, napkins...you name it.
	 * 
	 * The basic ideas is that all the core states are represented by photos, sliced
	 * up appropriately these are imported into flash.  Hotspots are created (typically using
	 * an (InvisiButton) to help the choose your own adventure feel, the only thing that is
	 * required is labelling frames for application states, and giving buttons 
	 * suitable instance names.
	 * 
	 * By giving any SimpleButton the following instance names, they are 'autowired' 
	 * into calling the appropriate event/action. They provide the familiar TimeLine API
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
	 * KEYSTROKES
	 * ESC- goto first frame
	 * LEFT - prev frame
	 * RIGHT - next frame.
	 * 
	 * FEATURES:
	 *    detects via onChildAdded, scoped to this clip
	 *    remove listeners leaving a frame
	 * 
	 * //TODO highlight buttons that don't go anyplace valid
	 * //TODO (optional) ignore buttons who's parent isn't this scope
	 * //TODO support other clickable types besides buttons.
	 * 
	 * //TODO Heatmap/visited links (count, breadcrumbs)
	 * 
	 * @author Troy Gardner (troy@troyworks.com)
	 */
	public class Sketch extends MovieClip {
		public var output_txt : TextField;
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

		public var activeFrames : Object;
		public var frameLabelToNumberIdx : Object;
		public var lastFrameNumber : Number;
		public var view : MovieClip;

		
		public function Sketch() {
			super();
			trace("ClickThrough");
			addFrameScript(0, onFrame1);
			
			view = this;
			
			frameLabelToNumberIdx = new Object();
			initFrameScripts = new Object();
			
			debuggerUI_mc = new MovieClip();
			debuggerUI_mc.name = "debuggerUI_mc";
		}

		public function onFrame1() : void {
			QA = new Sprite();
			parent.addChild(QA);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
			//stage.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			onFrameChanged();

		
			stop();
		}

		public function setView(mc : MovieClip, enableWatch : Boolean = false) : void {
			view = mc;
			if(enableWatch) {
				view.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
				view.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
				view.addEventListener(Event.ADDED, onChildAdded);
				view.addEventListener(Event.REMOVED, onChildRemoved);
			}
			if(view.parent != null) {
				view.parent.addChild(debuggerUI_mc);
			}
		}

		protected function addedToStage(event : Event) : void {
			trace("addedToStage " + event.target);
		}

		protected function removedFromStage(event : Event) : void {
			trace("removedFromStage " + event.target);
		}

		protected function onChildAdded(event : Event) : void {
			var dO : DisplayObject = DisplayObject(event.target);
			var isButton : Boolean = dO is SimpleButton || dO is RadioButton;
			trace("onChildAdded " + dO.name + " " + isButton);
			if(isButton && validDo(dO)) {
				setupGoto(dO, dO.name);
			}
		}

		public function validDo(dO : DisplayObject) : Boolean {

			if( dO.name.indexOf("instance") == 0) {
				trace("found a bum clip " + dO.name);
				//dO.filters = [errorFilter];
				QA.graphics.beginFill(0xFF0000, .6);
				QA.graphics.drawRect(dO.x, dO.y, dO.width, dO.height);
				QA.graphics.endFill();
				return false;
			}
			return true;
		}

		protected function onChildRemoved(event : Event) : void {
			var dO : DisplayObject = DisplayObject(event.target);
			var isButton : Boolean = dO is SimpleButton || dO is RadioButton;
			trace("XXonChildRemoved " + dO.name + " " + isButton);
			if(isButton) {	
				takedownGoto(dO, dO.name); 
			}
		}

		/*	public function onEnterFrameHandler(evt : Event) : void {
		if(lastFrame != currentFrame) {
		onFrameChanged();
		}
		lastFrame = currentFrame;
		}
		 */
		public function onFrameChanged() : void {
			trace("============ onFrameChanged =============" + currentFrame + " " + lastFrame);
			//bind ui items
			var i : int = 0;
			var n : int = numChildren;

			for (;i < n; ++i) {
				var dO : DisplayObject = getChildAt(i);
				var isButton : Boolean = dO is SimpleButton;
				var isRadio : Boolean = false;
				//dO is RadioButton;	
				//					trace(i + " " + dO.name + " " + isButton);
				if(isButton && validDo(dO) ) {	
					setupGoto(dO, dO.name, MouseEvent.CLICK); 
				}			
			}
		}

		public function setupGoto(ie : IEventDispatcher, frame : String, event : String = MouseEvent.CLICK) : void {
			trace("setting up " + frame);
			if(frame.indexOf("play_") == 0 || frame == "_play") {
				var ary : Array = frame.split("_");
				trace("ary: " + ary.join(","));
				if(!ie.hasEventListener(event)) {
					if(ary.length == 1) {
						ie.addEventListener(event, EventAdapter.create(play, [], false));
					}else {
						ie.addEventListener(event, EventAdapter.create(gotoAndPlay, [ary[1]], false));
					}
				}
			}else if(frame == "next") {
				if(!ie.hasEventListener(event)) {
					ie.addEventListener(event, EventAdapter.create(nextFrame, [], false));
				}	 
			}else {
				trace(" gotoAndStop " + frame);
				//if(!ie.hasEventListener(event)) {
				trace(" gotoAndStop2 " + frame);
				ie.addEventListener(event, EventAdapter.create(gotoAndStop, [frame], false));
			//	}
			}
		}

		public function takedownGoto(ie : IEventDispatcher, frame : String, event : String = MouseEvent.CLICK) : void {
			if(frame.indexOf("play_") == 0 || frame == "_play") {
				var ary : Array = frame.split("_");				
				if(!ie.hasEventListener(event)) {
					if(ary.length == 1) {
						ie.removeEventListener(event, EventAdapter.create(play, [], false));
					}else {
						ie.removeEventListener(event, EventAdapter.create(gotoAndPlay, [ary[1]], false));
					}
				}
			}else if(frame == "next") {
				if(ie.hasEventListener(event)) {
					ie.removeEventListener(event, EventAdapter.create(nextFrame, [], false));
				}
			}else {
				if(ie.hasEventListener(event)) {
					ie.removeEventListener(event, EventAdapter.create(gotoAndStop, [frame], false));
				}
			}
		}

		function reportKeyDown(event : KeyboardEvent) : void {
			//	trace("Key Pressed: " + String.fromCharCode(event.charCode) +         " (character code: " + event.charCode + ")");
			trace("Key Pressed:character code: " + event.charCode + ", " + event.keyCode + ")");
			output_txt.text = String(event.charCode);
			if (event.keyCode == 37 || event.charCode == 97 ) {
				//LEFT
				requestPrevScreen();
			} else if (event.keyCode == 39 || event.charCode == 115 || event.charCode == 32) {
				//RIGHT
				requestNextScreen();
			}else if(event.charCode == 27) {
				gotoAndStop(1);
			} else {
			//		requestScreenByName(String.fromCharCode(event.charCode));
			}
		}

		function requestNextScreen(evt : Event = null) : void {
			nextFrame();
		}

		function requestPrevScreen(evt : Event = null) : void {
			prevFrame();
		}
		public static function hideExcept(disObjCon : DisplayObjectContainer, except : Array = null, dontProcess : Array = null) : void {
			var i : int = 0;
			var  n : int = disObjCon.numChildren;
			var ii : int = 0;
			var nn : int = (except == null) ? 0 : except.length;
			var iii : int = 0;
			var nnn : int = (dontProcess == null) ? 0 : dontProcess.length;
			var dO : DisplayObject;
			var ignore : Boolean;
			var dontChange:Boolean;
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
		public function inventoryFrames(enableFrameDebugger : Boolean = false) {
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

		public function onFrameRequest(event : Event) : void {
			trace("onFrameRequest !!!! " + event.target.name + " !!!!!!!!!!");
			var a : Number = event.target.name.indexOf("_mc");
			var nm : String = event.target.name.substring(0, a);
			view.gotoAndStop(nm);
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
				var evt : SketchEvent;
				for (var i : int = 0;i < view.currentLabels.length; i++) {
					cnm = view.currentLabels[i].name;
					if (cnm != " " && view.currentLabels[i].frame == view.currentFrame && activeFrames[cnm] != true) {
						activeFrames[cnm] = true;
						///////////// PERFORM ACTIVATION ACTIONS ////////////////
						evt = new SketchEvent(SketchEvent.ENTERED_FRAME_LABEL);
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
						evt = new SketchEvent(SketchEvent.LEFT_FRAME_LABEL);
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
