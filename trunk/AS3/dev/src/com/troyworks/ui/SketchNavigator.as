package com.troyworks.ui {
	import flash.display.MovieClip;

	/**
	 * SketchNavigator
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: May 7, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class SketchNavigator extends Sprite {
		import flash.events.*;
		import flash.text.TextFieldType;

		var init : Boolean;
		var lastFrameNumber : Number;
		var activeFrames : Object;

		public function SketchNavigator() {
			super();
		}

		function onAddedToStage():void{
		if (!init) {
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			activeFrames = new Object();
			var labelDepth : Number = 0;
			trace("Inventorying FrameLabels----------------------");
			for (var i : int = 0;i < currentLabels.length; i++) {
				trace(i + " " + currentLabels[i].name + " " + currentLabels[i].frame);
				if (lastFrameNumber == currentLabels[i].frame) {
					labelDepth++;
				} else {
					labelDepth = 0;
					lastFrameNumber = currentLabels[i].frame;
				}

				activeFrames[currentLabels[i].name] = false;
				//////// CREATE DEBUGGING VISUALIZER //////////
				var sp : Sprite = new Sprite();
				sp.name = currentLabels[i].name + "_mc";
				sp.graphics.beginFill(0xCCCCCC, 1);
				sp.graphics.drawRect(0, 0, 50, 20);
				var txt : TextField = new TextField();
				txt.name = "txt";
				txt.text = currentLabels[i].name;
				txt.type = TextFieldType.DYNAMIC;
				txt.selectable = false;
				txt.mouseEnabled = false;
				//txt.embedFonts = true;
				sp.alpha = .2;
				sp.x = (currentLabels[i].frame * 40) + 20;
				sp.y = labelDepth * 20;
				sp.addChild(txt);
				sp.buttonMode = true;
				sp.addEventListener(MouseEvent.CLICK, onFrameRequest);
				debuggerUI_mc.addChild(sp);
			}
			init = true;
			//already on frame so call.
			onEnterFrameHandler(null);
		}
	}

		function onFrameRequest(event : Event) : void {
			trace("onFrameRequest !!!! " + event.target.name + " !!!!!!!!!!");
			var a : Number = event.target.name.indexOf("_mc");
			var nm : String = event.target.name.substring(0, a);
			gotoAndStop(nm);
		}

		function onEnterFrameHandler(event : Event) : void {
			if (lastFrameNumber != currentFrame) {
				/////////////// FRAME HAS CHANGED (not just rerendered) ///////////////////
				var sp : Sprite;
				var nm : String;
				for (var i : int = 0;i < currentLabels.length; i++) {
					if (currentLabels[i].name != " " && currentLabels[i].frame == currentFrame && activeFrames[currentLabels[i].name] != true) {
						nm = currentLabels[i].name + "_mc";
						activeFrames[currentLabels[i].name] = true;
						sp = Sprite(debuggerUI_mc.getChildByName(nm));
						trace("activating " + nm + " " + sp);

						sp.alpha = 1;
				//sp.visible = true;
					} else if ( activeFrames[currentLabels[i].name] == true && currentLabels[i].name != currentLabel) {
						nm = currentLabels[i].name + "_mc";

						activeFrames[currentLabels[i].name] = false;
						sp = Sprite(debuggerUI_mc.getChildByName(nm));
						trace("deactivating " + nm + " " + sp);
						sp.alpha = .2;
					}//sp.visible = false;
				}
				lastFrameNumber = currentFrame;
			}
		}
	}
}
