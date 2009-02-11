/**
 * ...
 * @author Troy Gardner
 * @version 0.1
 */

package com.troyworks.ui {
	import flash.system.ApplicationDomain;	
	import flash.media.Sound;	
	import flash.display.Sprite;	
	import flash.display.InteractiveObject;	
	import flash.events.MouseEvent;	
	import flash.events.Event;	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;	

	public class UIUtil {
		protected var clipsToWatch : Array;
		var hidx : Object = new Object();

		public function UIUtil(clipsToEffect : Array) {
			this.clipsToWatch = clipsToEffect;
		}

		///// these are useful for printing ///////
		public function hide() : void {
			var hide2 : Array = clipsToWatch.concat();
			var o : Object;
			while(hide2.length > 0) {
				o = hide2.pop();
				if(o != null) {
					trace("hidthing " + o.name);
					hidx[o.name] = o.visible;
					o.visible = false;
				}
			}
		}

		public function resetVisibility() : void {
			var hide2 : Array = clipsToWatch.concat();
			var o : Object;
			while(hide2.length > 0) {
				o = hide2.pop();
				if(o != null) {
					trace("resettinging " + o.name + " " + hidx[o.name]);
				
					o.visible = hidx[o.name];
				}
			}
		}

		public function release() : void {
			while(clipsToWatch.length > 0) {
				clipsToWatch.pop();
			}
		}
		/* get a Sound object by the linkageID from the UI.fla */
		public static function getSoundByLinkageID(soundLinkageId : String) : Sound {
			var cls : Class = ApplicationDomain.currentDomain.getDefinition(soundLinkageId) as Class;
			var snd : Sound = new cls() as Sound;
			return snd;
		}
		/* get a DisplayObject object by the linkageID from the UI.fla */
		public static function getDisplayObjectByLinkageID(soundLinkageId : String) : DisplayObject {
			var cls : Class = ApplicationDomain.currentDomain.getDefinition(soundLinkageId) as Class;
			var dO : DisplayObject = new cls() as DisplayObject;			;
			return dO;
		}

		/* returns the zero based frame label to be used in conjunctin with addFrameScript */

		public static function getNumberOfFrameLabel(mc : MovieClip, lblName : String) : int {
			var nm : String;
			var fn : int;
			for (var i : int = 0;i < mc.currentLabels.length; i++) {
				nm = mc.currentLabels[i].name;
				fn = mc.currentLabels[i].frame;
				if(nm == lblName) {
					trace(" " + nm + " " + ( fn - 1));
					return fn - 1;
				}
			}
			return -1;
		}

		public static function addFrameScriptForLabel(mc : MovieClip, lblName : String, fn : Function ) : int {
			var frameNum : int = UIUtil.getNumberOfFrameLabel(mc, lblName);
			mc.addFrameScript(frameNum, fn);
			return frameNum;
		}

		public static function setInputShieldBehavior(sprite : Sprite, ON : Boolean = true) : void {
			if(ON) {
				sprite.buttonMode = true;
				sprite.mouseChildren = false;
				sprite.useHandCursor = false;
			}else {
				sprite.buttonMode = false;
				sprite.mouseChildren = true;
				sprite.useHandCursor = true;
			}
		}

		public static function getMouseAngle(disObjCon : DisplayObjectContainer) : Number {
			return Math.atan2(disObjCon.parent.mouseY - disObjCon.y, disObjCon.parent.mouseX - disObjCon.x) * 180 / Math.PI;
		};

		
		public static function match(changeClip : DisplayObject, toClip : DisplayObject, withProps : Array = null) : void {
			
			if (withProps == null) {
				withProps = [null, "alpha", "visible", "rotation", "scaleX", "scaleY", "x", "y"];
			}
			var L : Number = withProps.length;
			while (--L) {
				changeClip[withProps[L]] = toClip[withProps[L]];
			}
		}

		/***********************************
		 * Used in sort operations
		 * **********************************/
		public static function order_X(a : DisplayObject, b : DisplayObject) : Number {
			if (a.x < b.x) {
				return -1;
			} else if (a.x > b.x) {
				return 1;
			} else {
				return 0;
			}
		}

		public static function order_Y(a : DisplayObject, b : DisplayObject) : Number {
			if (a.y < b.y) {
				return -1;
			} else if (a.y > b.y) {
				return 1;
			} else {
				return 0;
			}
		}

		/********************************************************
		 * This traverses the parent.parent chain of a displaylist
		 * appending the name of a clip
		 * it's useful for absolute pathing a given leave
		 * for debugging and for associating dynamic data with it
		 * */
		public static function getFullPath(child : DisplayObject, showRoot : Boolean = false) : String {
			var cur : DisplayObject = child;
			var pathA : Array = new Array();
			var res : String;
			while(cur.parent != null) {
				//trace("parent" + cur.parent);
				if(cur.parent != null) {
					pathA.push(cur.name);
					if(!showRoot && cur.parent == cur.stage) {
						break;
					}else {
						cur = cur.parent;
					}
				}
			}
			pathA.reverse();
			trace("res " + res);
			res = pathA.join(".");
			return res;
		}

		/* 
		 * will return if the passed in clip distance from the local root
		 * note in the case of multiple swfs, they have their own independent roots.
		 * nominally should be 1, as 
		 * by the maintimeline/root> passed in clip
		 */

		public static function getDepthFromRoot(child : DisplayObject) : int {
			var cur : DisplayObject = child;
			var res : int = 1;
			while(cur.parent != null) {
				if(cur.parent != null) {
					res++;
					//trace(cur + "'s parent is " + cur.parent);
					if(cur.parent == cur.root) {
						break;
					}else {
						
						cur = cur.parent;
					}
				}
			}
			return res;
		}

		/* 
		 * will return if the passed in clip is a top level clip as defined
		 * by the stage>maintimeline/root> passed inclip
		 * this is useful to avoid library collisions/contentions  
		 */
		public static function isTopLevel(child : DisplayObject) : Boolean {
			return getDepthFromStage(child) == 2;
		}

		/* 
		 * will return if the passed in clip distance from the stage
		 * nominally should be 2, as 
		 * by the stage>maintimeline/root> passed in clip
		 */

		public static function getDepthFromStage(child : DisplayObject) : int {
			var cur : DisplayObject = child;
			var res : int = 1;
			while(cur.parent != null) {
				if(cur.parent != null) {
					res++;
					trace(cur + "'s parent is " + cur.parent);
					if(cur.parent == cur.stage) {
						break;
					}else {
						
						cur = cur.parent;
					}
				}
			}
			return res;
		}
	}
}
