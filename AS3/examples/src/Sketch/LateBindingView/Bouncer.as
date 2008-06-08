package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public dynamic class Bouncer extends MovieClip
	{
		public var view:MovieClip;
		private var vx:Number;
		private var vy:Number;
		
		public function Bouncer(ball:MovieClip)
		{
			super();
			trace("new Bouncer");
			view = ball;
		//	this.txt.text = "!!!";
			init();
		}
		
		private function init():void
		{
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.align=StageAlign.TOP_LEFT;

			vx = Math.random() * 10 - 5;
			vy = Math.random() * 10 - 5;
	//		view.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
	if(view != null){
			view.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			view.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
	}else {
		addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
	}

		}
		protected function onRollOverHandler(event:Event):void{
			trace("onRollOverHandler");
			if(view == null){
				alpha = .5;
			}else{
				view.alpha = .5;
			}
		}
		protected function onRollOutHandler(event:Event):void{
			trace("onRollOutHandler");
			if(view == null){
				this.alpha = 1;
			}else{
				view.alpha = 1;
			}
		}

		private function onEnterFrameHandler(event:Event):void
		{
			view.x += vx;
			view.y += vy;
			var left:Number = 0;
			var right:Number = view.stage.stageWidth;
			var top:Number = 0;
			var bottom:Number =view.stage.stageHeight;
			
			if(view.x + view.width > right)
			{
				view.x = right - view.radius;
				vx *= -1;
			}
			else if(view.x < left)
			{
				view.x = left + view.radius;
				vx *= -1;
			}
			if(view.y + view.height > bottom)
			{
				view.y = bottom - view.radius;
				vy *= -1;
			}
			else if(view.y - view.height < top)
			{
				view.y = top + view.radius;
				vy *= -1;
			}
		}
	}
}
