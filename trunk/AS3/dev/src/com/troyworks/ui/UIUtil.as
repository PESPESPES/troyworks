/**
 * ...
 * @author Troy Gardner
 * @version 0.1
 */

package com.troyworks.ui {
	import flash.geom.Rectangle;	
	import flash.display.Stage;	
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
		public var clipsToWatch : Array;
		private var hidx : Object = new Object();
		private var isHidden : Boolean;

		public function UIUtil(clipsToEffect : Array) {
			this.clipsToWatch = clipsToEffect;
		}

		public function makeVisible() : void {
			
			var hide2 : Array = clipsToWatch.concat();
			var o : Object;
			while(hide2.length > 0) {
				o = hide2.pop();
				if(o != null) {
					trace("showing " + o.name);
					o.visible = true;
					hidx[o.name] = o.visible;
				}
			}
			isHidden = false;
		}

		///// these are useful for printing, switching from edit to preview mode etc. ///////
		public function hide() : void {
			if(!isHidden) {
				var hide2 : Array = clipsToWatch.concat();
				var o : Object;
				while(hide2.length > 0) {
					o = hide2.pop();
					if(o != null) {
						trace("hiding " + o.name);
						hidx[o.name] = o.visible;
						o.visible = false;
					}
				}
				isHidden = true;
			}
		}

		/*********************************************
		 * Stack based visibility management, as an alternative
		 * to adding/removing from displayList or frame based management
		 * 
		 */
		public static function hideExcept(disObjCon : DisplayObjectContainer, except : Array = null, dontProcess : Array = null, remove : Boolean = false) : void {
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
				//	dO.alpha = .3;
					/*	if(remove){
						disObjCon.removeChild(dO);
						}
						if(dO is DisplayObjectContainer) {
							DisplayObjectContainer(dO).mouseEnabled = false;
							DisplayObjectContainer(dO).mouseChildren = false;
							DisplayObjectContainer(dO).tabEnabled = false;
						}*/
					} else {
						//	dO.alpha = .8;
						dO.visible = true;
					/*	if(dO is DisplayObjectContainer) {
							DisplayObjectContainer(dO).mouseEnabled = true;
							DisplayObjectContainer(dO).mouseChildren = true;
							DisplayObjectContainer(dO).tabEnabled = true;
						}*/
					}
				}
			}
		}

		public function resetVisibility() : void {
			isHidden = false;
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

		public function moveTo(x : int, y : int) : void {
			for(var i : int = 0;i < clipsToWatch.length; i++) {
				clipsToWatch[i].x = x;
				clipsToWatch[i].y = y;
			}
		}

		/* get a Sound object by the linkageID from the UI.fla */
		public static function getSoundByLinkageID(soundLinkageId : String) : Sound {
			var cls : Class = ApplicationDomain.currentDomain.getDefinition(soundLinkageId) as Class;
			var snd : Sound = new cls() as Sound;
			return snd;
		}

		/* get a DisplayObject object by the linkageID from the UI.fla */
		public static function getDisplayObjectByLinkageID(linkageID : String) : DisplayObject {
			var cls : Class = ApplicationDomain.currentDomain.getDefinition(linkageID) as Class;
			var dO : DisplayObject = new cls() as DisplayObject;;
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
			} else {
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
					} else {
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
		 * Returns a path with frame labels, really a deeplink pointer in the displaylist (minus depth)
		 * e.g.  Some.swf#[2].outside_mc[1].middle_mc[1].inner_mc
		 * 
		 */
		public static function getAnchorPath(child : DisplayObject, showRoot : Boolean = false) : String {
			var cur : DisplayObject = child;
			var pathA : Array = new Array();
			var res : String;
			var isLeaf : Boolean = true;

			while (cur.parent != null) {
				trace("parent" + cur.parent + " == " + cur.parent.name + " " + (cur.parent is Stage));
				if (cur.parent != null) {
					//trace("url " + cur.loaderInfo.url);

					if ( !isLeaf ) {
						if ( cur is MovieClip) {
							pathA.push("[" + (cur as MovieClip).currentFrame + "].");
						} else {
							pathA.push(".");
						}
					}
					if ( cur == child.root) {
						break;
					} else {
						trace("moving up");
						pathA.push(cur.name);
						cur = cur.parent;
						isLeaf = false;
					}
				} else {
					trace("no path above ");
				}
			}
			cur = cur.parent;
			if ( cur is Stage) {
				trace("found stage111111111111111");
				//break;
				var st : String = cur.loaderInfo.url;
				var la : int = st.lastIndexOf("\\", st.length);
				var lb : int = st.lastIndexOf("/", st.length);
				var ci : int = Math.max(la, lb);
				var st2 : String = st.substring(ci + 1, st.length);
				//st2 = st2.replace(".swf", "SWF");
				trace("swf name " + st2);
				pathA.push(st2 + "#");
			}
			pathA.reverse();
			trace("res " + res);
			//res = pathA.join(".");
			res = pathA.join("");
			return res;
		}
		/* returns the collective rotational transform of the target clip to the stage */
		public static function getCollectiveTransformsToStage(child : DisplayObject) : Object {
			var cur : DisplayObject = child;
			var sp : Sprite = new Sprite();
			var b:Rectangle = child.getBounds(child);
			sp.graphics.drawRect(b.x,b.y,b.width, b.height);
			//sp.rotation = child.rotation;
			//trace("start child " + child.stage);
			var hitRoot:Boolean = false;
			while (cur.parent != null) {
				if (cur.parent != null) {
					sp.x +=cur.x;
					sp.y +=cur.y;
					sp.rotation += cur.rotation;
					sp.scaleX *= cur.scaleX;
					sp.scaleY *= cur.scaleY;
					sp.visible = (!sp.visible)?false:cur.visible;
				//	trace("start " + cur.name + " visible " + cur.visible  + " " + cur.stage);
					//trace(cur + "'s parent is " + cur.parent);
					if (cur.parent == cur.stage) {
						
						hitRoot = true;
						break;
					} else {
						cur = cur.parent;
					}
				}
			}
			if(!hitRoot || child.stage == null){
			//	trace("removed from stage ");
				sp.visible =false;
			}
			return sp;
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
					} else {
						
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
					} else {
						
						cur = cur.parent;
					}
				}
			}
			return res;
		}
	}
}
