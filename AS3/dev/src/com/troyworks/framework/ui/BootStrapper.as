package com.troyworks.framework.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import com.troyworks.framework.ui.UIFsmComponent;
	import flash.events.Event;
	import flash.utils.describeType;
	/******************************************
	 * This class is called by entry point swf
	 * and passed configuration parameters (typically on frame1)
	 * and this, takes care of all the rest
	 * 
	 * One of it's primary responsibilities are watching
	 * the stage for additions and removals
	 * and late/runtime binding them to various scripts in it's library
	 * this is similar to Object.registerClass in As2.0 and
	 * provides a very loose coupling between UI and Engine
	 * 
	 * there is only one bootstrapper for a given application

	 * 
	 * ***************************************/
	public class BootStrapper extends UIFsmComponent
	{
		public var view:MovieClip;
		public function BootStrapper():void{
			super();
			//_initState
		}
		public function setView(view_mc:MovieClip):void{
			trace("BootStrapper.setView " + view_mc);
			view  = view_mc;
			view.addEventListener(Event.ADDED,onChildAdded);
			view.addEventListener(Event.REMOVED,onChildRemoved);
			
			//onSetView();
			scanStage();
		}
		protected function scanStage():void {
		trace("BootStrapper.scanStage=======================================");
			//cellIdx = new Object();
	
			var description:XML = describeType(view);
			//trace("description " + description);
			var _mc:MovieClip;
			var _txt:TextField;
			var nm:String;
			for each (var v:XML in description..variable) {
				var str:String = v.@name;
				trace(" FOUND " + v.toXMLString() + " " + str);
				try {
					switch (String(v.@type)) {
						case "flash.display::MovieClip" :
							_mc = MovieClip(this[str]);
							if (_mc.name == "outline_mc") {
								
							}
					}
				}catch(err:Error){
				
				}
			}
		}
		/**************************************************
		 *  this is called anytime a UI clip is added to the stage
		 * **********************************************/
		protected function onChildAdded(event:Event):void {
			
			var x:XML = describeType(event.target);
			var nm:String = String( x.@name);
			trace("BootStrapper.onChildAdded " + event.target + " " + nm);
			var ary:Array;
			var id:Number;
			switch(nm){
				case "flash.display::Shape":
				case "flash.text::StaticText":
				//ignore
				break;
/*				case "Ball":
				trace("found a Ball " + MovieClip(event.target).name);
				ary = MovieClip(event.target).name.split("_");
				id = parseInt(ary[1]);
				var bl:Seeker = new Seeker(MovieClip(event.target));
				bl.addEventListener(Event.COMPLETE, onChildReachedTarget);
				balls[id] = bl;
				if(targets[id] != null){
					bl.seekTarget = targets[id].view;
				}
				break;	
				case "Target":
				trace("found a Target " + MovieClip(event.target).name);
				var t:Bouncer = new Bouncer(MovieClip(event.target));
					ary = MovieClip(event.target).name.split("_");
				id = parseInt(ary[1]);
				targets[id] = t;
				if(balls[id] != null){
					balls[id].seekTarget = t.view;
				}
				break;*/
				default:
				trace("found unknown");
				break;

			}
		}
		/**************************************************
		 *  this is called anytime a UI clip is removed from the stage
		 * **********************************************/
		
		protected function onChildRemoved(event:Event):void {
			trace("!!!!!!!!!!!!!onChildRemoved " + event.target);
		}
	}
}