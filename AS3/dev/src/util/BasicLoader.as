package util { 
	/*
	* This is a light weight class to help with loading of initial swf
	*/
	import com.troyworks.events.TEventDispatcher;
	import com.troyworks.framework.BaseObject;
	
	import flash.utils.clearInterval;
	import flash.display.MovieClip;
	import flash.utils.setInterval;
	public class BasicLoader extends BaseObject
	{
		//STATES
		protected static var LOADED : Number = 1;
		protected static var NOT_STARTED : Number = 1;
		protected static var ALREADY_LOADED : Number = 1;
		//EVENTS
		public static var EVT_ALL_LOADED:String = "EVT_ALL_LOADED";
		//ClipsQue and history
		protected var clipsToLoad : Array = new Array ();
		protected var loadedClips : Array = new Array ();
		// a variable for the setinterval
		protected var intV : Number = null;
		protected var intMS : Number = 100;
		protected var c_obj:Object = null;
		protected var c_fn:Function = null;
		protected var c_args:Array = null;
		public function BasicLoader (checkFrequency : Number)
		{
			//super ();
			trace ("new Basic Loader");
			//TEventDTEventDTEventDispatchertMS = (checkFrequency == null) ? this.intMS : checkFrequency;
		}
		public function load (swfPath : String, toPath : Object) : void
		{
			trace ("util.BasicLoader.load " + swfPath + " to " + toPath);
			if (toPath == null)
			{
				throw new Error ("util.BasicLoader.load toPath Cannot be null");
			}
			if (swfPath.indexOf (".swf") > - 1)
			{
				//load a swf
				var t = MovieClip (toPath);
				loadMovie (swfPath, t );
				//loadMovieNum(swfPath, t);
				trace ("starting load of " + swfPath + " to " + t);
				var o = new Object ();
				o.path = swfPath;
				o.target = t;
				this.clipsToLoad.push (o);
			}
			if (intV != null)
			{
				trace ("already started basic loader");
			} else
			{
				trace ("starting load chk:" + this.intMS);
				this.intV = setInterval (this, "checkProgress", 100);
				//this.intMS);
				trace ("interval " + this.intV);
			}
		}
		public function checkProgress (clipPath : String) : void
		{
			trace ("checkingProgress " + SWFUtilBasic);
			var all : Boolean = true;
			for (var i in this.clipsToLoad)
			{
				var o = this.clipsToLoad [i];
				var prog = SWFUtilBasic.getLoadingProgress (o.target);
				trace ("   progress " + o.path + " " + o.target + " = " + prog);
				if (prog != 1)
				{
					all = false;
				}
			}
			if (all)
			{
				onAllLoaded ();
			}
		}
		public function setCallback(scope:Object, func:Function, args:Array):void{
			this.c_obj = scope;
			this.c_fn = func;
			this.c_args = args;
		}
		public function onAllLoaded () : void {
			trace ("all clips loaded");
			clearInterval (this.intV);
	//		var eventObj = new Object ();
	//		eventObj.type = EVT_ALL_LOADED;
	//		eventObj.target = this;
	//		this.dispatchEvent (eventObj);
			this.c_fn.apply(this.c_obj, this.c_args);
		}
	}
	
}