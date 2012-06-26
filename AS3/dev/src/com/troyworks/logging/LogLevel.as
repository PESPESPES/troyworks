package com.troyworks.logging { 

	
	/**
	* These are a collection of LogLevels for primarily SOS's consumption, ability to highlight lines
	* 
	 * @author Troy Gardner
	 */
	public class LogLevel extends Object {
	
		public var color:Number;
		public var name:String;
		public var isEnabledForOutput:Boolean = true;
		
		//////////////////////////////////////////
		public static const FATAL : LogLevel = new LogLevel(0xdd0000,"FATAL");
		public static const SEVERE : LogLevel = new LogLevel(0xee0000,"SEVERE");
		public static const ERROR : LogLevel = new LogLevel(0xcc0000,"ERROR");
		public static const FLASH_ERROR : LogLevel = new LogLevel(0xdd0000,"FlashError");
		public static const WARNING : LogLevel = new LogLevel(0xFFcc00,"WARNING");
		public static const INFO : LogLevel = new LogLevel(0xffcccc,"INFO");
		public static const LOG : LogLevel = new LogLevel(0xffffff,"LOG");
		public static const DEBUG : LogLevel = new LogLevel(0xccffff,"DEBUG");
		public static const CONFIG : LogLevel = new LogLevel(0xccffff,"CONFIG");
		public static const SYSTEM : LogLevel = new LogLevel(0xffffff,"SYSTEM");
		public static const TEMP : LogLevel = new LogLevel(0xccfF00,"TEMP");
	
		public static const START : LogLevel = new LogLevel(0x63CF00,"START");
		public static const END : LogLevel = new LogLevel(0xCC6666,"END");
	
		public static const HILIGHT_YELLOW : LogLevel = new LogLevel(0xF7EB7B,"HILIGHT_YELLOW");
		public static const HILIGHT_ORANGE : LogLevel = new LogLevel(0xFFD7A5,"HILIGHT_ORANGE");
		public static const HILIGHT_GRAPE : LogLevel = new LogLevel(0xC671A5,"HILIGHT_GRAPE");
		public static const HILIGHT_SKYBLUE : LogLevel = new LogLevel(0x9CD7F7,"HILIGHT_SKYBLUE");
		public static const HILIGHT_PURPLE : LogLevel = new LogLevel(0xC6BAF7,"HILIGHT_PURPLE");
		public static const HILIGHT_LEMON : LogLevel = new LogLevel(0xFFF3B5,"HILIGHT_LEMON");
		public static const HILIGHT_LIME : LogLevel = new LogLevel(0xCCFF99,"HILIGHT_LIME");
		public static const HILIGHT_TURQUOISE : LogLevel = new LogLevel(0x73C3CE,"HILIGHT_TURQUOISE");
		
		public static const HILIGHT_GRAY0 : LogLevel = new LogLevel(0xF0F0F0,"HILIGHT_GRAY0");
		public static const HILIGHT_GRAY1 : LogLevel = new LogLevel(0xE1E1E1,"HILIGHT_GRAY1");
		public static const HILIGHT_GRAY2 : LogLevel = new LogLevel(0xD6D6D6,"HILIGHT_GRAY2");
		public static const HILIGHT_GRAY3 : LogLevel = new LogLevel(0xAEAEAE,"HILIGHT_GRAY3");
		public static const HILIGHT_GRAY4 : LogLevel = new LogLevel(0x9B9B9B,"HILIGHT_GRAY4");
		
		public function LogLevel(ConsoleColorVal : Number = 0x000000, logLevelName : String="DefaultLogLevel") {
			color = ConsoleColorVal;
			name = logLevelName;
		}
		public function toString():String{
			return "LogLevel " + name + " " + color;
		}
	
	}
}