/**
 * VERSION: 0.6
 * DATE: 1/6/2010
 * AS3
 * UPDATES AND DOCUMENTATION AT: http://blog.greensock.com
 **/
package com.troyworks.controls.ttextfield {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextLineMetrics;

	/**
	 * NOTE: this is a reasonably amended class but performs simliar goals 
	 * - supports splitting by phrases (super important) rather than just words, and letters and lines
	 *  - that particular feature alone is 
	 * - reasonably supports html formatting (very important)
	 * - better support for bullets (had some bugs)
	 * 
	 * SplitTextField makes it easy to break apart a TextField so that each character, word, or line 
	 * is in its own TextField, making complex animation simple. When you create a SplitTextField, it 
	 * seamlessly replaces the source TextField with itself (a Sprite) containing these multiple TextFields, 
	 * all conveniently stored in a <b><code>textFields</code></b> array that you can, for example, 
	 * feed to a <code>TweenMax.allFrom()</code> or loop through to create unique tweens for each character, 
	 * word or line. The SplitTextField keeps the same scale/rotation/position as the source TextField, 
	 * and you can optionally offset the registration point by a certain number of pixels on its local 
	 * x- or y-axis, which can be useful if, for example, you want to be able to scale the whole 
	 * SplitTextField from its center instead of its upper left corner. Use an onComplete in your
	 * tween to call the SplitTextField's <code>deactivate()</code> or <code>destroy()</code> method 
	 * which will swap the original TextField back into place. <br /><br />
	 * 
	 * @example Example AS3 code:<listing version="3.0">
	import com.greensock.text.SplitTextField;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.plugins.~~;
	import flash.geom.Point;

	// split myTextField1 by characters (the default type of split)
	var stf1:SplitTextField = new SplitTextField(myTextField1);

	// tween each character down from 100 pixels above while fading in, and offset the start times by 0.05 seconds
	TweenMax.allFrom(stf1.textFields, 1, {y:"-100", autoAlpha:0, ease:Elastic.easeOut}, 0.05);

	// split myTextField2 by words
	var stf2:SplitTextField = new SplitTextField(myTextField2, SplitTextField.TYPE_WORDS);

	// explode the words outward using the physics2D feature of TweenLite/Max
	TweenPlugin.activate([Physics2DPlugin]);
	var i:int = stf2.textFields.length;
	var explodeOrigin:Point = new Point(stf2.width ~~ 0.4, stf2.height + 100);
	while (i--) {
	var angle:Number = Math.atan2(stf2.textFields[i].y - explodeOrigin.y, stf2.textFields[i].x - explodeOrigin.x) ~~ 180 / Math.PI;
	TweenMax.to(stf2.textFields[i], 2, {physics2D:{angle:angle, velocity:Math.random() ~~ 200 + 150, gravity:400}, scaleX:Math.random() ~~ 4 - 2, scaleY:Math.random() ~~ 4 - 2, rotation:Math.random() ~~ 100 - 50, autoAlpha:0, delay:1 + Math.random()});
	}

	// split myTextField3 by lines
	var stf3:SplitTextField = new SplitTextField(myTextField3, SplitTextField.TYPE_LINES);

	// slide each line in from the right, fading it in over 1 second and staggering the start times by 0.5 seconds. Then swap the original TextField back in.
	TweenMax.allFrom(stf3.textFields, 1, {x:"200", autoAlpha:0, onComplete:stf3.deactivate}, 0.5);

	</listing>
	 * 
	 * <b>NOTES / LIMITATIONS</b><br />
	 * <ul>
	 * 		<li>Does not recognize "Auto kern" feature in Flash.</li>
	 * 		<li>Positioning may be incorrect when non-standard anti-aliasing is used (like "anti-alias for readability"). Even with standard anti-aliasing, depending on the specific font you use positioning may be <i>slightly</i> off.</li>
	 * 		<li>Does not work with htmlText</li>
	 * 		<li>To improve performance, mouseChildren is set to false by default (you're welcome to set it to true if you need the TextFields to receive MouseEvents)</li>
	 * 		<li>To avoid some bugs in the way Flash renders TextFields, when creating TextField instances
	 * 			dynamically make sure you set the various properties of the TextField <b>BEFORE</b> adding
	 * 			the actual text. For example, set the <code>width, height, embedFonts, autoSize, multiline,</code> and 
	 * 			other properties before setting the <code>text</code> property.</li>
	 * 		<li>Not intended for use in Flex (use FlexSplitTextField instead)</li>
	 * </ul><br />
	 * 
	 * SplitTextField is a <a href="http://blog.greensock.com/club/">Club GreenSock</a> membership benefit. 
	 * You must have a valid membership to use this class without violating the terms of use. Visit 
	 * <a href="http://blog.greensock.com/club/">http://blog.greensock.com/club/</a> to sign up or get more details. <br /><br />
	 * 
	 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
	 * 
	 * @author Jack Doyle, jack@greensock.com
	 */
	public class SplitTextField extends Sprite {
		public var WHITESPACE : String = " \r\t\n";
		/** @private **/
		public static const version : Number = 0.6;
		/** Split type: characters **/
		public static const TYPE_CHARACTERS : String = "characters";
		/** Split type: words **/
		public static const TYPE_WORDS : String = "words";
		/** Split type: lines **/
		public static const TYPE_LINES : String = "lines";
		/** Split type: lines **/
		public static const TYPE_SEGMENTS : String = "segments";
		/** @private **/
		private static const _propNames : Array = ["embedFonts", "alpha", "antiAliasType", "blendMode", "filters", "focusRect", "gridFitType", "mouseEnabled", "sharpness", "selectable", "textColor", "thickness"];
		/** @private **/
		private var _splitType : String;
		/** @private **/
		private var _regOffsetX : Number;
		/** @private **/
		private var _regOffsetY : Number;
		/** @private **/
		private var _source : TextField;
		/** Array of TextFields resulting from the split (one for each character, word, or line based on the splitType) **/
		public var textFields : Array;
		/** index of the names **/
		public var textIndex : Object;
		public var textTfIndex : Object;
		/** a array of hard split phrases **/
		private var segmentOverides : Array;

		/**
		 * Constructor.
		 * 
		 * @param source The source TextField that should be split apart. Remember, this TextField will be replaced in the display list with the SplitTextField (which is essentially a Sprite containing the various resulting TextFields).
		 * @param splitType Determines the way in which the TextField is split apart - either by characters, words, or lines. Use the <code>TYPE_CHARACTERS, TYPE_WORDS,</code> and <code>TYPE_LINES</code> constants.
		 * @param regOffsetX To offset the registration point by a certain number of pixels along its x-axis (according to the SplitTextField's internal coordinate system), use regOffsetX.
		 * @param regOffsetY To offset the registration point by a certain number of pixels along its y-axis (according to the SplitTextField's internal coordinate system), use regOffsetY.
		 */
		public function SplitTextField(source : TextField = null, splitType : String = "characters", regOffsetX : Number = 0, regOffsetY : Number = 0, segmentOverides : Array = null) {
			super();
			_source = source;
			_splitType = splitType;
			_regOffsetX = regOffsetX;
			_regOffsetY = regOffsetY;
			this.mouseChildren = false;
			this.textFields = [];
			this.textIndex = new Object();
			this.textTfIndex = new Object();
			this.segmentOverides = segmentOverides;
			if (source) {
				update();
			}
		}

		/**
		 * This static method can be used to split apart any TextField and place the resulting
		 * TextFields into any DisplayObjectContainer. It provides the core functionality of the 
		 * SplitTextField class, but can be used apart from any instance thereof as well. 
		 * 
		 * @param source The source TextField that should be split apart. Remember, this TextField will be replaced in the display list with the SplitTextField (which is essentially a Sprite containing the various resulting TextFields).
		 * @param splitType Determines the way in which the TextField is split apart - either by characters, words, or lines. Use the <code>TYPE_CHARACTERS, TYPE_WORDS,</code> and <code>TYPE_LINES</code> constants.
		 * @param container The DisplayObjectContainer into which the new TextFields should be placed.
		 * @param offset Determines the offset x/y of the new TextFields. By default, the TextFields will be positioned in the container as though the container's registration point was aligned perfectly with the source TextField's. The source TextField's scale, rotation, and x/y coordinates will have no effect whatsoever. 
		 * @return Array of TextFields resulting from the split.
		 */
		public function split(source : TextField, spitType : String = "characters", container : DisplayObjectContainer = null, offset : Point = null, segs : Array = null) : Array {
			trace("SplitTExtField.split=============================================== ");
			if (container == null) {
				container = source.parent;
			}
			if (offset == null) {
				offset = new Point(0, 0);
			}
			var index : uint = (source.parent == container) ? source.parent.getChildIndex(source) : container.numChildren;
			var segments : Array;
			var cnt : uint = 0;
			var linesTotal : uint = source.numLines;
			var bounds : Rectangle = source.getBounds(source);
			// TextFields created in the Flash IDE usually have a -2 pixel offset, dynamically-created ones have a 0 pixel offset, and on the Mac, they can vary wildly! So we getBounds() to figure out how to compensate.
			var y : Number = bounds.y + offset.y;
			var fields : Array = [];
			var format : TextFormat, tf : TextField, x : Number, line : uint, i : uint, j : int, l : uint, text : String, totalSegments : uint, charOffset : uint, lineMetrics : TextLineMetrics, ascentDiff : Number;
			var firstbulletonline : Boolean = false;
			for (line = 0; line < linesTotal; line++) {
				firstbulletonline = false;
				text = source.getLineText(line);
				trace("GETLINE TEXT '" + text + "'");
				charOffset = source.getLineOffset(line);
				lineMetrics = source.getLineMetrics(line);

				if (source.text.length <= charOffset) {
					// sometimes Flash adds an extra line to the end unnecessarily
					continue;
				}

				// There are bugs in TextField.getCharBoundaries() that incorrectly returned null results occassionally, so we must figure it out using the align of the line.
				format = source.getTextFormat(charOffset, charOffset + 1);

				if (format.align == "left") {
					x = bounds.x + offset.x;
				} else if (format.align == "center") {
					x = bounds.x + offset.x - 2 + (source.width - lineMetrics.width) * 0.5;
				} else {
					x = bounds.x + offset.x - 4 + (source.width - lineMetrics.width);
				}
				var rect : Rectangle = source.getCharBoundaries(charOffset);
				if (rect != null) {
					x = rect.x;
				} else {
					trace("could not use getCharBounds " + charOffset + " '" + source.text.charAt(charOffset) + "'");
				}
				// --------------DECIDE HOW TO SPLIT ----------------------
				if (splitType == TYPE_SEGMENTS) {
					var res : Array = [];
					var seglen : int = 0;
					while (segs.length > 0 && ifContainsSegment(text, segs[0], seglen)) {
						var aseg : String = segs.shift();
						seglen += aseg.length;
						res.push(aseg);
					}
					trace("XYX segments:\r " + res.join("\r"));
					segments = res;
				} else if (spitType == TYPE_CHARACTERS) {
					segments = text.split("");
				} else if (spitType == TYPE_WORDS) {
					segments = text.split(" ").join("~#$ ~#$").split("~#$");
				} else {
					segments = [text];
				}
				totalSegments = segments.length;
				// --------------DO THE SPLIT ----------------------
				for (i = 0; i < totalSegments; i++) {
					if (segments[i].length == 0 ) {
						//
						continue;
					}
					tf = new TextField();
					//tf.border = true;
					// debugging purposes
					var xoffset : Number = 0;
					j = _propNames.length;
					while (j--) {
						tf[_propNames[j]] = source[_propNames[j]];
					}
					tf.autoSize = TextFieldAutoSize.LEFT;
					tf.selectable = tf.multiline = tf.wordWrap = false;
					tf.text = segments[i];
					trace(i + " text=:'" + segments[i] + "'");

					if (this.textIndex[segments[i]] == null) {
						this.textIndex[segments[i]] = 0;
					}
					this.textIndex[segments[i]]++;
					var name : String = segments[i] + "_" + this.textIndex[segments[i]] + "_txt";

					if (segments[i] == " " || segments[i] == "\r" || segments[i] == "\n") {
						// ignore
					} else {
						this.textTfIndex[name] = tf;
					}

					tf.name = name;
					// -------------- COPY TEXT FORMAT LETTER BY LETTER ----------------------
					if (true) {
						var AstartCC : int = 0;
						var AendCC : int = 0;
						var BstartCC : int = 0;
						var BendCC : int = 0;

						var str : String = segments[i];
						l = str.length;
						for (j = 0; j < l; j++) {
							try {
								trace("XXX " + j + " " + str.charAt(j));
								format = source.getTextFormat(charOffset, charOffset + 1);
							} catch(er : Error) {
								//MESSY, just use last format if in doubt, may have issues on edge cases.
								// due to white space/carriage return issues.
								trace("bad get charOffset" + er);
								//format = source.getTextFormat(charOffset - 1, charOffset + 1);
								// trace("format is " + Trace.me(format, "format"));
							}

							// trace("format is " + Trace.me(format, "format"));
							format.align = TextFormatAlign.LEFT;

							try {
								// trace("XXX " + j + " " + str.charAt(j));
								tf.setTextFormat(format, j, j + 1);
							} catch(er : Error) {
								trace("bad set charOffset" + er);
								tf.setTextFormat(format, j - 1, j);
							}

							if (format.bullet) {
								// helps keep every word on a bulleted line from beting bulleted.
								if (!firstbulletonline) {
									firstbulletonline = true;
									// trace(" tf  width " + tf.width + " tw " + tf.textWidth);
								} else {
									// y +=3;
									var bw : Number = tf.width;
									// trace(" tf correct width " + tf.width + " tw " + tf.textWidth);
									format = source.getTextFormat(charOffset, charOffset + 1);
									// trace("format is " + Trace.me(format, "format"));
									format.align = TextFormatAlign.LEFT;
									format.bullet = false;
									tf.setTextFormat(format, j, j + 1);
									if ((bw - tf.width) != 0) {
										xoffset = bw - tf.width;
									}
									// trace(" tf correct width2 " + tf.width + " tw " + tf.textWidth);
									// trace("xoffset " + xoffset + " for " + 	tf.text);
								}
							}

							charOffset += 1;
						}
					}

					tf.x = x + xoffset;
					tf.y = y;
					ascentDiff = lineMetrics.ascent - tf.getLineMetrics(0).ascent;
					// if different formatting is used on the same line (for example, a 50px letter next to a 12px letter), we must adjust the y position to make the baselines match.
					if (ascentDiff) {
						tf.y += ascentDiff;
					}
					x += tf.textWidth;
					if (segments[i] != " ") {
						fields[cnt++] = tf;
					}
				}

				y += lineMetrics.height;
			}

			i = fields.length;
			while (i--) {
				container.addChildAt(TextField(fields[i]), index);
			}
			if (source.parent) {
				source.parent.removeChild(source);
			}

			return fields;
		}

		private function ifContainsSegment(text : String, segs : String, seglen : int) : Boolean {
			if (text == null) {
				return false;
			}
			var tseg : String = trim(segs);
			trace("TEST '" + tseg + "' 1len:", (seglen < text.length), "contains:", (text.indexOf(tseg, seglen - 3) > -1), "whitespace:", (WHITESPACE.indexOf(segs) > -1));

			return (text.indexOf(tseg, seglen - 3) > -1) || (WHITESPACE.indexOf(segs) > -1);
			;
		}

		/** When a SplitTextField is activated, it takes the place of the source TextField in the display list. **/
		public function activate() : void {
			this.activated = true;
		}

		/** 
		 * When a SplitTextField is deactivated, it swaps the source TextField back into the display list. 
		 * This makes it simple to animate the SplitTextField's contents with TweenLite/Max and then use 
		 * an onComplete to call deactivate() which will swap the original (source) TextField back into place.
		 **/
		public function deactivate() : void {
			this.activated = false;
		}

		/** 
		 * Deactivates the SplitTextField (swapping the original TextField back into place) and 
		 * deletes all child TextFields that resulted from the split operation, and nulls references to 
		 * the source so that it's eligible for garbage collection. 
		 **/
		public function destroy() : void {
			this.activated = false;
			clear();
			_source = null;
		}

		/** @private **/
		private function update() : void {
			clear();
			if (_source.parent) {
				var p : DisplayObjectContainer = _source.parent;
				p.addChildAt(this, p.getChildIndex(_source));
				p.removeChild(_source);
			}
			var m : Matrix = _source.transform.matrix;
			if (_regOffsetX != 0 || _regOffsetY != 0) {
				var point : Point = m.transformPoint(new Point(_regOffsetX, _regOffsetY));
				m.tx = point.x;
				m.ty = point.y;
			}
			this.transform.matrix = m;
			this.textFields = split(_source, _splitType, this, new Point(-_regOffsetX, -_regOffsetY), this.segmentOverides);
		}

		/** @private **/
		private function clear() : void {
			var i : int = this.textFields.length;
			while (i--) {
				this.removeChild(this.textFields[i]);
			}
			this.textFields = [];
		}

		/** The source TextField that gets split apart. **/
		public function get source() : TextField {
			return _source;
		}

		public function set source(tf : TextField) : void {
			_source = tf;
			update();
		}

		/** Determines the way in which the source TextField is split apart - either by characters, words, or lines. Use the <code>TYPE_CHARACTERS, TYPE_WORDS,</code> and <code>TYPE_LINES</code> constants. **/
		public function get splitType() : String {
			return _splitType;
		}

		public function set splitType(type : String) : void {
			_splitType = type;
			update();
		}

		/** To offset the registration point by a certain number of pixels along its x-axis (according to the SplitTextField's internal coordinate system), use regOffsetX. **/
		public function get regOffsetX() : Number {
			return _regOffsetX;
		}

		public function set regOffsetX(x : Number) : void {
			_regOffsetX = x;
			update();
		}

		/** To offset the registration point by a certain number of pixels along its y-axis (according to the SplitTextField's internal coordinate system), use regOffsetY. **/
		public function get regOffsetY() : Number {
			return _regOffsetY;
		}

		public function set regOffsetY(y : Number) : void {
			_regOffsetY = y;
			update();
		}

		/** When a SplitTextField is activated, it replaces the source TextField in the display list. When it is deactivated, it swaps the source TextField back into place **/
		public function get activated() : Boolean {
			return Boolean(this.parent != null);
		}

		public function set activated(b : Boolean) : void {
			if (_source == null) {
				return;
			}
			if (_source.parent && b) {
				_source.parent.addChildAt(this, _source.parent.getChildIndex(_source));
				_source.parent.removeChild(_source);
			} else if (this.parent && !b) {
				this.parent.addChildAt(_source, this.parent.getChildIndex(this));
				this.parent.removeChild(this);
			}
		}

		private function trim(str1 : String = null) : String {
			var rs : String;

			if (str1 == null) {
				return null;
			}
			var s : String = String(str1);
			// trace("len " + str.length + " " + str1.length );
			// firstCharacter
			var A : Number = 0;
			// lastCharacter
			var B : Number = s.length;
			// find first character
			for (var j : Number = 0;j < s.length;j++) {
				// A useful character is anything over 32 (space, tab,
				// new line, etc are all below).
				var cc : Number = s.charCodeAt(j);
				// trace("Testing char "+j + " == " + s.charAt(j) + ": " + s.charCodeAt(j));
				if (cc > 32 && cc != 160) {
					// trace("first char "+j + " == " + s.charAt(j) + ": " + s.charCodeAt(j));
					A = j;
					break;
				} else if (j == s.length - 1) {
					// string is blank
					return '';
				}
			}
			// find last character
			for (var k : Number = s.length;k >= 0;k--) {
				// A useful character is anything over 32 (space, tab,
				// new line, etc are all below).
				var ccc : Number = s.charCodeAt(k);
				if (ccc > 32 && ccc != 160) {
					B = k + 1;
					break;
				}
			}
			rs = s.substring(A, B);
			// trace(str1 + " Trimmed to " + rs);

			return rs;
		}
	}
}