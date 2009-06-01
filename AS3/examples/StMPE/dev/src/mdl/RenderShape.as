package mdl {
	import flash.display.Sprite;	

	/**
	 * @author Troy Gardner
	 */
	public class RenderShape {
		public static const S_CIRCLE : RenderShape = new RenderShape(.8, "S_CIRCLE", "scir");
		public static const M_CIRCLE : RenderShape = new RenderShape(1, "M_CIRCLE", "mcir");
		public static const L_CIRCLE : RenderShape = new RenderShape(1.2, "L_CIRCLE", "bcir");

		public static const S_SQUARE : RenderShape = new RenderShape(.8, "S_SQUARE", "ssqu");
		public static const M_SQUARE : RenderShape = new RenderShape(1, "M_SQUARE", "msqu");
		public static const L_SQUARE : RenderShape = new RenderShape(1.2, "L_SQUARE", "bsqu");

		public static const S_DIAMOND : RenderShape = new RenderShape(.8, "S_DIAMOND", "sdia");
		public static const M_DIAMOND : RenderShape = new RenderShape(1, "M_DIAMOND", "mdia");
		public static const L_DIAMOND : RenderShape = new RenderShape(1.2, "L_DIAMOND", "bdia");

		public static const S_TRIANGLE_UP : RenderShape = new RenderShape(.8, "S_TRIANGLE_UP", "stri");
		public static const M_TRIANGLE_UP : RenderShape = new RenderShape(1, "M_TRIANGLE_UP", "mtri");
		public static const L_TRIANGLE_UP : RenderShape = new RenderShape(1.2, "L_TRIANGLE_UP", "btri");

		public static const S_TRIANGLE_DOWN : RenderShape = new RenderShape(.8, "S_TRIANGLE_DOWN", "stri");
		public static const M_TRIANGLE_DOWN : RenderShape = new RenderShape(1, "M_TRIANGLE_DOWN", "mtri");
		public static const L_TRIANGLE_DOWN : RenderShape = new RenderShape(1.2, "L_TRIANGLE_DOWN", "btri");

		
		
		
		public var shape : String = "M_DIAMOND";
		//	var color : Number = 0xdddddd;
		//	var canvas : Sprite;
		var size : Number = 17;
		var radius : Number;
		var scale : Number;
		public var xmlName : String;

		public function RenderShape( scale : Number = 1, shape : String = null, parseNam : String = null) {
			this.scale = scale;
			this.shape = shape;
			this.xmlName = parseNam;
		}

		//	public function setView(view:Sprite):void{
		//				canvas = view;
		//	}
		public static function parse(shapeSizeAndName : String) : RenderShape {
			//	trace("parse " + shapeSizeAndName);
			switch(shapeSizeAndName) {
				case "scir":
					return S_CIRCLE; 
				case "mcir":
					return M_CIRCLE; 
				case "bcir":
					return L_CIRCLE;
					 
				case "ssqu":
					return S_SQUARE; 
				case "msqu":
					return M_SQUARE; 
				case "bsqu":
					return L_SQUARE;
					
				case "sdia":
					return S_DIAMOND; 
				case "mdia":
					return M_DIAMOND; 
				case "bdia":
					return L_DIAMOND;
					
				case "stri":
					return S_TRIANGLE_DOWN; 
				case "mtri":
					return M_TRIANGLE_DOWN; 
				case "btri":
					return L_TRIANGLE_DOWN; 

				case "sutr":
					return S_TRIANGLE_UP; 
				case "mutr":
					return M_TRIANGLE_UP; 
				case "butr":
					return L_TRIANGLE_UP; 
			}
			return M_CIRCLE; 
		}

		public function draw(canvas : Sprite, color : Number) : void {
			radius = size / 2;	
			canvas.graphics.lineStyle(0, 0x666666, 1, false);
			canvas.graphics.beginFill(color);
			var x : Number;
			
			var y : Number;
			var  st : Number;
			var stp : Number;
			
			//trace("draw shape " + shape);
			switch(shape) {
				case "S_TRIANGLE_DOWN":
				case "M_TRIANGLE_DOWN":
				case "L_TRIANGLE_DOWN":
					//	trace("draw utriangle ");
					//top
					st = -Math.PI / 2;
					stp = Math.PI * 2 / 3;
					//top
					x = Math.cos(0 + st) * radius * scale;
					y = Math.sin(0 + st) * radius * scale;
					canvas.graphics.moveTo(x, y); 
					//bottom
					x = Math.cos(st - stp) * radius * scale;
					y = Math.sin(st - stp) * radius * scale;
					canvas.graphics.lineTo(x, y); 

					//top
					x = Math.cos(st + stp) * radius * scale;
					y = Math.sin(st + stp) * radius * scale;
					canvas.graphics.lineTo(x, y);
					//top
					x = Math.cos(st) * radius * scale;
					y = Math.sin(st) * radius * scale;
					canvas.graphics.lineTo(x, y);
					
					break;
				case "S_TRIANGLE_UP":
				case "M_TRIANGLE_UP":
				case "L_TRIANGLE_UP":
			
					//trace("draw dtriangle ");
				
					//top
					st = Math.PI / 2;
					stp = Math.PI * 2 / 3;
					//top
					x = Math.cos(0 + st) * radius * scale;
					y = Math.sin(0 + st) * radius * scale;
					canvas.graphics.moveTo(x, y); 
					//bottom
					x = Math.cos(st - stp) * radius * scale;
					y = Math.sin(st - stp) * radius * scale;
					canvas.graphics.lineTo(x, y); 

					//top
					x = Math.cos(st + stp) * radius * scale;
					y = Math.sin(st + stp) * radius * scale;
					canvas.graphics.lineTo(x, y);
					//top
					x = Math.cos(st) * radius * scale;
					y = Math.sin(st) * radius * scale;
					canvas.graphics.lineTo(x, y);
					
					break;
				case "S_CIRCLE":
				case "M_CIRCLE":
				case "L_CIRCLE":
					//top
					//trace("draw circle ");

					canvas.graphics.drawCircle(0, 0, radius * scale); 
					break;
				case "S_DIAMOND":
				case "M_DIAMOND":
				case "L_DIAMOND":
					//trace("draw diamond ");
				
					//top
					canvas.graphics.moveTo(0, -radius * scale); 
					//right
					canvas.graphics.lineTo(radius * scale, 0);
					//bottom
					canvas.graphics.lineTo(0, radius * scale);
					//left
					canvas.graphics.lineTo(-radius * scale, 0);
					//top
					canvas.graphics.lineTo(0, -radius * scale);
					break;
				case "S_SQUARE":
				case "M_SQUARE":
				case "L_SQUARE":
					//	trace("draw square ");

					var  qp : Number = Math.PI / 4;
					//top
					x = Math.cos(0 + qp) * radius * scale;
					y = Math.sin(0 + qp) * radius * scale;
					canvas.graphics.moveTo(x, y); 
					//bottom
					x = Math.cos(Math.PI / 2 + qp) * radius * scale;
					y = Math.sin(Math.PI / 2 + qp) * radius * scale;
					canvas.graphics.lineTo(x, y); 
					//left
					x = Math.cos(Math.PI + qp) * radius * scale;
					y = Math.sin(Math.PI + qp) * radius * scale;
					canvas.graphics.lineTo(x, y); 
					//top
					x = Math.cos(Math.PI * 1.5 + qp) * radius * scale;
					y = Math.sin(Math.PI * 1.5 + qp) * radius * scale;
					canvas.graphics.lineTo(x, y);
					//right
					x = Math.cos(0 + qp) * radius * scale;
					y = Math.sin(0 + qp) * radius * scale;
					canvas.graphics.lineTo(x, y); 
					 
					break;
			}
			canvas.graphics.endFill();
		}
	}
}
