package com.troyworks.ui {
	import flash.geom.Point; 
	import flash.geom.Rectangle;
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;

	public class LayoutHelper {

		protected var layoutStructure : String;

		protected var m_bounds : Rectangle;

		protected var cradius : Number;

		protected var wradius : Number;
		protected var hradius : Number;

		
		protected var wspace : Number;
		protected var vspace : Number;
		protected var revolutions : Number;

		protected var orientation : String;

		public var deg : Number;

		protected var step : Number;

		protected var rstep : Number;

		protected var CX : Number;

		protected var CY : Number;
		private var tmpX : Number;
		private var tmpY : Number;
		private var tmpI : Number;
		private var tmpJ : Number;
		private var tmpI_MAX : Number;
		private var tmpJ_MAX : Number;
		//GRID, HEX, RADIAL, SPIRAL 
		public static var LINEAR : String = "LINEAR";
		public static var GRID : String = "GRID";
		public static var HONEYCOMB : String = "HONEYCOMB";	
		public static var CIRCULAR : String = "CIRCULAR";
		public static var ELLIPTICAL : String = "ELLIPTICAL";
		public static var SPIRAL : String = "SPIRAL";
		/* equally distributed across the bounding square */
		public static var SQUARE_DISTRIBUTION : String = "SQUARE_DISTRIBUTION";
		/* more focused aroudn the center */
		public static var SQUARE_DISTRIBUTIONC : String = "SQUARE_DISTRIBUTIONC";
		/* equally distributed across the bounding square */
		public static var CIRCULAR_DISTRIBUTION : String = "CIRCULAR_DISTRIBUTION";

		
		public function	LayoutHelper(type : String, boundary : Rectangle) {
			layoutStructure = (type == null) ? SQUARE_DISTRIBUTIONC : type ;
			bounds = boundary;
			cradius = 300;
			
			// in linear mode the gap between clips
			wspace = 10;
			// in spiral mode how many times to loop around
			revolutions = 1;
			orientation = "horizontal";
		};

		public function set bounds(b : Rectangle) : void {
			m_bounds = b;
			CX = m_bounds.x + m_bounds.width / 2;
			CY = m_bounds.y + m_bounds.height / 2;
			tmpX = m_bounds.x;
			tmpY = m_bounds.y;
		
			// in circular the radius things are placed on, in spiral the inital radius
		}

		public function setupLayout(numberOfClips : Number) : void {
			//clips_array.length;
			deg = Math.PI / 2;
			// angular step
			step = (2 * Math.PI * revolutions) / numberOfClips;
			
			tmpI = 0;
			tmpJ = 0;
			var nu : Number = Math.sqrt(numberOfClips);
			
			tmpI_MAX = Math.ceil(nu);
			tmpJ_MAX = Math.floor(nu);
			wspace = m_bounds.width / tmpI_MAX;
			vspace = m_bounds.height / tmpJ_MAX;
			
			switch (layoutStructure) {
				case ELLIPTICAL :
					wradius = (m_bounds.width * .8) / 2;
					hradius = (m_bounds.height * .8) / 2;
					break;
				
				case CIRCULAR :
					hradius = wradius = (Math.min(m_bounds.width ,m_bounds.height) * .8) / 2;
					break;
				case SPIRAL :
					hradius = (m_bounds.height * .9) / 2;
					cradius = (m_bounds.width * .3)/2;
					// radius step
					rstep = (hradius - cradius) / numberOfClips;
					break;
			}
	
		//	trace("GRID W " + nu, wspace, vspace);
		};

		public function layoutClips(clips_array : Array) : void {
			var i : Number = clips_array.length;
			while (i--) {
				var b : MovieClip = MovieClip(clips_array[i]);
				var p : Point = new Point();
				layoutClip(i, p);
				b.x = p.x;
				b.y = p.y;
			}
		};

		public function layoutClip(i : Number, p : Point) : void {
			switch (layoutStructure) {
				case SQUARE_DISTRIBUTION:
					//trace("m_bounds.width", m_bounds.width);
					p.x = Math.random() * m_bounds.width;
					p.y = Math.random() * m_bounds.height;
					break;
				case SQUARE_DISTRIBUTIONC:
					p.x = (Math.random() * m_bounds.width / 2) + m_bounds.width / 2;
					p.y = (Math.random() * m_bounds.height / 2) + m_bounds.height / 2;
					break;		
				case LINEAR :
					if (orientation == "horizontal") {
						p.x = m_bounds.left + (wspace * i);
						p.y = CY;
					} else if (orientation == "vertical") {
						p.y = m_bounds.top + (wspace * i);
						p.x = CX;
					}
					break;
				case GRID :
					tmpX = m_bounds.left + (wspace * tmpI++);
					
					p.x = tmpX;
					p.y = tmpY;	
					if(tmpI == tmpI_MAX) {
						//reset row
						tmpI = 0;
						tmpY = m_bounds.top + (vspace * ++tmpJ);
					}
					
					break;	
				case ELLIPTICAL :
				case CIRCULAR :
					p.x = Math.sin(deg) * wradius + CX;
					p.y = Math.cos(deg) * hradius + CY;
				//	trace(" circular " + p.x + " " + p.y);
					deg += step;
					break;
				case SPIRAL :
					p.x = Math.sin(deg) * cradius + CX;
					p.y = Math.cos(deg) * cradius + CY;
				//	trace(" SPIRAL " + p.x + " " + p.y);
					deg += step;
					cradius += rstep;
					break;
			}
		};
	}
}