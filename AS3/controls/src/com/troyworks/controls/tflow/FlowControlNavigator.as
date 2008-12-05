package com.troyworks.controls.tflow {
	import com.troyworks.core.tweeny.Tny;	
	
	import flash.utils.Dictionary;	
	
	import com.troyworks.events.EventWithArgs;	
	
	import flash.text.TextFieldAutoSize;	
	
	import com.troyworks.controls.tslidermenu.TSliderMenu;	
	
	import flash.text.TextField;	
	import flash.display.Sprite;	
	import flash.display.MovieClip;

	/**
	 * FlowControlNavigator
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: May 7, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class FlowControlNavigator extends Sprite {
		import flash.events.*;
		import flash.text.TextFieldType;

		private var init : Boolean;
		private var lastFrameNumber : Number;
		private var activeFrames : Object;
		//private var scope:MovieClip;
		public var model:MovieClip; 
		public var slider:TSliderMenu;
		public var config:Object = new Object();	
		public var normalStyle:TextField;
		public var dIdx:Dictionary = new Dictionary();
		public var tny : Tny;
		public var lastMenuOut:Boolean = false;
		private var cursor : Sprite;
		private var space : Number;
		public var curMenuOut:Boolean = false;
		public function FlowControlNavigator(model:MovieClip, style:TextField){
			super();
			trace("FlowControlNavigator, using " + model + " as source");
			this.model = model;
			this.normalStyle = style;
			this.normalStyle.visible = false;
			if(this.model.stage != null){
				createChildren();
			}
		}

		function onAddedToStage():void{
	
		}
		public function createChildren():void{
			if (!init) {
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			activeFrames = new Object();
			var labelDepth : Number = 0;
			trace("Inventorying FrameLabels----------------------");
			space = (model.width * 10);// 100);
			var slidingTraySize:Sprite = new Sprite();
			slidingTraySize.buttonMode = true;
			slidingTraySize.name = "sliderTraySize";
			slidingTraySize.graphics.beginFill(0xCCCCCC, .2);
		
			var pad:Number = 10;
			slidingTraySize.graphics.drawRect(0, 0, model.width - ( 2*pad), 10);
			slidingTraySize.x = pad;
			slidingTraySize.addEventListener(MouseEvent.CLICK, onPercentageClick);	
			
			addChild(slidingTraySize);
			cursor = new Sprite();
			cursor.graphics.beginFill(0xFFCC00, .8);
			cursor.graphics.drawRoundRect(0,0, 20, 20, 5, 5);
			cursor.name = "cursor";
			addChild(cursor);
			for (var i : int = 0;i < model.currentLabels.length; i++) {
				trace(i + " " + model.currentLabels[i].name + " " + model.currentLabels[i].frame);
				if (lastFrameNumber == model.currentLabels[i].frame) {
					labelDepth++;
				} else {
					labelDepth = 0;
					lastFrameNumber = model.currentLabels[i].frame;
				}

				activeFrames[model.currentLabels[i].name] = false;
				//////// CREATE DEBUGGING VISUALIZER //////////
				var sp : Sprite = new Sprite();
				sp.name = model.currentLabels[i].name + "_mc";
				sp.graphics.beginFill(0xCCCCCC, .3);
				
				var txt : TextField = new TextField();
				txt.name = "txt";
				txt.defaultTextFormat = normalStyle.defaultTextFormat;
				txt.antiAliasType = normalStyle.antiAliasType;
				txt.embedFonts = normalStyle.embedFonts;
				txt.filters = normalStyle.filters;
				
				txt.autoSize = TextFieldAutoSize.LEFT;
				txt.text = model.currentLabels[i].name;
				txt.type = TextFieldType.DYNAMIC;
				txt.selectable = false;
				txt.mouseEnabled = false;
				sp.addChild(txt);
				sp.graphics.drawRoundRect(txt.x, txt.y, txt.width, txt.height, 5, 5);
				//txt.embedFonts = true;
				sp.alpha = .6;
				sp.x = space * (model.currentLabels[i].frame -1)/model.totalFrames;
				sp.y = labelDepth * 20;
				sp.buttonMode = true;
				sp.addEventListener(MouseEvent.CLICK, onFrameRequest);
				addChild(sp);
				dIdx[sp.name] = sp;
			}
		
			var ini:Object = new Object();
			ini.hideTraySize = false;
			ini.drawSlider = true;
			ini.drawSliderColor = 0xcccccc;
			ini.drawSliderAlpha = .7; 
			slider = new TSliderMenu(this, ini);
			init = true;
			//already on frame so call.
			onEnterFrameHandler(null);
			
		}
		}
		function onPercentageClick(event:MouseEvent):void{
			
			var f:Number = Math.round(event.target.mouseX/ model.width * model.totalFrames);
			trace("onPercentage " + event.target.mouseX +"/" + model.width + "== " + f);
			var evta : EventWithArgs = new EventWithArgs("gotoAndStop");
			evta.args = [f];
			model.dispatchEvent(evta);
		}
		function onFrameRequest(event : Event) : void {
			trace("onFrameRequest !!!! " + event.target.name + " !!!!!!!!!!");
			var a : Number = event.target.name.indexOf("_mc");
			var nm : String = event.target.name.substring(0, a);
			var evta : EventWithArgs = new EventWithArgs("gotoAndStop");
			evta.args = [nm];
			model.dispatchEvent(evta);
	//		model.gotoAndStop();
		}
		function onTnyChanged():void{
			if(tny!= null){
			if(mouseY < 60){
				tny.y = 0;
				tny.alpha = 1;
				tny.duration = 1;
			}else{
				tny.y = -50;
				tny.alpha = 0;
				tny.duration = 1;
			}
			}
			lastMenuOut = curMenuOut;
			
		}
		function onEnterFrameHandler(event : Event) : void {
			if(stage != null && tny == null){
				tny = new Tny(this);
			}
			if(mouseY < 60) {
				curMenuOut = true;
			}else{
				curMenuOut = false;
			}
			if(curMenuOut != lastMenuOut){
				onTnyChanged();
			}
			
			
			if (lastFrameNumber != model.currentFrame) {
				/////////////// FRAME HAS CHANGED (not just rerendered) ///////////////////
				var sp : Sprite;
				var nm : String;
				var txt:TextField;
				var hit:Boolean = false;
				for (var i : int = 0;i < model.currentLabels.length; i++) {
					//////////////////// ACTIVE //////////////////////////////////////
					if (model.currentLabels[i].name != " " && model.currentLabels[i].frame == model.currentFrame && activeFrames[model.currentLabels[i].name] != true) {
						nm = model.currentLabels[i].name + "_mc";
						activeFrames[model.currentLabels[i].name] = true;
						sp = Sprite(dIdx[nm] as Sprite);//getChildByName(nm));
						trace("activating " + nm + " " + sp);
						sp.graphics.clear();
						 txt = sp.getChildByName("txt")as TextField;
						sp.graphics.beginFill(0xFFCC00, 1);
						sp.graphics.drawRoundRect(txt.x, txt.y, txt.width, txt.height, 5, 5);
						sp.graphics.endFill();
						sp.alpha = 1;
						hit = true;
				//sp.visible = true;
					} else if ( activeFrames[model.currentLabels[i].name] == true && model.currentLabels[i].name != model.currentLabel) {
					//////////////////// INACTIVE //////////////////////////////////////
						nm = model.currentLabels[i].name + "_mc";

						activeFrames[model.currentLabels[i].name] = false;
						sp = Sprite(dIdx[nm] as Sprite);//getChildByname
						trace("deactivating " + nm + " " + sp);
						sp.graphics.clear();
						txt = sp.getChildByName("txt")as TextField;
						sp.graphics.beginFill(0xCCCCCC, .3);
						sp.graphics.drawRoundRect(txt.x, txt.y, txt.width, txt.height, 5, 5);
						sp.graphics.endFill();
						hit = true;
						sp.alpha = .6;
					}//sp.visible = false;
					
						cursor.visible = true;
						cursor.x = space * (model.currentFrame -1)/model.totalFrames;
						
					
				}
				lastFrameNumber = model.currentFrame;
			}
		}
	}
}
