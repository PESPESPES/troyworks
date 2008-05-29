/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.cogs.ui {
	import flash.display.Sprite;
	import flash.events.*;
	
	public class CogsVisualizer extends Sprite{
		var sH:XML =   <s_root>
		<s_0>
		  <s_2>
		<s_21>
		  <s_211/>
		</s_21>
		  </s_2>
		  <s_1>
		<s_11>
		  <s_111/>
		</s_11>
		  </s_1>
		</s_0>
		<s_initial/>
		  </s_root>;;
			
		var maxDepth:Number = 0;
		var curDepth:Number = 0;
		var radIdx:Object = new Object();
		
		public function CogsVisualizer():void{
			markDepth(sH, 0);
			trace("max " + maxDepth + " curNode \r" + sH.toXMLString());
		
			trace("stage " + stage.width + " "  +stage.height);
			createCogView(sH, this, 300, stage.width/2, stage.height/2);
		}

		
		function markDepth(curNode:XML, curDepth:Number, pos:Number = 1, ofNum:Number =1):void {
			curNode.@depth = curDepth;
			curNode.@i = pos;
			curNode.@of = ofNum;
			var nDepth:Number = curDepth+1;
			var len:Number = curNode.children().length();
			for (var i:int = 0; i <  len; i++) {
				markDepth(curNode.children()[i], nDepth, i, len);
				if (maxDepth < nDepth) {
					maxDepth = nDepth;
				}
			}
		}
		function onRollOverHandler(event:MouseEvent):void {
			trace("rollOver " + event.target.name);
			var st:Sprite = Sprite(event.target);
			st.graphics.clear();
			st.graphics.lineStyle(3,0xFFFF00);
			//st.graphics.beginFill(0xFFFF00, .2);
			st.graphics.beginFill(0xdddddd, .3);
			st.graphics.drawCircle(0, 0, radIdx[st.name ]);
			st.graphics.endFill();
		}
		function onRollOutHandler(event:MouseEvent):void {
			trace("onRollOutHandler " + event.target.name);
			var st:Sprite = Sprite(event.target);
			st.graphics.clear();
			st.graphics.lineStyle(1, 0x666666);
			st.graphics.beginFill(0xdddddd, .3);
			st.graphics.drawCircle(0, 0, radIdx[st.name ]);
			st.graphics.endFill();
		}
		function createCogView(curNode:XML, curClip:Sprite, curRadius:Number, cx:Number = 0, cy:Number  = 0):void {
			var st:Sprite = new Sprite();
			st.graphics.lineStyle(1, 0x666666);
			st.graphics.beginFill(0xdddddd, .3);
			trace( curNode.name() + " current Depth " + Number(curNode.@depth) + " curRadius " + curRadius);
			st.graphics.drawCircle(0, 0, curRadius);
			st.name = curNode.name();
			st.addEventListener(MouseEvent.ROLL_OVER, onRollOverHandler);
			st.addEventListener(MouseEvent.ROLL_OUT, onRollOutHandler);
			curClip.addChild(st);
			radIdx[st.name  ] = curRadius;
			st.x = cx;
			st.y = cy;
			//st.alpha = .3;

			var len:Number = curNode.children().length();
			var segs:Number = (Math.PI * 2)/len;
			var nRad:Number = curRadius - (curRadius/6*2.3);
			var dp:Number = Number(curNode.@depth);
			var odd:Boolean = Boolean(dp%2);
			trace(dp  + " odd " + odd);
			var segOffset:Number = (odd)?0: Math.PI/2;
			for (var i:int = 0; i <  len; i++) {
				var nx:Number = (len == 1)?0: Math.sin((segs * i)  + segOffset) * nRad;
				var ny:Number = (len == 1)?0:Math.cos((segs * i)  +segOffset) * nRad;
				var nR:Number = (len == 1)?curRadius - 10: (curRadius/3 -4);
				createCogView(curNode.children()[i], st, nR, nx, ny);

			}
		}
	}
	
}
