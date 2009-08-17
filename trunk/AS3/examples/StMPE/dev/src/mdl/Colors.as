package mdl{

	/**
	 * @author Troy Gardner
	 */
	public class Colors {
		public var rgb : Number = 0x333333;
		public var name:String = "";
		
		public static const  lpink : Colors = new Colors(0xFF00FF, "lpink");
		public static const  mpink : Colors = new Colors(0xFFCCFF, "mpink");
		public static const  dpink : Colors = new Colors(0xF2C1F2, "dpink");		
		
		public static const  lred : Colors = new Colors(0xFF5959, "lred");
		public static const  mred : Colors = new Colors(0xD90000, "mred");
		public static const  dred : Colors = new Colors(0x990000, "dred");				

		
		public static const  lrora : Colors = new Colors(0xFFB380, "lrora");
		public static const  mrora : Colors = new Colors(0xF77C00, "mrora");
		public static const  drora : Colors = new Colors(0xBF6000, "drora");
		
		public static const  lyell : Colors = new Colors(0xFFFF00, "lyell" );
		public static const  myell : Colors = new Colors(0xF2F200, "myell");
		public static const  dyell : Colors = new Colors(0xB2B200, "dyell");

		public static const  lygre : Colors = new Colors(0xA6FF59, "lygre");
		public static const  mygre : Colors = new Colors(0x99BF00, "mygre");
		public static const  dygre : Colors = new Colors(0x668000, "dygre");

		public static const  lgreen : Colors = new Colors(0x59FF59, "lgree");
		public static const  mgreen : Colors = new Colors(0x00BF00, "mgree");
		public static const  dgreen : Colors = new Colors(0x009900, "dgree");

		public static const  lblue : Colors = new Colors(0x6666FF, "lblue");
		public static const  mblue : Colors = new Colors(0x0000F7, "mblue");
		public static const  dblue : Colors = new Colors(0x0000B2, "dblue");

		public static const  lbvio : Colors = new Colors(0xE680E6, "lbvio");
		public static const  mbvio : Colors = new Colors(0xAD00F7, "mbvio");
		public static const  dbvio : Colors = new Colors(0x8F00B2, "dbvio");

		
		public static const  white : Colors = new Colors(0xFFFFFF, "white");
		public static const  lgray : Colors = new Colors(0xD9D9D9, "lgray");
		public static const  mgray : Colors = new Colors(0x999999, "mgray");
		public static const  dgray : Colors = new Colors(0x4D4D4D, "dgray");
		public static const  black : Colors = new Colors(0x000000, "black");

		public function Colors(clr : Number = 0x333333, name:String ="") {
			this.rgb = clr;
			this.name = name;
		}

		public static function parse(shapeSizeAndName : String) : Colors {
			switch(shapeSizeAndName) {
				case "lpink":
					return lpink;
				case "mpink":
					return mpink;
				case "dpink":
					return dpink;		

				case "lred":
					return lred;
				case "mred":
					return mred;
				case "dred":
					return dred;				

				case "lrora":
					return lrora;
				case "mrora":
					return mrora;
				case "drora":
					return drora;


				case "lyell":
					return lyell;
				case "myell":
					return myell;
				case "dyell":
					return dyell;

					
				case "lygre":
					return lygre;
				case "mygre":
					return mygre;
				case "dygre":
					return dygre;
						
				case "lgree":
					return lgreen;
				case "mgree":
					return mgreen;
				case "dgree":
					return dgreen;


				case "lblue":
					return lblue;
				case "mblue":
					return mblue;
				case "dblue":
					return dblue;

				case "lbvio":
					return lbvio;
				case "mbvio":
					return mbvio;
				case "dbvio":
					return dbvio;

				case "white":
					return white;
				case "lgray":
					return lgray;
				case "mgray":
					return mgray;
				case "dgray":
					return dgray;
				case "black":
					return black;
			}
				return lgray;
		} 
	}
}
