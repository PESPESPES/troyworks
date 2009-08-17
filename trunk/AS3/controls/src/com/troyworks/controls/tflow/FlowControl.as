package com.troyworks.controls.tflow {
	import com.troyworks.ui.UIUtil;	
	import com.troyworks.controls.ttooltip.OBO_ToolTip;
	import com.troyworks.core.tweeny.Tny;
	import com.troyworks.events.EventAdapter;
	import com.troyworks.events.EventWithArgs;
	import com.troyworks.util.InitObject;
	import com.troyworks.controls.tflow.*;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;		

	//import fl.controls.RadioButton;	
	/**
	 * FlowControl is a 3 part utility to help create fast prototypes 
	 * or lightwieght view/controller binding.
	 * 
	 * either using Frame navigation or Stack visibility manipulation,
	 * - help in adding framescripts by framelabel 
	 * - dispatching events.
	 * 
	 * it's lightweight at ~10Kb (2kb is tny, 2kb is tooltips).
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
	home           - goes to first frame 
	next          - goes to previous frame
	nextFrame_    - goes to next frame
	prev         - goes to previous frame
	prevFrame_   - goes to previous frame
	nextScene_  - goes to next scene
	prevScene_ - goes to previous scene
	play_   - starts playing
	stop_   - stops playing
	gotoAndStop_XXX
	gotoAndPlay_XXX 
	XXX_
	XXX_fn - calls a function scoped to the flow control
	XXX_evt - dispatches a bubbling event
	 * 
	 * 
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
	 * //TODO play_in_mS
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
	 * var config:Object  = new Object();
	config.preloadingRequired = true;
	config.enableToolTips = false;
	config.fadeClipColor = 0xFFFFFF;
	config.hasPreloadingFrame = true;
	this.config = config;
	stop();
	 * 
	 * you can enable or disable the functionality at any time
	 * dispatchEvent(new Event("FlowControlEnableDynamicBinding", true, true));
	 * dispatchEvent(new Event("FlowControlDisableDynamicBinding", true, true));
	 * 
	 * @author Troy Gardner (troy@troyworks.com)
	 */
	dynamic public class FlowControl extends MovieClip {
		//public var output_txt : TextField;
		public var lastFrame : int = -1;
		public var framesRendered : int = 0;
		public var errorFilter : GlowFilter = new GlowFilter(0xFF0000, 80);

		public var QA : Sprite;
		public var timers : Dictionary = new Dictionary();
		public var evtIdx : Dictionary = new Dictionary();

		private var _enableFrameDebugger : Boolean;
		public var debuggerUI_mc : Sprite;

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
		public var useKeyboardNav : Boolean = true;
		public var watchAddedAndRemovedEvents : Boolean = true;
		public var showDebugUI : Boolean = false;
		public var debugShowChildAdded : Boolean = false;
		public var debugShowChildRemoved : Boolean = false;
		public var hasPreloadingFrame : Boolean = false; 
		//whether or not a next frame should be called upon load

		//////////////////////////////////////////////////////////
		private var currentToolTip : TextField;
		public var TOOLTIPCLASS : Class;
		//OBO_ToolTip
		private var _toolTip : OBO_ToolTip;
		public var fadeClip : Sprite;
		private var fadeClipTny : Tny;
		public var fadeClipColor : Number = 0xFFFFFF; 
		public var nextAction : Function;
		public var enableToolTips : Boolean = true;
		public var stopAllSoundsBetweenNav : Boolean = false;

		public var classMap : Dictionary = new Dictionary(true);
		public var isEmbedded : Boolean = false;
		public var iniObj : Object;
		public var framesToWait : Number = 3;
		public var flowcontrollSubClassed : Boolean = false;

		public var flowControlHasInited : Boolean = false;
		public var version : Number = 1.2;
		public var fcIsInited:Boolean = false;

		//	public static var trace : Function = TraceAdapter.SOSTracer;

		public function FlowControl(initObj : Object = null, subclassed : Boolean = false) {
			super();
			trace("FlowControl () " + version + " subclassed? " + subclassed);
			flowcontrollSubClassed = subclassed;
			if(!flowcontrollSubClassed) {
				init(initObj);
			}
		}

		public function init(initObj : Object = null) : void {
			trace("FlowControl("+ version+ ").init ****************************************************" + loaderInfo + " isEmbedded " + isEmbedded);
			if(fcIsInited){
				trace("error FC already Inited!!!");
				return;
			}
			isEmbedded = loaderInfo != null && loaderInfo.url != null || this.totalFrames > 1;
			trace("this.totalFrames  >1 " + this.totalFrames);
			
			this.iniObj = initObj;
			if(isEmbedded || initObj != null) {
				trace("setting up as solo");
				
				view = this;
				view.stop();
				view.visible = false;
				preloadingRequired = false;
				InitObject.setInitValues(this, initObj);
				
				//note addFrameScript doesn't pick up configuration options
				// on frame1
				
				//addEventListener(Event.ENTER_FRAME, onRenderFirstFrame);
				//addEventListener(Event.ENTER_FRAME,onEF);
				if(view.stage == null) {
					addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				}else {
					onAddedToStage(null);
				}
			}else {
				trace("waiting on UI");				
			}
			
			
			//	trace(hasOwnProperty("config") + "  config " + hasOwnProperty("config2") );

			frameLabelToNumberIdx = new Object();
			initFrameScripts = new Object();
		}

		/*public function onWaitingForFrameToRender(evt:Event):void{
		}*/
		/* view should have frame1 completely loaded by then */
		public function onAddedToStage(evt : Event) : void {
			trace("FlowControl.onAddedToStage ***********************" + this);
			trace("parent " + this.parent + " stage  " + this.stage);
			setView(this);
			if(view.hasOwnProperty("config")) {
				trace("waiting on config");
			}else {
				trace("not waiting on config");
				framesToWait = 1 ;
				onRenderFirstFrame();
			}
			addEventListener(Event.ENTER_FRAME, onRenderFirstFrame);
		//	onEF();
		}

		/*		public function onEF(evt : Event = null) : void {
		if(view.getChildByName("debug_txt") != null) {
		view.debug_txt.text += "STAGE " + view.stage.stageWidth + " " + view.stage.stageHeight + " " + +view.stage.width + " " + view.stage.height;
		}
		}*/

		public function onRenderFirstFrame(evt : Event = null) : Boolean {
			
			if(flowControlHasInited) {
				removeEventListener(Event.ENTER_FRAME, onRenderFirstFrame);
				return true;
			}
			trace("FlowControl.onRenderFirstFrame ***********************" + view.currentFrame + " try " + (framesRendered + 1));
			framesRendered++;
			try {
				var vw = view.loaderInfo.width; 
				trace("loaderInfo GOOD");
			}catch(er : Error) {
				trace("ER loadingInfo not loaded yet" + er.getStackTrace());
				framesToWait++;
				return false;
			}
			trace("FlowControl.onRenderFirstFrame2 ***********************");
			if(isEmbedded && framesRendered >= framesToWait) {
				trace("removing onRenderFirstFrame111");
				removeEventListener(Event.ENTER_FRAME, onRenderFirstFrame);
			}
			try {
				// see if this exists
				//	trace(hasOwnProperty("config") + "  config " + this["config"])			
				if(this.config != null ) {
					//call up whatever config is on frame1;
					InitObject.setInitValues(this, this.config);
					framesToWait = 0 ;
					trace("removing onRenderFirstFrame2222");
					removeEventListener(Event.ENTER_FRAME, onRenderFirstFrame);
				}else {
					trace(" FlowControl using default configuration ");
				}
			}catch(er : Error) {
				trace(" FlowControl couldn't init frame1");
			}
			if(isEmbedded && framesRendered < framesToWait) {
				//trace("isEmb")
				view.stop();
				return false;
			}
			trace("===================== SETUP from FirstFrame ==============================");
			///////////////// SETUP THE DEBUGGING UI ///////////////////////
			setupNav();
			if(useKeyboardNav) {
				enableFlowControlKeyboardNavigation();
			}
	
			if(showDebugUI) {
				QA = new Sprite();
				view.parent.addChild(QA);
			}
			if(view.fadeClip == null) {
				trace("creating FadeClip---------------------------------");
				fadeClip = new Sprite();
				fadeClip.graphics.beginFill(fadeClipColor);
				if(view.getChildByName("debug_txt") != null) {
					view.debug_txt.text += view.stage.scaleMode + " SETUP STAGE " + view.stage.stageWidth + " " + view.stage.stageHeight + " loaderInfo.width" + loaderInfo.width + " " + loaderInfo.height;
				}
				trace(" view.loaderInfo  " + view.loaderInfo + " " + view.loaderInfo.width);
				fadeClip.graphics.drawRect(0, 0, view.loaderInfo.width, view.loaderInfo.height);
				//view.stage.stageWidth, view.stage.stageHeight);
				fadeClip.graphics.endFill();
				trace("add FadeClip");
				view.parent.addChild(fadeClip);
			}else {
				fadeClip = view.fadeClip;
			}
			view.visible = true;
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
				if(hasPreloadingFrame) { 
					view.nextFrame();
				}
				startFadeDown();
			}
			flowControlHasInited = true;
			return true;
		}

		public function setupNav() : void {
			
			//override in subclass
			return;
		}

		
		/* set the actual MovieClip/Sprite we are going to use */
		public function setView(mc : MovieClip, sender : String = null, initObj : Object = null) : void {
			trace("FlowControl.setView" + mc + " " + sender + " " + initObj);
			view = mc;
			try {
				//	trace(hasOwnProperty("config") + "  config " + this["config"])		
				////////////// STAGE CONFIG //////////////////////	
				if(view.hasOwnProperty("config") && view.config != null ) {
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
				enableFlowControlDynamicBinding();
		
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
			
			view.addEventListener("FlowControlEnableKeyboardNavigation", enableFlowControlKeyboardNavigation );
			view.addEventListener("FlowControlDisableKeyboardNavigation", disableFlowControlKeyboardNavigation);
			
			view.addEventListener("FlowControlEnableDynamicBinding", enableFlowControlDynamicBinding);
			view.addEventListener("FlowControlDisableDynamicBinding", disableFlowControlDynamicBinding);
			
		//	onFrameChanged();
		}
		public function enableFlowControlDynamicBinding(evt:Event = null):void{
			trace("****enableFlowControlDynamicBinding****");
				view.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
				view.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
				view.addEventListener(Event.ADDED, onChildAdded);
				view.addEventListener(Event.REMOVED, onChildRemoved);
		}
		public function disableFlowControlDynamicBinding(evt:Event = null):void{
			trace("****disableFlowControlDynamicBinding****");
				view.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
				view.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
				view.removeEventListener(Event.ADDED, onChildAdded);
				view.removeEventListener(Event.REMOVED, onChildRemoved);
		}
		
		public function enableFlowControlKeyboardNavigation(evt : Event = null) : void {
			trace("**---enableFlowControlKeyboardNavigation --**");
			view.stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
		}

		public function disableFlowControlKeyboardNavigation(evt : Event = null) : void {
			trace("**---disableFlowControlKeyboardNavigation --**");
			view.stage.removeEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
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
			view.dispatchEvent(new Event("EXIT_FRAME", true, true));
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
			trace("FlowControl.addedToStage " + event.target);
		}

		protected function removedFromStage(event : Event = null) : void {
			trace("FlowControl.removedFromStage " + event.target);
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

				//	trace("found a bum clip " + dO.name+ " " + dO);

				trace("found a bum clip " + UIUtil.getFullPath(dO) + " " + dO);
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
		}

		public function setupGoto(ie : IEventDispatcher, frame : String, event : String = MouseEvent.CLICK) : void {
			trace("FlowControl.setupGoto " + frame + " for " + view + "." + (ie as DisplayObject).name + ":" + ie);
			if(frame == "root1") {
				trace(" FlowControl.setupGoto -> ignoring root");
				return;
			}
			var ary : Array;
			var evtTr : EventAdapter = new EventAdapter();
			
			evtTr.initAsRedispatcher(view);
			var ignoreClick : Boolean = false;
			var fnName : String;
			if(frame.indexOf("_evt") != -1 ) {
			
				ary = frame.split("_");
				trace("FOUND AUTOBUTTON '" + ary[0] + "'");
				evtTr.evtType = ary[0];
				if(ary.length == 3) {
					evtTr.args = [ary[2]];
				}
			}else if(frame.indexOf("_fn") != -1 ) {	
				fnName = frame.split("_")[0];
				evtTr = null;
				if (view[fnName] is Function) {
					trace("Found FUnction" + view[fnName]);
					ie.addEventListener(MouseEvent.CLICK, this[fnName]);
//					ie.addEventListener(MouseEvent.CLICK, EventAdapter.create(this[fnName], []));
				}
			}else if(frame.indexOf("play_") == 0) {
				ary = frame.split("_");
				trace("ary: '" + ary.join("','") + "'");
				if(ary.length == 1 || (ary.length == 2 && ary[1] == "")) {
					trace(" standard play()");
					evtTr.evtType = "play";					
				}else {
					trace(" gotoAndPlay()");
					evtTr = new EventAdapter();
					evtTr.initAsRedispatcher(this);
					evtTr.evtType = "gotoAndPlay";
					evtTr.args = [ary[1]];					
				}
			}else if(frame == "stop_") {
				evtTr.evtType = "stop";					
			}else if(frame == "next" || frame == "nextFrame_") {
				evtTr.evtType = "nextFrame";					
				trace(" setting up nextFrame " + evtTr);
			}else if(frame == "prev" || frame == "prevFrame_") {
				evtTr.evtType = "prevFrame";					
			}else if(frame == "prevScene_" ) {
				evtTr.evtType = "prevScene";					
			}else if(frame == "nextScene_" ) {
				evtTr.evtType = "nextScene";					
			}else {
				ary = frame.split("_");
				trace(" gotoAndStop " + frame + "  '" + ary.join("','") + "'");
				if(ary.length > 0) {
					if(ary[0] == "gotoAndStop") {
						trace("adding gotoAndStop");
						evtTr.evtType = "gotoAndStop";
						evtTr.args = [ary[1]];
					}else if(ary[0] == "gotoAndPlay") {
						trace("adding gotoAndPlay");
						evtTr.evtType = "gotoAndPlay";
						evtTr.args = [ary[1]];
					}else {
						//trace("ary '"+ ary.length + "'");
						trace("ignoring");
						ignoreClick = true;
					}
				}else {
					trace("adding gotoAndStop2");
					evtTr.evtType = "gotoAndPlay";
					evtTr.args = [frame];					
				}                
			}
		
			//	if(evtTr != null && evtTr.evtType == null){
			//	throw new Error("FlowControl.setupGoto cannot have null evnType");
			//}
			if(!ignoreClick) {
				evtTr.id = view.name + "+" + evtTr.evtType;
				evtIdx[evtTr.id] = evtTr;
				ie.addEventListener(event, evtTr.dispatchEvent);
			}
			if(enableToolTips) {
				ie.addEventListener(MouseEvent.ROLL_OVER, toolTipHover);
				ie.addEventListener(MouseEvent.ROLL_OUT, removetoolTipHover);
			}
		}

		//TODO cache the references to EventTranslator and remove them that way.
		public function takedownGoto(ie : IEventDispatcher, event : String = MouseEvent.CLICK) : void {
			
			var id : String = view.name + "+" + event;
			var evtTr : EventAdapter = evtIdx[id];
			trace("takedownGoto " + ie + " " + event + " id " + id + " is " + evtTr);
			if(evtTr != null){
			ie.removeEventListener(event, evtTr.dispatchEvent);
			delete(evtIdx[id]);
			}		
		}

		////////////////////////////////////////////////////////////////////
		/////////////////////// TOOL TIP //////////////////////////////////
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

		/////////////////////// TOOL TIP //////////////////////////////////
		////////////////////////////////////////////////////////////////////

		protected function reportKeyDown(event : KeyboardEvent) : void {
			//	trace("Key Pressed: " + String.fromCharCode(event.charCode) +         " (character code: " + event.charCode + ")");
			trace("Key Pressed:character code: " + event.charCode + ", " + event.keyCode + ")");
			//output_txt.text = String(event.charCode);
			var evt : EventWithArgs;
			if (event.keyCode == 37 || event.charCode == 97 ) {
				//LEFT
				evt = new EventWithArgs("prevFrame");
				evt.args = [0];
				view.dispatchEvent(evt);
			} else if (event.keyCode == 39 || event.charCode == 115 || event.charCode == 32) {
				//RIGHT
				evt = new EventWithArgs("nextFrame");
				evt.args = [0];
				view.dispatchEvent(evt);
			}else if(event.charCode == 27) {
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
			trace("requestNextFrame");
			if(view.currentFrame < view.totalFrames) {
				nextAction = EventAdapter.create(view.nextFrame, [], false);
				startFadeUP();
				if(event != null) {
					event.stopImmediatePropagation(); // consumed
				}
			}
		}

		protected function requestPrevFrame(event : Event = null) : void {
			trace("requestPrevFrame");
			if(view.currentFrame > 0) {
				nextAction = EventAdapter.create(view.prevFrame, [], false);
				startFadeUP();
				if(event != null) {
					event.stopImmediatePropagation(); // consumed
				}
			}
		}

		protected function requestNextScene(event : Event = null) : void {
			trace("requestNextScene");
			nextAction = EventAdapter.create(view.nextScene, [], false);
			startFadeUP();
			if(event != null) {
				event.stopImmediatePropagation(); // consumed
			}
		}

		protected function requestPrevScene(event : Event = null) : void {
			trace("requestPrevScene");
			nextAction = EventAdapter.create(view.prevScene, [], false);
			startFadeUP();
			if(event != null) {
				event.stopImmediatePropagation(); // consumed
			}
		}

		protected  function requestStop(event : Event = null) : void {
			trace("requestStop");
			nextAction = EventAdapter.create(view.stop, [], false);
			startFadeUP();
			if(event != null) {
				event.stopImmediatePropagation(); // consumed
			}
		}

		protected  function requestPlay(event : Event = null) : void {
			trace("requestPlay");
			nextAction = EventAdapter.create(view.play, [], false);
			startFadeUP();
			if(event != null) {
				event.stopImmediatePropagation(); // consumed
			}
		}

		protected  function requestGotoAndPlay(event : EventWithArgs = null) : void {
			trace("requestGotoAndPlay '" + event.args[0] +"'");
			nextAction = EventAdapter.create(view.gotoAndPlay, event.args, false);
			startFadeUP();
			if(event != null) {
				event.stopImmediatePropagation(); // consumed
			}
		}

		protected  function requestGotoAndStop(event : EventWithArgs = null) : void {
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
			//try{
			onEnterFrameHandler(null);
			//}catch(er:Error){
			//	trace(er.toString());
			//}
			trace("onframehandler-----------------------222");
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
				try {
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
				}catch(err : Error) {
					trace("error in flowcontrol " + err.getStackTrace());
				}
			}
		}

		public function addFrameScriptForLabel(lblName : String, fn : Function ) : int {
			var frameNum : int = getFrameNumberForFrameLabel(lblName) ;
			view.addFrameScript(frameNum - 1, fn);
			return frameNum;
		}

		public function getFrameNumberForFrameLabel(frameLabel : String) : uint {
			return uint(frameLabelToNumberIdx[frameLabel]);
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
