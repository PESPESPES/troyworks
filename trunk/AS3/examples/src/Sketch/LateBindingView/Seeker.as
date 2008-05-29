package
{
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	
	public class Seeker extends EventDispatcher
	{
		public var target:MovieClip;
		private var view:MovieClip;
		private var vx:Number;
		private var vy:Number;
		private var easing:Number = 0.1;
		public var isComplete:Boolean = false;

		public function Seeker(ball:MovieClip)
		{
			super();
			view = ball;
		}
		public function set seekTarget(mc:MovieClip):void{
			if(mc != null){
			trace("set SeekTarget " + mc.name);
			
			target = mc;
			init();
			}else{
			 target = null;
			}

		}
		private function init():void
		{
			trace("init " + view.name);
			vx = Math.random() * 10 - 5;
			vy = Math.random() * 10 - 5;
			view.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onEnterFrame(event:Event):void
		{
			vx = (target.x - view.x) * easing;
			vy = (target.y - view.y) * easing;
			if(Math.abs(vx) < 1 && Math.abs(vy) < 1 && !isComplete){
				isComplete = true;
				var evt:Event = new Event(Event.COMPLETE);
				dispatchEvent(evt);
			}else{
				//Seek
			view.x += vx;
			view.y += vy;
			}
		}
		public function unbindView():void{
				view.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				view = null;
		}

	}
}