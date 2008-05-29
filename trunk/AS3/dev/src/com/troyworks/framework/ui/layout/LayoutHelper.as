package com.troyworks.framework.ui.layout { 
	import flash.geom.Rectangle;
	import com.troyworks.geom.d2.Rect2D;
	import com.troyworks.geom.d2.Point2D;
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class LayoutHelper {
	
		protected var layoutStructure : String;
	
		protected var m_bounds : Rect2D;
	
		protected var cradius : Number;
	
		protected var radius : Number;
	
		protected var hspace : Number;
	
		protected var revolutions : Number;
	
		protected var orientation : String;
	
		protected var deg : Number;
	
		protected var step : Number;
	
		protected var rstep : Number;
	
		protected var CX : Number;
	
		protected var CY : Number;
		
		public static var LINEAR:String = "LINEAR";
		public static var GRID:String = "GRID";
		public static var HONEYCOMB:String = "HONEYCOMB";	
		public static var CIRCULAR:String = "CIRCULAR";
		public static var SPIRAL:String = "SPIRAL";
		/* equally distributed across the bounding square */
		public static var SQUARE_DISTRIBUTION:String = "SQUARE_DISTRIBUTION";
		/* more focused aroudn the center */
		public static var SQUARE_DISTRIBUTIONC:String = "SQUARE_DISTRIBUTIONC";
		/* equally distributed across the bounding square */
		public static var CIRCULAR_DISTRIBUTION:String = "CIRCULAR_DISTRIBUTION";
		
		
		public function	LayoutHelper(type:String, boundary:Rect2D) {
			layoutStructure = (type== null)?SQUARE_DISTRIBUTIONC :type ;
			bounds = boundary;
			cradius = 300;
			// in circular the radius things are placed on, in spiral the inital radius
			radius = 150;
			// in linear mode the gap between clips
			hspace = 10;
			// in spiral mode how many times to loop around
			revolutions = 1;
			orientation = "horizontal";
		};
		public function set bounds(b:Rect2D):void{
			m_bounds = b;
			
		}
		 public function setupLayout(numberOfClips:Number) : void {
			var i:Number = numberOfClips;
			//clips_array.length;
			deg = Math.PI/2;
			// angular step
			step = (2*Math.PI*revolutions)/i;
			// radius step
			rstep = (radius-cradius)/i;
		};
		 public function layoutClips(clips_array:Array) :void{
			var i:Number = clips_array.length;
			while (i--) {
				var b:MovieClip = MovieClip(clips_array[i]);
				var p:Point2D = new Point2D();
				layoutClip(i, p);
				b.x = p.x;
				b.y = p.y;
			}
		};
		 public function layoutClip(i:Number, p:Point2D) :void{
			switch (layoutStructure) {
			case SQUARE_DISTRIBUTION:{
					p.x = Math.random() * m_bounds.width;
					p.y = Math.random() * m_bounds.height;
				}
				break;
			case SQUARE_DISTRIBUTIONC:{
					p.x = (Math.random() * m_bounds.width/2) + m_bounds.width/2;
					p.y =  (Math.random() * m_bounds.height/2) + m_bounds.height/2;
				}
				break;		
			case LINEAR :
				if (orientation == "horizontal") {
					p.x = m_bounds.left+(hspace*i);
					p.y = CY;
				} else if (orientation == "vertical") {
					p.y = m_bounds.top+(hspace*i);
					p.x = CX;
				}
				break;
			case CIRCULAR :
				p.x = Math.sin(deg)*radius+CX;
				p.y = Math.cos(deg)*radius+CY;
				trace(" circular "+p.x+" "+p.y);
				deg += step;
				break;
			case SPIRAL :
				p.x = Math.sin(deg)*cradius+CX;
				p.y = Math.cos(deg)*cradius+CY;
				trace(" circular "+p.x+" "+p.y);
				deg += step;
				cradius += rstep;
				break;
			}
		};
			
	}
}