﻿package com.troyworks.controls.tdraggable{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
		import flash.events.Event;

	import com.troyworks.controls.tparticleengine.PhysicsParticle;
	import flash.filters.GlowFilter;
	import com.troyworks.framework.SelectionManager;
	import flash.filters.DropShadowFilter;
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	import flash.text.TextField;
	public class DraggableClip extends MovieClip {
		public var isBeingDragged : Boolean = false;
		protected var m_isSelected : Boolean = false;
		protected var m_selectedOrder : Number = 0;
		public static  var selectionMan:SelectionManager;
		public var filtersArr : Array;
		public var glow : GlowFilter = null;

		protected var lastMX : Number;

		protected var lastMY : Number;

		public var lastX : Number;

		public var lastY : Number;
		public var id : Number;
		public var p : PhysicsParticle;
		public var label_txt:TextField;

		public static  var MOVING:Number= 0;
		public static  var COPYING:Number= 1;

		public var dragMode:Number= MOVING;

		protected var tY:Number= NaN;

		protected var tX :Number = NaN;
		private var myBitmapData : BitmapData;

		public function DraggableClip() {
			super();
			trace("DraggableClip");
			if (selectionMan == null) {
				selectionMan = new SelectionManager("DraggableClipSelectionManager", parent);
			}
			//if(parent.getChildByName(name))
			addEventListener(MouseEvent.MOUSE_DOWN, onMOUSE_DOWN);
			addEventListener(MouseEvent.MOUSE_UP, onMOUSE_UP);
			addEventListener(Event.ENTER_FRAME, onLoadHandler);
		}
		public function onLoadHandler(evt:Event = null):void {
			//onReleaseOutside =onRelease;
			removeEventListener(Event.ENTER_FRAME, onLoadHandler);
			if(label_txt != null){
			label_txt.text = String(id);
			}
		}
		public function get isSelected():Boolean {
			return m_isSelected;
		}
		public function set isSelected(t : Boolean) {
			m_isSelected = t;
			onSelectionChanged();
		}
		public function onMOUSE_DOWN(evt:MouseEvent = null):void {
			trace("selected " + name);

			isSelected = !isSelected;
			tX = NaN;
			tY = NaN;
		}
		public function onMOUSE_UP(evt:MouseEvent = null):void {
			selectionMan.onChildRelease = selectedOrder;
			if (!isNaN(tX)&& !isNaN(tY)) {
				x = tX;
				y = tY;
				tX = NaN;
				tY = NaN;
				isSelected = false;
			}
		}
		public function onSelectionChanged():void {
			trace("onSelectionChanged");
			if (isSelected) {
				selectionMan.push(this);
				onStartDrag();
			} else {
				selectionMan.remove(this);
				selectedOrder = -1;
				onStopDrag();
			}
		}
		public function set selectedOrder(pos:Number) {
			m_selectedOrder = pos;
			trace("selected Order " + pos + "--------------------------------------");
			filtersArr = new Array();
			if (isSelected) {
				selectionMan.setTopClip(this);
				if (m_selectedOrder == (selectionMan.totalSelected)) {
					glow = new GlowFilter(0xFF0000,100, 2,2,10, 10);
				} else if (m_selectedOrder == 1) {
					glow = new GlowFilter(0x00FF00,100, 2,2,10, 10);

				} else {
					glow = new GlowFilter(0xFFFF00,100, 2,2,10, 10);
				}
				var ds:DropShadowFilter = new DropShadowFilter(10,45,0xCCCCCC,4);
				ds.alpha = 4;
				ds.blurX = 10;
				ds.blurY = 10;

				filtersArr.push(glow);
				filtersArr.push(ds);
			} else {
			}
			filters = filtersArr;

		}
		public function get selectedOrder():Number {
			return m_selectedOrder;
		}
		public function onStartDrag():void {
			if (isSelected) {
				if (dragMode == MOVING) {
					lastMX = parent.mouseX;
					lastMY = parent.mouseY;
					//onMouseMove = drag;
					addEventListener(MouseEvent.MOUSE_MOVE, drag);
					isBeingDragged = true;
					lastX = x;
					lastY = y;
				} else if (dragMode == COPYING) {
					myBitmapData.draw(this);
				}
			}
		}
		public function onStopDrag():void {
			//delete onMouseMove;
			removeEventListener(MouseEvent.MOUSE_MOVE, drag);
			isBeingDragged = false;
		}
		public function drag(evt:MouseEvent = null):void {
			trace(name + " MouseMOve/Drag");
			x += parent.mouseX - lastMX;
			y += parent.mouseY- lastMY;
			lastMX = parent.mouseX;
			lastMY = parent.mouseY;

		}
	}
}