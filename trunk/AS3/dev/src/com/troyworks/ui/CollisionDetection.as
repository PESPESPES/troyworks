package com.troyworks.ui {
	import flash.display.DisplayObject;	
	import flash.display.Bitmap;	
	import flash.display.DisplayObjectContainer;	

	import com.troyworks.ui.BoundsRelationship;

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
		public static var DEBUG_MC : MovieClip;
		public static var DEBUG_ON : Boolean = false;

		public static function checkForBoundsCollision(bounds1 : Rectangle, bounds2 : Rectangle) : Rectangle {
			var res : Rectangle = null;
			/////////// looking for overlaps between bounds /////////////
			var leftOf : Boolean = (bounds1.right < bounds2.left);
			var rightOf : Boolean = (bounds2.right < bounds1.left);
			var aboveOf : Boolean = (bounds1.bottom < bounds2.top);
			var belowOf : Boolean = (bounds2.bottom < bounds1.top);
			if ((leftOf || rightOf) || (aboveOf || belowOf)) {
			/////////// NO OVERLAP //////////
			//  Failed basic boundary check
				//	trace("checkForCollision failed first boundary check x1 " + c1 + " x2 " + c2 + " y3 " + c3 + " y4 " + c4);
			}else {
				///////// OVERLAP //////////////////
				var intersectionBounds : Rectangle = new Rectangle();
				intersectionBounds.left = Math.max(bounds1.left, bounds2.left);
				intersectionBounds.right = Math.min(bounds1.right, bounds2.right);
				intersectionBounds.top = Math.max(bounds1.top, bounds2.top);
				intersectionBounds.bottom = Math.min(bounds1.bottom, bounds2.bottom);
				res = intersectionBounds;
			}
			return res;
		}

		public static function getBoundsRelationshipMC(_mcA : DisplayObject, _mcB : DisplayObject, scope : MovieClip) : BoundsRelationship {
			return getBoundsRelationship(_mcA.getBounds(scope), _mcB.getBounds(scope));
		}

		public static function getBoundsRelationship(bounds1 : Rectangle, bounds2 : Rectangle) : BoundsRelationship {
			var resF : Number = new Number();
			var res:BoundsRelationship = new BoundsRelationship(resF);
			var leftOf : Boolean = (bounds1.right < bounds2.left);
			var rightOf : Boolean = (bounds2.right < bounds1.left);
			var aboveOf : Boolean = (bounds1.bottom < bounds2.top);
			var belowOf : Boolean = (bounds2.bottom < bounds1.top);
			//	trace("leftOf " +leftOf + " rightOf " +rightOf + " aboveOf " + aboveOf + " belowOf " + belowOf);
			if ((leftOf || rightOf) || (aboveOf || belowOf)) {
				//	trace("Not Touching");
				resF = resF | BoundsRelationship.ARE_NOT_TOUCHING;	
			}else {
				//trace("OverLapping");
				resF = resF | BoundsRelationship.OVERLAPPING;
				var intersectionBounds : Rectangle = new Rectangle();
				intersectionBounds.left = Math.max(bounds1.left, bounds2.left);
				intersectionBounds.right = Math.min(bounds1.right, bounds2.right);
				intersectionBounds.top = Math.max(bounds1.top, bounds2.top);
				intersectionBounds.bottom = Math.min(bounds1.bottom, bounds2.bottom);
				res.intersectionBounds  = intersectionBounds;
				var yMid1 : Number = bounds1.y + bounds1.height / 2;
				var yMid2 : Number = bounds2.y + bounds2.height / 2;
				var xMid1 : Number = bounds1.x + bounds1.width / 2;
				var xMid2 : Number = bounds2.x + bounds2.width / 2;
				//trace("b1.min " + bounds1.top + " mid " + bounds1.yMid + " " + bounds2.yMid + "  max " + bounds1.bottom);
				if(yMid1 < yMid2) {
					trace("onTopSide Of");
					resF = resF | BoundsRelationship.ON_TOP_SIDE_OF;
				}else if(yMid1 > yMid2) {
					trace("onBottomside of");
					resF = resF | BoundsRelationship.ON_BOTTOM_SIDE_OF;
				}else {
					trace("unknown vertical relationship");
				}
				if(xMid1 < xMid2) {
					resF = resF | BoundsRelationship.ON_LEFT_SIDE_OF;
				}else if(xMid1 > xMid2) {
					resF = resF | BoundsRelationship.ON_RIGHT_SIDE_OF;
				}
			}
			if(leftOf && rightOf && aboveOf && belowOf) {
				resF = resF | BoundsRelationship.CONTAINS;
			}
			if(leftOf) {
				resF = resF | BoundsRelationship.LEFT_OF;
			}
			if(rightOf) {
				resF = resF | BoundsRelationship.RIGHT_OF;
			}
			if(aboveOf) {
				resF = resF | BoundsRelationship.ABOVE_OF;
			}
			if(belowOf) {
				resF = resF | BoundsRelationship.BELOW_OF;
			}
			res.setFlags(resF);
			return res;
		}

		/* This collision method is used for when clips provide a relatively static cached bitmap representation of themselves
		 * to use as a hit test area. It's not as good for dynamically changing clips or those rotated/scaled etc.
		 */
		public static function hitTestBitmaps(clipA : IHaveBitmapHitTest, clipB : IHaveBitmapHitTest) : Boolean {
			var bitmapA : BitmapData = clipA.getBitmapHitTest();
			var bitmapB : BitmapData = clipB.getBitmapHitTest();
			var res : Boolean = bitmapA.hitTest(new Point(0, 0), 255, bitmapB, new Point(0, 0));
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
		public static function checkForCollision(moving_mc : MovieClip, reference_mc : MovieClip, p_alphaTolerance : Number = 255, p_scope : DisplayObjectContainer = null) : Rectangle {
			// set up default params:
		
			if (p_scope == null) {
				p_scope = moving_mc.stage;
			}
			// get bounds:
			var cursorBounds : Object = moving_mc.getBounds(p_scope);
			var clipBounds : Object = reference_mc.getBounds(p_scope);
			var clipSelfBounds : Object = reference_mc.getBounds(reference_mc);
			//trace(util.Trace.me(cursorBounds, "Bounds1", true));
			//trace(util.Trace.me(clipBounds, "Rectangle", true));
			// rule out anything that we know can't collide:
			var rightOf : Boolean = (cursorBounds.right < clipBounds.left);
			var leftOf : Boolean = (clipBounds.right < cursorBounds.left);
			var aboveOf : Boolean = (cursorBounds.bottom < clipBounds.top);
			var belowOf : Boolean = (clipBounds.bottom < cursorBounds.top);
			if ((leftOf || rightOf) || (aboveOf || belowOf)) {
				// Failed basic boundary check
				return null;
			} else {
				// determine test area boundaries:
				var bounds : Object = {};
				bounds.left = Math.max(cursorBounds.left, clipBounds.left);
				bounds.right = Math.min(cursorBounds.right, clipBounds.right);
				bounds.top = Math.max(cursorBounds.top, clipBounds.top);
				bounds.bottom = Math.min(cursorBounds.bottom, clipBounds.bottom);
				//			trace("interX "+(bounds.right-bounds.left)+" "+bounds.right+" "+bounds.left);
				//			trace("interY "+(bounds.bottom-bounds.top)+" "+bounds.bottom+" "+bounds.top);
				//////////// CREATE A HIT AREA OF THE COLLISION AREA BOUNDING BOX ///////////
				var img : BitmapData = new BitmapData(bounds.right - bounds.left, bounds.bottom - bounds.top, false);
				//DEBUG SEE MORE OF THE SURROUNDING AREA
				//	var img:BitmapData = new BitmapData(150, 150, false);
				// draw in the first image:
				var mat1 : Matrix = moving_mc.transform.matrix;
				mat1.tx = moving_mc.x - bounds.left;
				mat1.ty = moving_mc.y - bounds.top;
				// overlay the second (reference) image, offsetting it if the registration isn't at 0,0
				var mat2 : Matrix = reference_mc.transform.matrix;
				mat2.ty = -clipSelfBounds.top * reference_mc.scaleY / 100;
				mat2.tx = -clipSelfBounds.left * reference_mc.scaleX / 100;
	
				//Draw the Cursor
				img.draw(moving_mc, mat1, new ColorTransform(1, 1, 1, 1, 255, -255, -255, p_alphaTolerance));
				//Draw the movie clip
				img.draw(reference_mc, mat2, new ColorTransform(1, 1, 1, 1, 255, 255, 255, p_alphaTolerance), "difference");
				if(DEBUG_ON) {
					
					getDebugMC().addChildAt(new Bitmap(img), 2);
				}
				// find the intersection, based on the color overlap:
				var intersection : Rectangle = img.getColorBoundsRect(0xFFFFFFFF, 0xFF00FFFF);
				//		trace("insection "+intersection);
				// if there is no intersection, return null:
				if ( intersection.width == 0) {
					//			trace("XXXXX FAILED XXXXX");
					return intersection;
				} else {
					//				trace("GGGGGGGGGGGGGGGGGG SUCESSS GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
					// translate the intersection to the appropriate coordinate space:
					intersection.x += bounds.left;
					intersection.y += bounds.top;
					return intersection;
				}
			}
		}

		public static function getDebugMC() : MovieClip {
			//	if(.drawin== null){
			//		DEBUG_MC = _root.createEmptyMovieClip("drawin",_root.getNextHighestDepth());
			///	}
			return DEBUG_MC;
		}
	}
}