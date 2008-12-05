package com.troyworks.controls.tsliderbar {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * TSimpleSlider
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 26, 2008
	 * DESCRIPTION ::
	#
	 * @author Paul Ortchanian [http://www.reflektions.com]
	#
	 * @version 1.0
	#
	 */

	
	public class TSimpleSlider extends Sprite {

		//- PRIVATE & PROTECTED VARIABLES -------------------------------------------------------------------------

		private static  var nbr_slideWidthVal : Number = 200;		
		// The slidebar width
		private static  var nbr_slideHeightVal : Number = 0.1;	
		// The slidebar height color
		private static  var str_scolorVal : String = "009CAD";	
		// The slidebar color
		private static  var str_bcolorVal : String = "009CAD";	
		// The slidebar button color
		private static  var nbr_initVal : int = 100;			
		// Initial value on the slidebar

		private var num_sliderVal : int;				
		// Slider Value (0-100)
		private var bndRect : Rectangle;				
		// slider drage bound rectangle
		private var slider : Sprite;					
		
		// slider drage bound rectangle

		//- PUBLIC & INTERNAL VARIABLES ---------------------------------------------------------------------------

	
	
	
		//- CONSTRUCTOR -------------------------------------------------------------------------------------------

		public function TSimpleSlider() {
	

			// create bg rectangle
			var bg : Sprite = createRect(slideWidth / 2, 0, slideWidth, slideHeight, slideColor, slide_btnColor);
		
			// create middle line
			var line : Sprite = createRect(slideWidth / 2, 0, 0.1, 10, slideColor, slide_btnColor);

			// create drag button
			slider = createRect(slideWidth, 0, slideHeight + 8, slideHeight + 8, slideColor, slide_btnColor);
		
			// define slider bounds for drag action
			var bx : Number = slideWidth - slideWidth;
			var bw : Number = slideWidth - (2 * slideWidth);
		
			//Set bound rectangle
			bndRect = defineBounds(bx, 0, bw, 0);
		
			// Set slider position according to initial value
			slider.x = getSliderPosition(initVal);
		
			// Set current slider value to initial value
			sliderVal = initVal;
		
			// Add to display list
			addChild(bg);
			addChild(line);
			addChild(slider);
		
			// delegate onclick event
			slider.addEventListener(MouseEvent.MOUSE_DOWN, onDownListener);
			slider.addEventListener(MouseEvent.MOUSE_UP, onUpListener);
		}

		
		//- THE GETTER AND SETTERS ---------------------------------------------------------------------------

		// Assign variables
		
		// To get slider width in pixels
		public static function get slideWidth() : Number {
			return nbr_slideWidthVal;
		}

		// To set slider width in pixels
		public static function set slideWidth(num_value : Number) : void {
			nbr_slideWidthVal = num_value;
		}

		
		// To get slider height in pixels
		public static function get slideHeight() : Number {
			return nbr_slideHeightVal;
		}

		// To set slider height in pixels
		public static function set slideHeight(num_value : Number) : void {
			nbr_slideHeightVal = num_value;
		}

		
		// To get slider color
		public static  function get slideColor() : String {
			return "0x" + str_scolorVal;
		}

		// To set slider color
		public static  function set slideColor(hex : String) : void {
			str_scolorVal = hex
		}

		
		// To get slider button color
		public static  function get slide_btnColor() : String {
			return "0x" + str_bcolorVal;
		}

		// To set slider button color
		public static  function set slide_btnColor(hex : String) : void {
			str_bcolorVal = hex
		}

		// To get slider initial value
		public static  function get initVal() : int {
			return nbr_initVal
		}

		// To set slider initial value
		public static  function set initVal(num : int) : void {
			// Verrify if between 0 and 100 before setting
			if (num >= 0 && num <= 100) {
				nbr_initVal = num
			}
		}

		// get slider value in percentage
		public function get sliderVal() : int {
			return num_sliderVal;
		}

		// set slider value in percentage
		public function set sliderVal(num : int) : void {
			// Verrify if between 0 and 100 before setting
			if (num >= 0 && num <= 100) {
				num_sliderVal = num;
			}
		}

		//- PRIVATE & PROTECTED METHODS ---------------------------------------------------------------------------

		// Creates rectangle MC's
		private function createRect(x : Number,y : Number,w : Number,h : Number,clr1 : String,clr2 : String) : Sprite {

			// Create rectangle MC
			var clip : Sprite = new Sprite();
		
			// Set Colors
			var n_clr1 : Number = parseInt(clr1, 0);
			var n_clr2 : Number = parseInt(clr2, 0);
		
			// Draw rectangle using Drawing API
			clip.graphics.lineStyle(0, n_clr1, 100);
			clip.graphics.beginFill(n_clr2);
			clip.graphics.moveTo(x - w * 0.5, y - h * 0.5);
			clip.graphics.lineTo(x + w * 0.5, y - h * 0.5);
			clip.graphics.lineTo(x + w * 0.5, y + h * 0.5);
			clip.graphics.lineTo(x - w * 0.5, y + h * 0.5);
			clip.graphics.lineTo(x - w * 0.5, y - h * 0.5);
			clip.graphics.moveTo(x, y);
			clip.graphics.endFill();
		
			return clip
		}

		// Defines bounds coordinates for drag as a rectangle
		private function defineBounds(l : Number,t : Number,r : Number,b : Number) : Rectangle {
		
			var boundsRect : Rectangle = new Rectangle(l, t, r, b);

			return boundsRect;
		}

		// Return slider position according to percentage value passed
		private function getSliderPosition(pos : Number) : Number {
			// Get left bound
			var bw : Number = slideWidth - (2 * slideWidth)
		
			// Calculate position of scroll x according to value
			return Math.floor(((pos * slideWidth) / 100) + bw);
		}

		private function sliderPercentage(pos : Number) : Number {
			// Get left bound
			var bw : Number = slideWidth - (2 * slideWidth)
		
			// Calculate percentage according to x position
			return Math.floor((pos - bw) * 100 / slideWidth);
		}

		private function onDownListener(e : MouseEvent) : void {
			// Drag clip user clicked on
			slider.startDrag(false, bndRect);
			// Add event listener for mouseMove
			slider.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveListener);
			// Add event listener for stage mouse UP (this is to simulate onReleaseOutisde)
			stage.addEventListener(MouseEvent.MOUSE_UP, onUpListener);
		}

		private function onUpListener(e : MouseEvent) : void {
			// Stop drag clip user clicked on
			slider.stopDrag();
			// remove event listener for mouseMove
			slider.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveListener);
			// remove event listener for stage mouse Up
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUpListener);
		}

		// on Click action
		private function onMouseMoveListener(e : MouseEvent) : void {
			// Get slider position in percentage
			var percent : Number = sliderPercentage(e.target.x)
			// Set Value for the slider
			sliderVal = percent;
			// Request a post-event screen update (rather than the next scheduled screen update : next ENTERFRAME)
			e.updateAfterEvent();
		}

	//- PUBLIC & INTERNAL METHODS -----------------------------------------------------------------------------

	

	
	//- EVENT HANDLERS ----------------------------------------------------------------------------------------

	
	//- END CLASS ---------------------------------------------------------------------------------------------
	}
}


