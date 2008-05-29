package com.troyworks.framework.ui.layout { 
	import com.troyworks.geom.d2.Rect2D;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class CollisionDetection {
		public static var DEBUG_MC:MovieClip;
		public static var DEBUG_ON:Boolean = false;
		public static function checkForBoundsCollision(bounds1 : Bounds2, bounds2 : Bounds2) : Bounds2{
			var res : Bounds2 = null;
			/////////// looking for overlaps between bounds /////////////
			var leftOf : Boolean = (bounds1.xMax<bounds2.xMin);
			var rightOf : Boolean = (bounds2.xMax<bounds1.xMin);
			var aboveOf : Boolean = (bounds1.yMax<bounds2.yMin);
			var belowOf : Boolean = (bounds2.yMax<bounds1.yMin);
			if ((leftOf || rightOf) || (aboveOf || belowOf)) {
			/////////// NO OVERLAP //////////
			//  Failed basic boundary check
				//	trace("checkForCollision failed first boundary check x1 " + c1 + " x2 " + c2 + " y3 " + c3 + " y4 " + c4);
			}else{
				///////// OVERLAP //////////////////
				var intersectionBounds : Bounds2 = new Bounds2();
				intersectionBounds.xMin = Math.max(bounds1.xMin, bounds2.xMin);
				intersectionBounds.xMax = Math.min(bounds1.xMax, bounds2.xMax);
				intersectionBounds.yMin = Math.max(bounds1.yMin, bounds2.yMin);
				intersectionBounds.yMax = Math.min(bounds1.yMax, bounds2.yMax);
				res = intersectionBounds;
			}
			return res;
		}
		public static function getBoundsRelationshipMC(_mcA : MovieClip, _mcB : MovieClip, scope : MovieClip) : BoundsRelationship{
			return getBoundsRelationship(Bounds2.getBounds(_mcA,scope), Bounds2.getBounds(_mcB, scope));
		}
	
		public static function getBoundsRelationship(bounds1 : Bounds2, bounds2 : Bounds2) : BoundsRelationship{
			var res : Number = new Number();
			var leftOf : Boolean = (bounds1.xMax<bounds2.xMin);
			var rightOf : Boolean = (bounds2.xMax<bounds1.xMin);
			var aboveOf : Boolean = (bounds1.yMax<bounds2.yMin);
			var belowOf : Boolean = (bounds2.yMax<bounds1.yMin);
		//	trace("leftOf " +leftOf + " rightOf " +rightOf + " aboveOf " + aboveOf + " belowOf " + belowOf);
			if ((leftOf || rightOf) || (aboveOf || belowOf)) {
			//	trace("Not Touching");
				res = res | BoundsRelationship.ARE_NOT_TOUCHING;	
			}else{
				//trace("OverLapping");
				res = res | BoundsRelationship.OVERLAPPING;
				var intersectionBounds : Bounds2 = new Bounds2();
				intersectionBounds.xMin = Math.max(bounds1.xMin, bounds2.xMin);
				intersectionBounds.xMax = Math.min(bounds1.xMax, bounds2.xMax);
				intersectionBounds.yMin = Math.max(bounds1.yMin, bounds2.yMin);
				intersectionBounds.yMax = Math.min(bounds1.yMax, bounds2.yMax);
				trace("b1.min " + bounds1.yMin + " mid " + bounds1.yMid + " " + bounds2.yMid + "  max " + bounds1.yMax);
				if(bounds1.yMid < bounds2.yMid){
					trace("onTopSide Of");
					res = res | BoundsRelationship.ON_TOP_SIDE_OF;
				}else if(bounds1.yMid > bounds2.yMid){
					trace("onBottomside of");
					res = res | BoundsRelationship.ON_BOTTOM_SIDE_OF;
				}else{
					trace("unknown vertical relationship");
				}
				if(bounds1.xMax < bounds2.xMid){
					res = res | BoundsRelationship.ON_LEFT_SIDE_OF;
				}else if(bounds1.xMin > bounds2.xMid){
					res = res | BoundsRelationship.ON_RIGHT_SIDE_OF;
				}
			}
			if(leftOf && rightOf && aboveOf && belowOf){
				res = res | BoundsRelationship.CONTAINS;
			}
			if(leftOf){
				res = res | BoundsRelationship.LEFT_OF;
			}
			if(rightOf){
				res = res | BoundsRelationship.RIGHT_OF;
			}
			if(aboveOf){
				res = res |BoundsRelationship.ABOVE_OF;
			}
			if(belowOf){
				res = res |BoundsRelationship.BELOW_OF;
			}
	
			return new BoundsRelationship(res);
		}
		/* This collision method is used for when clips provide a relatively static cached bitmap representation of themselves
		 * to use as a hit test area. It's not as good for dynamically changing clips or those rotated/scaled etc.
		 */
		public static function hitTestBitmaps(clipA : IHaveBitmapHitTest, clipB : IHaveBitmapHitTest) : Boolean{
			var bitmapA : BitmapData = clipA.getBitmapHitTest();
			var bitmapB : BitmapData = clipB.getBitmapHitTest();
			var res : Boolean = bitmapA.hitTest(new Point(0,0), 255, bitmapB, new Point(0,0));
			return res;
			
		}
		/*
		 * This is based off Grant Skinner's approach to projecting the two images with different colors
		 * to a white canvas, using the overlapping shilloette to determine the hit area.
		 * Provides a nice way to visualize the zones if _root.drawin exists, and returns info about 
		 * the collision area.
		 * 
		 * Changed to deal with clips that don't have center registration points.
		 */
		public static function checkForCollision(moving_mc : MovieClip, reference_mc : MovieClip, p_alphaTolerance : Number, p_scope : MovieClip) : Rectangle {
			// set up default params:
			if (p_alphaTolerance == undefined) {
				p_alphaTolerance = 255;
			}
			if (p_scope == undefined) {
				p_scope = _root;
			}
			// get bounds:
			var cursorBounds : Object = moving_mc.getBounds(p_scope);
			var clipBounds : Object = reference_mc.getBounds(p_scope);
			var clipSelfBounds : Object = reference_mc.getBounds(reference_mc);
			//trace(util.Trace.me(cursorBounds, "Bounds1", true));
			//trace(util.Trace.me(clipBounds, "Bounds2", true));
			// rule out anything that we know can't collide:
			var rightOf : Boolean = (cursorBounds.xMax<clipBounds.xMin);
			var leftOf : Boolean = (clipBounds.xMax<cursorBounds.xMin);
			var aboveOf : Boolean = (cursorBounds.yMax<clipBounds.yMin);
			var belowOf : Boolean = (clipBounds.yMax<cursorBounds.yMin);
			if ((leftOf || rightOf) || (aboveOf || belowOf)) {
				// Failed basic boundary check
				return null;
			} else {
				// determine test area boundaries:
				var bounds : Object = {};
				bounds.xMin = Math.max(cursorBounds.xMin, clipBounds.xMin);
				bounds.xMax = Math.min(cursorBounds.xMax, clipBounds.xMax);
				bounds.yMin = Math.max(cursorBounds.yMin, clipBounds.yMin);
				bounds.yMax = Math.min(cursorBounds.yMax, clipBounds.yMax);
	//			trace("interX "+(bounds.xMax-bounds.xMin)+" "+bounds.xMax+" "+bounds.xMin);
	//			trace("interY "+(bounds.yMax-bounds.yMin)+" "+bounds.yMax+" "+bounds.yMin);
				//////////// CREATE A HIT AREA OF THE COLLISION AREA BOUNDING BOX ///////////
				var img : BitmapData = new BitmapData(bounds.xMax-bounds.xMin,bounds.yMax-bounds.yMin,false);
			//DEBUG SEE MORE OF THE SURROUNDING AREA
			//	var img:BitmapData = new BitmapData(150, 150, false);
				// draw in the first image:
				var mat1 : Matrix = moving_mc.transform.matrix;
				mat1.tx = moving_mc.x-bounds.xMin;
				mat1.ty = moving_mc.y-bounds.yMin;
				// overlay the second (reference) image, offsetting it if the registration isn't at 0,0
				var mat2 : Matrix = reference_mc.transform.matrix;
				mat2.ty = -clipSelfBounds.yMin * reference_mc.scaleY/100;
				mat2.tx = -clipSelfBounds.xMin * reference_mc.scaleX/100;
	
				//Draw the Cursor
				img.draw(moving_mc, mat1, new ColorTransform(1, 1, 1, 1, 255, -255, -255, p_alphaTolerance));
				//Draw the movie clip
				img.draw(reference_mc, mat2, new ColorTransform(1,1,1,1,255,255,255,p_alphaTolerance),"difference");
				if(DEBUG_ON){
					
					getDebugMC().addChildAt(img, 2);
				}
				// find the intersection, based on the color overlap:
				var intersection : Rectangle = img.getColorBoundsRect(0xFFFFFFFF, 0xFF00FFFF);
		//		trace("insection "+intersection);
				// if there is no intersection, return null:
				if (intersection == undefined || intersection.width == 0) {
		//			trace("XXXXX FAILED XXXXX");
					return null;
				} else {
	//				trace("GGGGGGGGGGGGGGGGGG SUCESSS GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
				// translate the intersection to the appropriate coordinate space:
					intersection.x += bounds.xMin;
					intersection.y += bounds.yMin;
					return intersection;
	
				}
			}
		}
		
		public static function getDebugMC() : MovieClip {
			if(_root.drawin== null){
					DEBUG_MC = _root.createEmptyMovieClip("drawin",_root.getNextHighestDepth());
			}
			return DEBUG_MC;
			
		}
	
	}
}