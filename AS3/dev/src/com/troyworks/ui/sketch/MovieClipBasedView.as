/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.ui.sketch {
	import com.troyworks.events.EventWithArgs;	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.getQualifiedClassName;
		
	dynamic public class MovieClipBasedView extends MovieClip{
		private var _enableFrameDebugger:Boolean;
		public var debuggerUI_mc:MovieClip;
		
		public var initFrameScripts:Object;
		
		public var labelledFrameInitScripts:Object;
		public var labelledFrameUnLoadedScripts:Object;
				
		public var activeFrames:Object;
		public var frameLabelToNumberIdx:Object;
		public var lastFrameNumber:Number;
		public var view:MovieClip;
		
		
		public function MovieClipBasedView() {
			super();
			//if(this.parent != null){
			//	setView(this);
				view = this;
			//}
			frameLabelToNumberIdx = new Object();
			/////////////////////////////////
			initFrameScripts = new Object();
			
			debuggerUI_mc= new MovieClip();
			debuggerUI_mc.name = "debuggerUI_mc";
			if(view.parent != null){
				view.parent.addChild(debuggerUI_mc);
			}
		}
		public function getMouseAngle() :Number{
			return Math.atan2(view.parent.mouseY-view.y, view.parent.mouseX-view.x)*180/Math.PI;
		};
		public function setView(mc:MovieClip, enableWatch:Boolean = false):void{
			view = mc;
			if(enableWatch){
				view.addEventListener(Event.ADDED_TO_STAGE,addedToStage);
				view.addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
				view.addEventListener(Event.ADDED,onChildAdded);
				view.addEventListener(Event.REMOVED,removedFrom);
			}
		}
		protected function addedToStage(event:Event):void {
			trace("addedToStage " + event.target);
		}
		protected function removedFromStage(event:Event):void {
			trace("removedFromStage " + event.target);
		}
		protected function onChildAdded(event:Event):void {
			trace(view.currentLabel + " onChildAdded " + event.target);
			var nm:String = getQualifiedClassName(event.target);
			trace("XX " +nm + " " + DisplayObject(event.target).name);
			var ary:Array;
			var id:Number;
			switch(nm){
				case "flash.display::Shape":
				case "flash.text::StaticText":
				//ignore
				break;
/*				case "Ball":
				trace("found a Ball " + MovieClip(event.target).name);
				ary = MovieClip(event.target).name.split("_");
				id = parseInt(ary[1]);
				var bl:Seeker = new Seeker(MovieClip(event.target));
				bl.addEventListener(Event.COMPLETE, onChildReachedTarget);
				balls[id] = bl;
				if(targets[id] != null){
					bl.seekTarget = targets[id].view;
				}
				break;	
				case "Target":
				trace("found a Target " + MovieClip(event.target).name);
				var t:Bouncer = new Bouncer(MovieClip(event.target));
					ary = MovieClip(event.target).name.split("_");
				id = parseInt(ary[1]);
				targets[id] = t;
				if(balls[id] != null){
					balls[id].seekTarget = t.view;
				}
				break;*/
				default:
			//	trace("found unknown");
				break;

			}
		}
		protected function removedFrom(event:Event):void {
			trace("!!!!!!!!!!!!!removedFrom " + event.target);
		}
		
		public function inventoryFrames(enableFrameDebugger:Boolean = false){
			activeFrames = new Object();
			frameLabelToNumberIdx = new Object();
			var labelDepth:Number = 0;
			var nm:String =null;
			var fn:Number = -1;
			trace("Inventorying FrameLabels----------------------");
			
			for (var i:int = 0; i < view.currentLabels.length; i++) {
				nm = view.currentLabels[i].name;
				fn = view.currentLabels[i].frame;
				trace( i + " " + nm + " " + fn);
				frameLabelToNumberIdx[nm] = fn;
				
				if (lastFrameNumber == fn) {
					labelDepth++;
				} else {
					labelDepth = 0;
					lastFrameNumber = fn;
				}

				activeFrames[nm] =  false;
				/////////////// DEBUGGER ////////////////////////////
				_enableFrameDebugger = enableFrameDebugger;
				
				if(_enableFrameDebugger && view.parent){
					//////// CREATE DEBUGGING VISUALIZER //////////
					var sp:Sprite = new Sprite();
					sp.name = nm +"_mc";
					sp.graphics.beginFill(0xCCCCCC,1);
					sp.graphics.drawRect(0,0, 50, 20);
					var txt:TextField  = new TextField();
					txt.name = "txt";
					txt.text = nm;
					txt.type = TextFieldType.DYNAMIC;
					txt.selectable = false;
					txt.mouseEnabled = false;
					//txt.embedFonts = true;
					sp.alpha =.2;
					sp.x = (fn *60) + 20;
					sp.y = labelDepth*20;
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
		public function onFrameRequest(event:Event):void {
			trace("onFrameRequest !!!! " + event.target.name + " !!!!!!!!!!" );
			var a:Number = event.target.name.indexOf("_mc");
			var nm:String = event.target.name.substring(0, a);
			view.gotoAndStop(nm);
		}
		
		public function getFrameNumberForFrameLabel(frameLabel:String):uint{
			return uint(frameLabelToNumberIdx[frameLabel]);
		}
		public function activate():void{
			view.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		public function deactivate():void{
			view.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}

		public function onEnterFrameHandler(event:Event):void {
		//trace("onEnterFrameHandler" + view);
			if ( lastFrameNumber  != view.currentFrame) {
				/////////////// FRAME HAS CHANGED (not just rerendered) ///////////////////
				var sp:Sprite;
				var nm:String;
				var cnm:String;
				var evt : EventWithArgs;
				for (var i:int = 0; i < view.currentLabels.length; i++) {
					cnm = view.currentLabels[i].name;
					if (cnm  != " " && view.currentLabels[i].frame == view.currentFrame &&  activeFrames[cnm] != true) {
						activeFrames[cnm] =  true;
						///////////// PERFORM ACTIVATION ACTIONS ////////////////
						evt = new EventWithArgs( SketchSignals.ENTERED_FRAME_LABEL);
						evt.args =[cnm];
						var o:Function =initFrameScripts[view.currentFrame];						
						if(o != null) 
						{
						  o();
						}
					//	dispatchEvent(evt);
									
						///////////// DEBUGGER //////////////////////
						nm = cnm + "_mc";
																
						if(debuggerUI_mc != null && debuggerUI_mc.numChildren > 0){
							sp = Sprite(debuggerUI_mc.getChildByName(nm));
							if(sp != null){
								sp.alpha =1;
							}
						}
						//sp.visible = true;
					} else if ( activeFrames[cnm] == true && cnm != view.currentLabel) {
										trace("11111111111111111111111111111");

						nm = cnm + "_mc";
						evt = new EventWithArgs( SketchSignals.LEFT_FRAME_LABEL);
						evt.args = [cnm];
						//dispatchEvent(evt);
						activeFrames[cnm] =  false;

						if(debuggerUI_mc != null && debuggerUI_mc.numChildren > 0){
							
							sp = Sprite(debuggerUI_mc.getChildByName(nm));
							//trace("deactivating " +nm  + " " + sp);
							sp.alpha =.2;
						}

					}//sp.visible = false;
				}
				lastFrameNumber = view.currentFrame;
			}

		}
		///////////////// THESE GEMS related to OF oizys and evilzug 
		//http://evilzug.livejournal.com/687066.html
		// these are called PRIOR to children of frames being created
		  public function addOnInitFrameScript(frame:*,callback:Function):void
		  {
			  var frameNo:uint = 0;
			  if(frame is String){
				  frameNo = getFrameNumberForFrameLabel(frame)-1;
			  }else{
				  frameNo = uint(frame);
			  }
			initFrameScripts[frameNo] = callback; 
		  }
		  
		  public function removeOnInitFrameScript(frame:*):void
		  {
			  var frameNo:uint = 0;
			  if(frame is String){
				  frameNo = getFrameNumberForFrameLabel(frame) -1;
			  }else{
				  frameNo = uint(frame);
			  }
			initFrameScripts[frameNo] = null; 

		  }
		  // these are called AFTER children of frames being created
		  public function addOnLoadedFrameScript(frame:*, callback:Function):void{
			  var frameNo:uint = 0;
			  if(frame is String){
				  frameNo = getFrameNumberForFrameLabel(frame) -1;
			  }else{
				  frameNo = uint(frame);
			  }
			  trace("frameNo " + frameNo + " addOnLoadedFrameScript " + frame);
			 view.addFrameScript(frameNo, callback);
		  }
		  
		  public function removeOnLoadedFrameScript(frame:*):void{
			  var frameNo:uint = 0;
			  if(frame is String){
				  frameNo = getFrameNumberForFrameLabel(frame) -1;
			  }else{
				  frameNo = uint(frame);
			  }
			 view.addFrameScript(frameNo, null);
		  }		  
	}
	
}
