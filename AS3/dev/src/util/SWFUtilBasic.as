package util { 
	 /*
	* This is a light weight class to help with loading of initial swf that have more than 1 frame
	*
	*/
	import flash.display.MovieClip;
	import flash.system.System;
	public class SWFUtilBasic
	{
		public static function isFullyLoaded (clip : Object) : Boolean
		{
			return (SWFUtilBasic.getLoadingProgress (clip) >= 1) ? true : false;
		}
		public static function hasStartedLoading (clip : Object) : Boolean
		{
			return (SWFUtilBasic.getLoadingProgress (clip) > - 1) ? true : false;
		}
		/*
		* returns null if the clip doesn't exist.
		* returns -1 if the clip hasn't started loaded
		* or 0-100 for the percentage loaded
		*/
		public static function getLoadingProgress (clip : Object) : Number
		{
			trace ("getLoadingProgress1 " + clip);
			var _mc = null;
			if (clip is MovieClip)
			{
				trace ("clip type MovieClip");
				_mc = clip;
			} else if (typeof (clip) == "string")
			{
				trace ("clip type string");
				_mc = eval (String (clip));
			}
			if (_mc == null)
			{
				throw new Error ("invalid loading clip to get progress for");
				return null;
			}
			var tf = _mc.totalFrames;
			var r = null;
			trace ("total frames " + tf + " " + _mc.framesLoaded + " cf " +_mc.currentFrame);
			if (tf != null && tf > 0 && (_mc.getBytesLoaded () == _mc.getBytesTotal ()) && _mc.currentFrame > 0)
			{
				r = _mc.framesLoaded / tf;
			} else
			{
				r = - 1;
			}
			trace ("getLoadingProgress2 " + clip + " = " + r);
			return r;
		}
		public static function flipH(_mc:MovieClip):void{
			_mc.scaleX *= -1;
			_mc.x += _mc.width;
		}
		public static function flipV(_mc:MovieClip):void{
			_mc.scaleY *= -1;
			_mc.y += _mc.height;
		}
		
		public static function inBrowser () : Boolean
		{
			var s = System.capabilities.playerType;
			return (s == "PlugIn" || s == "ActiveX") ?true : false;
		}
	}
	
}