package com.troyworks.apps.semantica.moby {
	import flash.display.Sprite;


	import com.troyworks.logging.TraceAdapter;	

	/**
	 * @author Troy Gardner
	 */
	public class Converter extends Sprite {
		private var eventSprite : Sprite;
		public static var trace : Function = TraceAdapter.getNormalTracer();	
		public var parser:MobyParser;
		public function Converter() {
			super();
			
			eventSprite = new Sprite();
			addChild(eventSprite);
			eventSprite.graphics.beginFill(0xFF0000);
			eventSprite.graphics.drawCircle(0, 0, 100);
			eventSprite.x = stage.stageWidth / 2;
			eventSprite.y = stage.stageHeight / 2;	
			trace = TraceAdapter.TraceToSOS;
			trace(TraceAdapter);
			trace("new Moby Parser Converter");
			
			parser = new MobyParser();
			parser.trace = trace;
			parser.initStateMachine();
			
			
			
		}
	}
}
