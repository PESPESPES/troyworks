/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.components.imageEditor {
	import com.troyworks.cogs.CogEvent;
	import com.troyworks.cogs.Hsm;
	import flash.display.Sprite;

	
	public class ImageEditor extends Hsm{
		public static const TOOL_NONE:String = "none";
		public static const TOOL_MOVE:String = "move";
		public static const TOOL_SCALE:String = "scale";
		public static const TOOL_ROTATE:String = "rotate";
		
		public var tools:Array= [TOOL_NONE, TOOL_MOVE, TOOL_SCALE, TOOL_ROTATE];
		public var clip:Sprite;
		public var orig_x:Number;
		public var orig_y:Number;
		public var clickx:Number;
		public var clicky:Number;
		public var offx:Number;
		public var offy:Number;
			
		public function ImageEditor(){
			/**************************/
			// cycles through the transform tools using the up and down keys
			// and applies each to the my_mc movieclip
	//		Key.addListener(my_mc);
			
		}
		public function setClip(_mc:Sprite):void{
//			 clip = this._parent;
			 clip = _mc;
		}
		public function disableFreeTransform () :void{
			this.FreeTransformHandler.tool = 0;
			delete this.FreeTransformHandler.onPress;
			delete this.FreeTransformHandler.onRelease;
			delete this.FreeTransformHandler.onReleaseOutside;
		};
		public function enableFreeTransform(tool:String):void{
			switch (tool) {
			case "none" :
			case null :
			case undefined :
			case false :
			case 0 :
				this.disableFreeTransForm();
				break;
			default :
				if (!this.FreeTransformHandler) {
					this.createEmptyMovieClip("FreeTransformHandler", 60001).hitArea = this;
					ASSetPropFlags(this, "FreeTransformHandler", 1, 1);
				}
				this.FreeTransformHandler.tool = tool;
				this.FreeTransformHandler.onPress = SimpleFreeTransform.onPress;
				this.FreeTransformHandler.onRelease = this.FreeTransformHandler.onReleaseOutside=SimpleFreeTransform.onRelease;
			}
		};
		/////////////////////////////////////////////////////////
		public function onReleaseHandler():void{
		//	delete this.onMouseMove;
			this._parent.FTScaleRegulator.removeMovieClip();
		};
		public function onPressHandler():void{
		}
		/////////STATES ////////////////////////////////////////
		/*.................................................................*/
		 public function s_initial(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_INIT :
					return s_noTool;
			}
			return  s_root;
		}
		/*.................................................................*/
		public function s_noTool(e : CogEvent):Function {
			//this.__cStateOpts = [E];
			//if (e.sig != SIG_EMPTY  && e.sig != SIG_EMPTY) {
			//trace(sn + e);
			//}
			switch (e.sig) {
				case SIG_ENTRY :
					//timeline.s0Vis.gotoAndStop(2);
					return null;
				case SIG_EXIT :
					//timeline.s0Vis.gotoAndStop(1);
					return null;
				case SIG_INIT :
					return s_1;
			}
			return  s_root;
		}
		public function s_movingTool(event:CogEvent):Function{
			var orig_x = clip._x;
			var orig_y = clip._y;
			var clickx = clip._parent._xmouse;
			var clicky = clip._parent._ymouse;
			var offx = clickx-orig_x;
			var offy = clicky-orig_y;
			this.onMouseMove = function() {
				if (Key.isDown(Key.SHIFT)) {
					var thisx = clip._parent._xmouse-clickx;
					var thisy = clip._parent._ymouse-clicky;
					if (Math.abs(thisx)>Math.abs(thisy)) {
						clip._x = clip._parent._xmouse-offx;
						clip._y = orig_y;
					} else {
						clip._x = orig_x;
						clip._y = clip._parent._ymouse-offy;
					}
				} else {
					clip._x = clip._parent._xmouse-offx;
					clip._y = clip._parent._ymouse-offy;
				}
				updateAfterEvent();
			};
			
		}
		public function s_scalingTool(event:CogEvent):Function{
		
			var r = clip._parent.createEmptyMovieClip("FTScaleRegulator", 60000);
			trace("clipB." + clip.getBounds + " " + clip.getBounds(_root));
			var b = _root.my_mc.getBounds(_root.my_mc);
			trace(b.xMin);
			r.match(clip, "_rotation", "_x", "_y");

			//var b = clip.getBounds.apply(clip, [clip]);
			var b = _root.my_mc.getBounds(_root.my_mc);
			
					trace(" b " + b + " clip " + clip + " clipp " + clip._parent + " " + b.xMin);
			var clickXscale = clip._xscale;
			var clickYscale = clip._yscale;
			var sx = clickXscale/(r._xmouse/b.xMin);
			var sy = clickYscale/(r._ymouse/b.yMin);
			this.onMouseMove = function() {
				if (Key.isDown(Key.SHIFT)) {
					var scale = Math.max(((r._xmouse*sx/clickXscale)/b.xMin), ((r._ymouse*sy/clickYscale)/b.yMin));
					clip._xscale = clickXscale*scale;
					clip._yscale = clickYscale*scale;
				} else {
					trace("scaleing" + clickXscale + " " + r._xmouse + " " + sx + " " + b.xMin);
					clip._xscale = clickXscale*((r._xmouse*sx/clickXscale)/b.xMin);
					clip._yscale = clickYscale*((r._ymouse*sy/clickYscale)/b.yMin);
				}
				updateAfterEvent();
			};
			
		}
		public function s_rotateTool(event:CogEvent):Function{
			var clickAngle = clip.getMouseAngle();
			var clickRotation = clip._rotation;
			this.onMouseMove = function() {
				var r = clickRotation-clickAngle+clip.getMouseAngle();
				clip._rotation = (Key.isDown(Key.SHIFT)) ? r.snap(45, clickRotation) : r;
				updateAfterEvent();
			};			
		}
	}
}