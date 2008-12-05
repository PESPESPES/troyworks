package com.troyworks.ui {
	import com.troyworks.core.tweeny.Tny;
	import com.troyworks.framework.ui.KeyCode;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;		

	/**
	 * UIQA
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 13, 2008
	 * DESCRIPTION ::
	 * 
	 * This is a utility to scan to help with Flash timeline development. It points out
	 * 1) unnamed Sprites
	 * 2) duplicate named Sprites
	 * 3) other user specified patterns.
	 * 
	 * press 'Z' or 'z' to see what's at different depths.
	 * 
	 * clicking on a MovieClip will expose a context menu to navigate by frame
	 * TODO: navigate by frame label.
	 *
	 */
	public class QAUI extends MovieClip {

		public static  var GREEN_GLOW : GlowFilter = new GlowFilter(0x00FF00, 100, 4, 4, 10, 10);
		public static  var YELLOW_GLOW : GlowFilter = new GlowFilter(0xFFFF00, 100, 4, 4, 10, 10);
		public static  var RED_GLOW : GlowFilter = new GlowFilter(0xFF00, 100, 4, 4, 10, 10);

		public var idx : Dictionary;

		public var view : MovieClip;
		private var zplate : Sprite;

		private var curContent : MovieClip;
		private var curContextFrame : Sprite;
		private var lastContextFrame : Sprite;

		
		public function QAUI(viewClip : MovieClip = null) {
			view = (viewClip == null) ? this : viewClip;
			//qaView();
			idx = new Dictionary();

			view.stage.addEventListener(Event.ADDED, onChildAdded);
			view.stage.addEventListener(Event.REMOVED, onChildRemoved);
			view.stage.addEventListener(KeyboardEvent.KEY_DOWN, reportKeyDown);
			view.stage.addEventListener(MouseEvent.CLICK, onChildClicked);
			zplate = new Sprite();
			zplate.name = "zplate";
			zplate.graphics.beginFill(0x222222, .8);
			zplate.graphics.drawRect(0, 0, view.stage.stageWidth, view.stage.stageHeight);
			zplate.graphics.endFill();
		}

		public function onChildClicked(evt : MouseEvent) : void {
			trace("onChildClicked " + evt.target.name + " " + evt.target);
			if(curContextFrame == null) {
				curContextFrame = new Sprite();
				curContextFrame.name = "contextMenu";
			}
			if(evt.target == view.stage && curContextFrame.stage != null) {
				trace("null click");
				view.removeChild(curContextFrame);
				return;
			}else if(curContextFrame.stage == null) {
				view.addChild(curContextFrame);
			}
			
			var dO : DisplayObject = evt.target as DisplayObject;
			
			if( dO != view.stage && dO.parent != view) {
				trace("searching up the heirarchy " + dO.parent.name);
				//TODO search up the heirarchy
				if(dO.parent == curContextFrame) {
					//ignore
					trace(curContent.name + " going to " + dO.name);
					var ary : Array = dO.name.split("_");
					if(ary.length > 1) {
						curContent[ary[0]](ary[1]);
					}else {
						curContent[ary[0]]();
					}
					dO = curContent;
					//return;
				}else {
					dO = dO.parent as MovieClip;
				}
			}
			while(curContextFrame.numChildren) {
				curContent = null;
				curContextFrame.removeChildAt(0);
			}
			curContextFrame.graphics.clear();
			
			if(dO == view.stage){
				return;
			}
			curContextFrame.graphics.beginFill(0x666666, .8);
		
			var bnds : Rectangle = dO.getBounds(view.stage);
			var pad : int = 30;
			curContextFrame.graphics.drawRect(bnds.x - pad, bnds.y - pad, bnds.width + 2 * pad, bnds.height + 2 * pad);
			curContextFrame.graphics.drawRect(bnds.x, bnds.y, bnds.width, bnds.height);
			curContextFrame.graphics.endFill();
			
		
			if(dO is MovieClip) {
				curContent = dO as MovieClip;
				var mc : MovieClip = dO as MovieClip;
				trace("item clicked is MovieClip " + mc.name + " and has " + mc.totalFrames);
				
				//				var wid : Number = ( bnds.width + 2 * pad) - ((mc.totalFrames - 1) * 2) / mc.totalFrames;
				var wid : Number = (( bnds.width + 2 * pad) - (2 * 2) - ((mc.totalFrames - 1) * 2)) / mc.totalFrames;
				var btn : Sprite;
				if( mc.totalFrames > 1) {

						
					for (var i : Number = 0;i < mc.totalFrames; i++) {
						btn = new Sprite();
						btn.name = "gotoAndStop_" + ( i + 1);
						if(i == (mc.currentFrame - 1)) {
							btn.graphics.beginFill(0xffffff, .9);
						}else {
							btn.graphics.beginFill(0xdddddd, .9);
						}
						btn.graphics.drawRect(0, 0, wid, 20);
						btn.graphics.endFill();
						btn.x = (bnds.x - pad) + 2 + (i * (wid + 2)) ;
						btn.y = bnds.y + bnds.height + pad - 20 - 2;
						curContextFrame.addChild(btn);
					}
					if(1 <= (mc.currentFrame - 1)) {
						btn = new Sprite();
						btn.name = "prevFrame";
						btn.graphics.beginFill(0x333333, .9);
						btn.graphics.drawRect(0, 0, 5, 20);
						btn.graphics.endFill();
						btn.x = (bnds.x - pad) + 2;
						btn.y = bnds.y + bnds.height;
						curContextFrame.addChild(btn);
					}
					if((mc.currentFrame) < mc.totalFrames ) {	
						///////////////////////////
						btn = new Sprite();
						btn.name = "nextFrame";
						btn.graphics.beginFill(0x333333, .9);
						btn.graphics.drawRect(0, 0, 5, 20);
						btn.graphics.endFill();
						btn.x = (bnds.x + bnds.width + pad - 5 - 2);
						btn.y = bnds.y + bnds.height;
						curContextFrame.addChild(btn);
					}
				}
			}
		}

		public function getKey(dO : DisplayObject) : String {
			if((dO is MovieClip || dO is Sprite) && !(dO == view)) {
			
				var key : String = (dO is MovieClip) ? dO.parent.name + "[" + ((dO.parent as MovieClip).currentFrame) + "]." + dO.name : dO.parent.name + "." + dO.name;
				return key;
			}else {
				return dO.name;
			}
		}

		public function onChildAdded(evt : Event) : void {
			var dO : DisplayObject = evt.target as DisplayObject;
			var key : String = getKey(dO);
			//trace("onChildAdded " + key);
			testDO(evt.target as DisplayObject);
		}

		public function onChildRemoved(evt : Event) : void {

			if(evt.target is Sprite) {
				var dO : DisplayObject = evt.target as Sprite;
				var key : String = getKey(dO);
								

				//	trace("onChildRemoved " + key);
				delete(idx[key]);
			}
		}

		public function qaView() : Boolean {
		
			var res : Boolean = true;
			var i : int = 0;
			var n : int = view.numChildren;
			var dO : DisplayObject;
			for (;i < n; ++i) {
				trace(i + " " + view[i]);
				dO = view.getChildAt(i);
				testDO(dO);
			}
			
			return res;
		}

		function reportKeyDown(event : KeyboardEvent) : void {
			//	trace("Key Pressed: " + String.fromCharCode(event.charCode) +         " (character code: " + event.charCode + ")");
			trace("Key Pressed:character code: " + event.charCode + ", " + event.keyCode + ")");
			//output_txt.text = String(event.charCode);
			trace("KeyCodez " + KeyCode);
			var cIdx : int; 
			var kc : KeyCode = KeyCode.parse(event.charCode); 
			if ( kc == KeyCode.Z ) {
				//UP
				if(zplate.stage == null) {
					view.addChildAt(zplate, 0);
				}
				cIdx = view.getChildIndex(zplate);
				if((cIdx + 1) < view.numChildren) {
					view.swapChildrenAt(cIdx, cIdx + 1);
				}
			} else if (kc == KeyCode.z ) {
				//DOWN
				if(zplate.stage == null) {
					return;
				}
				cIdx = view.getChildIndex(zplate);
				trace("down z plate" + cIdx + " " + (cIdx - 1));
				if(cIdx > 1) {
					view.swapChildrenAt(cIdx, cIdx - 1);
				}else {
					view.removeChild(zplate);
				}
			}else if (kc == KeyCode.t) {
				var redhues : Array = ColorUtil.getHues(0xFF0000, view.numChildren);
				//	var whitehues:Array = ColorUtil.getHues(0xFFFFFF,view.numChildren);
				
				//	var seqM : SequenceMaker = new SequenceMaker();
				//	seqM.sources =[redhues, whitehues];
				//	var hues:Array = seqM.getSequence_takeOneFromEachAtAPlace( view.numChildren);
				for (var i : Number = 0;i < view.numChildren; i++) {
					var tny : Tny = new Tny(view.getChildAt(i));
					tny.color = redhues[i];
					tny.colorP = 100;
					tny.delay = (5 / ( view.numChildren - i));
					tny.duration = 1;	
				}
			}else if (kc == KeyCode.T){
			}
		}

		public function testDO(dO : DisplayObject) : Boolean {
			var res : Boolean = true;
			testSprite(dO);
			return res;
		}

		/*
		 * Override in your class to extend for the tests you want
		 */
		public function testSprite(dO : DisplayObject) : Boolean {
			var res : Boolean = true;
			if(dO is Sprite) {
				
				var key : String = getKey(dO);

				if(idx[ key ] != null) {						
					/////// is a duplicates //////////
					res = false;
					trace("FOUND AN DUPLICATE CLIP");
					var dO2 : DisplayObject = (idx[key] as DisplayObject);
					//dO2.filters = [RED_GLOW];
					var tt : TToolTip = new TToolTip(stage, null, 0xCC0000, .6, TToolTip.SQUARE_TIP, 0xFFFFFF);
					tt.label = "<font color='0xFFFFFF'>!</font> ERROR: Duplicate Clip (1/2) '" + dO.name + "'";
					tt.showAt(dO, dO.stage);
				
					var tt2 : TToolTip = new TToolTip(stage, null, 0xCC0000, .6, TToolTip.SQUARE_TIP, 0xFFFFFF);
					tt2.label = "<font color='0xFFFFFF'>!</font> ERROR: Duplicate Clip (2/2) '" + dO2.name + "'";
					tt2.showAt(dO2, dO.stage);
					
					//dO.filters = [RED_GLOW];					
				}else if(dO.name.indexOf("instance") == 0) {
					/////// is an unnamed clip ///////
					trace("FOUND AN UNNAMED CLIP");
					res = false;
					var tt3 : TToolTip = new TToolTip(stage, null, 0xCCCC00, .6, TToolTip.SQUARE_TIP);
					tt3.label = "WARNING: Unnamed Clip '" + dO.name + "'";
					tt3.showAt(dO, dO.stage);
					
					
				//	dO.filters = [YELLOW_GLOW];					
				}					
				idx[key] = dO;
			}
			return res;
		}

		/*
		 * In many games the on stage clips have a pattern of
		 * NAMEID_NUMBER  where the NUMBER indicates belonging to the same family
		 * e.g. 
		 * ball1_1
		 * square2_1
		 */
		public function testFor_ID_Number(dO : Sprite) : Boolean {
			var res : Boolean = true;
			////////////// QA Mode ////////////////////
			var ary : Array = dO.name.split("_");
			if(ary.length < 2) {
				///////// for numbered clips, if it doesn't have a number //////////
				dO.filters = [YELLOW_GLOW];
				res = false;
			}else if(isNaN(ary[1])) {
				//////// for number clips if the suffix isn't a number ///// 
				dO.filters = [YELLOW_GLOW];
				res = false;
			}
			return res;
		}
	}
}
