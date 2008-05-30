package com.troyworks.framework.ui {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.MovieClip;
	import com.troyworks.framework.ui.ILateBindingController;
	import flash.utils.describeType;
	public class LateBindingController extends MovieClip implements ILateBindingController
	{
		public var view:MovieClip;
		public var targets:Array;
		public var balls:Array;
		
		public function LateBindingController() {
			trace("stage " + stage);
			super();
			targets = new Array();
			balls = new Array();
		//	addEventListener(Event.ADDED,addedToView);
		}
		public function setView(aview:MovieClip):void{
			view = aview;
			trace("setView " + view + " " + view.key);
			view.addEventListener(Event.ADDED_TO_STAGE,addedToStage);
			view.addEventListener(Event.REMOVED_FROM_STAGE,removedFromStage);
			view.addEventListener(Event.ADDED,onChildAdded);
			view.addEventListener(Event.REMOVED,removedFrom);
			trace("telling parent to play");
			view.play();
			trace("telling parent to play2");
		}
		protected function addedToStage(event:Event):void {
			trace("addedToStage " + event.target);
		}
		protected function removedFromStage(event:Event):void {
			trace("removedFromStage " + event.target);
		}
		protected function onChildAdded(event:Event):void {
			trace("onChildAdded " + event.target);
			var x:XML = describeType(event.target);
			var nm:String = String( x.@name);
			trace("XX " +nm);
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
		protected function removedFrom(event:Event):void {
			trace("!!!!!!!!!!!!!removedFrom " + event.target);
		}
	/*	protected function onChildReachedTarget(event:Event):void{
			var allFinished:Boolean = true;
			for(var i:Number = 0; i < balls.length; i++){
				if(balls[i] != null){
				if(!Seeker(balls[i]).isComplete){
					allFinished = false;
					
				}
				}
			}
			if(allFinished){
				trace("finished all==========================");
				for(i = 0; i < balls.length; i++){
							if(balls[i] != null){
					balls[i].seekTarget = null;
					balls[i].unbindView();
							}
				}
				targets = new Array();
				balls = new Array();
				view.play();
			}
			
		}*/
	}
}
