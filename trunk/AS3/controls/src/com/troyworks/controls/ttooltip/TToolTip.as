package com.troyworks.controls.ttooltip {	
	import flash.utils.setTimeout;
 
		
	/**
	 * Non-Singleton Tool Tip class AS3 Style
	 * based on  http://www.kirupa.com/forum/archive/index.php/t-265894.html
	 * @author Devon O. Wolfgang
	 * @author Troy Gardner
	 */
	import flash.filters.BevelFilter;	
	import flash.events.Event;	
	import flash.geom.Rectangle;	
	import flash.text.Font;	
	import flash.text.TextFieldAutoSize;	
	import flash.display.DisplayObjectContainer;	
	import flash.filters.DropShadowFilter;	
	import flash.text.TextFormat;	
	import flash.text.AntiAliasType;	
	import flash.display.Sprite;	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.DisplayObject;	

	public class TToolTip extends Sprite {

		public static const ROUND_TIP : String = "roundTip";
		public static const SQUARE_TIP : String = "squareTip";

		
		private var _label : String = "";

		public var background_mc : MovieClip;
		public var label_txt : TextField;

		
		private var _adv : Boolean;
		private var _tipColor : uint;
		private var _tipAlpha : Number;
		private var _format : TextFormat;
		private var _ds : DropShadowFilter;
		private var _root : DisplayObjectContainer;
		private var _userTip : String;
		private var _orgX : int;
		private var _orgY : int;

		public static var IDZ : int = 0;
		private var scope : DisplayObjectContainer;
		private var target : DisplayObject;

		private var _bf : BevelFilter;

		public function TToolTip( myRoot : DisplayObjectContainer, font : Font = null, tipColor : uint = 0xFFFFFF, tipAlpha : Number = 1, tipShape : String = "roundTip", fontColor : uint = 0x000000, fontSize : int = 11, advRendering : Boolean = true) {
			super();
			_root = myRoot;
			name = "TToolTip" + IDZ++;
			setStyle(font, tipColor, tipAlpha, tipShape, fontColor, fontSize, advRendering);
			this.mouseEnabled = false;
		}

		public function set label(word : String) : void {
			_label = word;
			createChildren();
		}

		public function setStyle( font : Font = null, tipColor : uint = 0xFFFFFF, tipAlpha : Number = 1, tipShape : String = "roundTip", fontColor : uint = 0x000000, fontSize : int = 11, advRendering : Boolean = true) : void {
			_tipColor = tipColor;
			_tipAlpha = tipAlpha;
			_userTip = tipShape;
			_adv = advRendering;
			if(font == null) {
				_format = new TextFormat("arial", fontSize, fontColor);
			} else {
				_format = new TextFormat(font.fontName, fontSize, fontColor);
			}
			//_bf = new BevelFilter(.5,45,0xFFFFFF,.8,0,.8,0, 0);
			_ds = new DropShadowFilter(3, 45, 0x000000, .7, 2, 2, 1, 3);
		}		

		public function createChildren() : void {
			
			if(label_txt == null) {
				label_txt = new TextField();
			}
			label_txt.mouseEnabled = false;
			label_txt.selectable = false;
			label_txt.defaultTextFormat = _format;
			//	label_txt.antiAliasType = _adv ? AntiAliasType.ADVANCED : AntiAliasType.NORMAL;
			label_txt.width = 1;
			label_txt.height = 1;
			label_txt.autoSize = TextFieldAutoSize.LEFT;
			//	label_txt.embedFonts = true;
			label_txt.multiline = true;
			label_txt.htmlText = _label;

			var w : Number = label_txt.textWidth;
			var h : Number = label_txt.textHeight;

			var tipShape : Array;

			switch (_userTip) {
				case ROUND_TIP :
					tipShape = [[0, -13.42], [0, -2], [10.52, -15.7], [13.02, -18.01, 13.02, -22.65], [13.02, -16 - h], [13.23, -25.23 - h, 3.1, -25.23 - h], [-w , -25.23 - h], [-w - 7, -25.23 - h, -w - 7, -16 - h], [-w - 7, -22.65], [-w - 7, -13.42, -w, -13.42]];
					break;
				case SQUARE_TIP :
					tipShape = [[-((w / 2) + 5), -16], [-((w / 2) + 5), -((18 + h) + 4)], [((w / 2) + 5), -((18 + h) + 4)], [((w / 2) + 5), -16], [6, -16], [0, 0], [-6, -16], [-((w / 2) + 5), -16]];
					break;
				default :
					throw new Error("Undefined tool tip shape in TToolTip!");
					break;
			}

			var len : int = tipShape.length;
			this.graphics.beginFill(_tipColor, _tipAlpha);
			for (var i : int = 0;i < len;i++) {
				if (i == 0) {
					this.graphics.moveTo(tipShape[i][0], tipShape[i][1]);
				} else if (tipShape[i].length == 2) {
					this.graphics.lineTo(tipShape[i][0], tipShape[i][1]);
				} else if (tipShape[i].length == 4) {
					this.graphics.curveTo(tipShape[i][0], tipShape[i][1], tipShape[i][2], tipShape[i][3]);
				}
			}
			this.graphics.endFill();
			//			this.filters = [_bf,_ds];
			this.filters = [_ds];
			//

			label_txt.x = (_userTip == ROUND_TIP) ? Math.round(-w) : Math.round(-(w / 2)) - 2;
			_orgX = label_txt.x;
			label_txt.y = Math.round(-21 - h);
			_orgY = label_txt.y;
			this.addChild(label_txt);
		}

		public function tearDown(evt : Event = null) : void {
			//			trace("tearDown !!!!!!!!!!!!!!!!!!!!!!!!!" + evt.target.name);
			if(scope && this.parent == scope) {
				scope.removeChild(this);
			}
			if(target) {
				target.removeEventListener(Event.ENTER_FRAME, follow);
			}
		}

		public function follow(evt : Event) : void {
			//trace("following " + stage);
			if(this.stage == null) {
				tearDown();
			}
		}

		public function showAtPosition(ax : int, ay : int, scope : DisplayObjectContainer, delay : Number = 0) : void {
			//	var rect : Rectangle = dO.getBounds(scope);
			this.x = ax;//rect.x + rect.width / 2;
			y = ay + 3;
			this.scope = scope;
			createChildren();
			setTimeout(addToScope, delay);
		//	dO.addEventListener(Event.REMOVED, tearDown);
		//	dO.addEventListener(Event.ENTER_FRAME,follow);
		//	target = dO;
		}

		public function addToScope() : void {
			scope.addChild(this);	
		}

		public function showAt(dO : DisplayObject, scope : DisplayObjectContainer) : void {
			var rect : Rectangle = dO.getBounds(scope);
			x = rect.x + rect.width / 2;
			y = rect.y + 3;
			this.scope = scope;
			createChildren();
			scope.addChild(this);
			dO.addEventListener(Event.REMOVED, tearDown);
			dO.addEventListener(Event.ENTER_FRAME, follow);
			target = dO;
		}
	}
}