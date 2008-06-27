
/**
 * Singleton Tool Tip class AS3 Style
 * http://www.kirupa.com/forum/archive/index.php/t-265894.html
 * @author Devon O. Wolfgang
 */

package com.troyworks.controls.ttooltip {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class OBO_ToolTip extends Sprite {

		public static const ROUND_TIP : String = "roundTip";
		public static const SQUARE_TIP : String = "squareTip";

		private static var OBO_TT : OBO_ToolTip;

		private var _adv : Boolean;
		private var _tipText : TextField;
		private var _tipColor : uint;
		private var _tipAlpha : Number;
		private var _format : TextFormat;
		private var _ds : DropShadowFilter;
		private var _root : DisplayObjectContainer;
		private var _userTip : String;
		private var _orgX : int;
		private var _orgY : int;

		/**
		 * singleton class - use static createToolTip() method for instantiation
		 * @private
		 */

		public function OBO_ToolTip(tc : TipCreator, myRoot : DisplayObjectContainer, font : Font = null, tipColor : uint = 0xFFFFFF, tipAlpha : Number = 1, tipShape : String = "roundTip", fontColor : uint = 0x000000, fontSize : int = 11, advRendering : Boolean = true) {
			if (!tc is TipCreator) throw new Error("OBO_ToolTip class must be instantiated with static method OBO_ToolTip.createToolTip() method.");

			_root = myRoot;
			_tipColor = tipColor;
			_tipAlpha = tipAlpha;
			_userTip = tipShape;
			_adv = advRendering;
			_format = new TextFormat((font == null)?"_sans":font.fontName, fontSize, fontColor);
			_ds = new DropShadowFilter(3, 45, 0x000000, .7, 2, 2, 1, 3);

			this.mouseEnabled = false;
		}

		/**
		 * The OBO_ToolTip is a Singleton class which is instantiated using the the static method createToolTip(). It allows you to easily add tool tip items to DisplayObject instances.
		 *
		 * @example The following example creates a simple red square Sprite instance then instantiates a tool tip instance which displays when the mouse rolls over the square:
		 * <listing version="3.0">
		 * package {
		 *
		 * import flash.display.Sprite;
		 * import com.onebyonedesign.utils.OBO_ToolTip;
		 * import flash.events.MouseEvent;
		 *
		 * public class ToolTipExample extends Sprite {
		 *
		 * private var _toolTip:OBO_ToolTip;
		 * private var _mySprite:Sprite;
		 *
		 * public function ToolTipExample() {
		 * _mySprite = drawSprite();
		 * _mySprite.x = 100;
		 * _mySprite.y = 100;
		 * addChild(_mySprite);
		 *
		 * _toolTip = OBO_ToolTip.createToolTip(this, new LibraryFont(), 0x000000, .8, OBO_ToolTip.ROUND_TIP, 0xFFFFFF, 8, false);
		 *
		 * _mySprite.addEventListener(MouseEvent.ROLL_OVER, displayToolTip);
		 * _mySprite.addEventListener(MouseEvent.ROLL_OUT, removeToolTip);
		 * }
		 *
		 * private function displayToolTip(me:MouseEvent):void {
		 * _toolTip.addTip("This is a tool tip example.");
		 * }
		 *
		 * private function removeToolTip(me:MouseEvent):void {
		 * _toolTip.removeTip();
		 * }
		 *
		 * private function drawSprite():Sprite {
		 * var s:Sprite = new Sprite();
		 * s.graphics.beginFill(0xFF0000);
		 * s.graphics.drawRect(0, 0, 50, 50);
		 * s.graphics.endFill();
		 * return s;
		 * }
		 * }
		 * }
		 * </listing>
		 *
		 *
		 * @param myRoot The "root" display object which will parent the tool tip.
		 * @param font An instance of the embedded font class to use for the tool tip text.
		 * @param tipColor The hexadecimal color of the tool tip.
		 * @param tipAlpha The alpha of the tool tip (0 - 1).
		 * @param tipShape The shape of the tool tip. Either <code>OBO_ToolTip.ROUND_TIP</code> or <code>OBO_ToolTip.SQUARE_TIP</code>.
		 * @param fontColor The hexadecimal color of the tool tip's text.
		 * @param fontSize The size of the tool tip text.
		 * @param advRendering Recommend <code>false</code> for pixel fonts and <code>true</code> for others.
		 * @return A single instance of the OBO_ToolTip class.
		 */
		public static function createToolTip(myRoot : DisplayObjectContainer, font : Font, tipColor : uint = 0xFFFFFF, tipAlpha : Number = 1, tipShape : String = "roundTip", fontColor : uint = 0x000000, fontSize : int = 11, advRendering : Boolean = true) : OBO_ToolTip {
			if (OBO_TT == null) OBO_TT = new OBO_ToolTip(new TipCreator(), myRoot, font, tipColor, tipAlpha, tipShape, fontColor, fontSize, advRendering);
			return OBO_TT;
		}

		/**
		 * Use this method to display the tool tip.
		 *
		 * @param words The message the tool tip should display.
		 * @return
		 */
		public function addTip(words : String) : void {
			_root.addChild(this);
			_tipText = new TextField();
			_tipText.mouseEnabled = false;
			_tipText.selectable = false;
			_tipText.defaultTextFormat = _format;
			_tipText.antiAliasType = _adv ? AntiAliasType.ADVANCED : AntiAliasType.NORMAL;
			_tipText.width = 1;
			_tipText.height = 1;
			_tipText.autoSize = TextFieldAutoSize.LEFT;
		//	_tipText.embedFonts = true;
			_tipText.multiline = true;
			_tipText.text = words;

			var w : Number = _tipText.textWidth;
			var h : Number = _tipText.textHeight;

			var tipShape : Array;

			switch (_userTip) {
				case ROUND_TIP :
					tipShape = [[0, -13.42], [0, -2], [10.52, -15.7], [13.02, -18.01, 13.02, -22.65], [13.02, -16 - h], [13.23, -25.23 - h, 3.1, -25.23 - h], [-w , -25.23 - h], [-w - 7, -25.23 - h, -w - 7, -16 - h], [-w - 7, -22.65], [-w - 7, -13.42, -w, -13.42]];
					break;
				case SQUARE_TIP :
					tipShape = [[-((w / 2) + 5), -16], [-((w / 2) + 5), -((18 + h) + 4)], [((w / 2) + 5), -((18 + h) + 4)], [((w / 2) + 5), -16], [6, -16], [0, 0], [-6, -16], [-((w / 2) + 5), -16]];
					break;
				default :
					throw new Error("Undefined tool tip shape in OBO_ToolTip!");
					break;
			}

			var len : int = tipShape.length;
			this.graphics.beginFill(_tipColor, _tipAlpha);
			for (var i : int = 0;i < len; i++) {
				if (i == 0) {
					this.graphics.moveTo(tipShape[i][0], tipShape[i][1]);
				} else if (tipShape[i].length == 2) {
					this.graphics.lineTo(tipShape[i][0], tipShape[i][1]);
				} else if (tipShape[i].length == 4) {
					this.graphics.curveTo(tipShape[i][0], tipShape[i][1], tipShape[i][2], tipShape[i][3]);
				}
			}
			this.graphics.endFill();

			this.x = stage.mouseX;
			this.y = stage.mouseY;
			this.filters = [_ds];
			_tipText.x = (_userTip == ROUND_TIP) ? Math.round(-w) : Math.round(-(w / 2)) - 2;
			_orgX = _tipText.x;
			_tipText.y = Math.round(-21 - h);
			_orgY = _tipText.y;
			this.addChild(_tipText);

			stage.addEventListener(MouseEvent.MOUSE_MOVE, onTipMove);
		}

		private function onTipMove(me : MouseEvent) : void {
			this.x = Math.round(me.stageX);
			this.y = Math.round(me.stageY - 2);

			if (this.y - this.height < 0) {
				this.scaleY = _tipText.scaleY = -1;
				_tipText.y = (_userTip == ROUND_TIP) ? -18 : -16;
				this.y = Math.round(me.stageY + 5);
			} else {
				this.scaleY = _tipText.scaleY = 1;
				_tipText.y = _orgY;
			}

			if (this.x - (this.width - 18) < 0) {
				if (_userTip == ROUND_TIP) {
					this.scaleX = _tipText.scaleX = -1;
					_tipText.x = 5;
				}
			} else {
				this.scaleX = _tipText.scaleX = 1;
				_tipText.x = _orgX;
			}

			me.updateAfterEvent();
		}

		/**
		 * Use this method to remove the tool tip.
		 *
		 * @return
		 */
		public function removeTip() : void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onTipMove);
			this.removeChild(_tipText);
			this.graphics.clear();
			_root.removeChild(this);
		}

		/**
		 * Sets the shape of the tool tip. Valid arguments are the strings <code>OBO_ToolTip.ROUND_TIP</code> (or "roundTip") and <code>OBO_ToolTip.SQUARE_TIP</code> (or "squareTip"). Anything else will throw an error.
		 *
		 * @return
		 */
		public function set tipShape(shape : String) : void {
			if (shape != ROUND_TIP && shape != SQUARE_TIP) throw new Error("Invalid tip shape \"" + shape + "\" specified at OBO_ToolTip.tipShape.");
			_userTip = shape;
		}
	}
	
	
}

	
