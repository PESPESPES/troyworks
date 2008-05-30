/**
* A utility for determining where the swf is running,
* to help with appropriate behavior. Noteably, using inFlashIDE for QA and Debugging mode
* and in AIR to determine to load/save using the AIR api's.
* 
* @author Troy Gardner
* @version 0.1
*/

package com.troyworks.util {
	import flash.system.Capabilities;
	public class FlashPlayerUtil {
		
		public static function get inFlashIDE():Boolean{
			return Capabilities.playerType == "External";
		}
		public static function get inAIR():Boolean{
			return Capabilities.playerType == "Desktop";
		}
		public static function get inProjector():Boolean{
			return Capabilities.playerType == "StandAlone";
		}
		public static function get inBrowser():Boolean{
			return Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX";
		}

		
	}
	
}
