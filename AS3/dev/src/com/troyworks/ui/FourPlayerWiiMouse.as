package com.troyworks.ui {
	import flash.events.IOErrorEvent;	
	import flash.display.MovieClip;

	import com.senocular.ui.*;

	/*
	 * FourPlayerWiiMouse
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Dec 15, 2008
	 * 
	 * License Agreement
	 * 
	 * Permission is hereby granted, free of charge, to any person obtaining a copy
	 * of this software and associated documentation files (the "Software"), to deal
	 * in the Software without restriction, including without limitation the rights
	 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	 * copies of the Software, and to permit persons to whom the Software is
	 * furnished to do so, subject to the following conditions:
	 * 
	 * The above copyright notice and this permission notice shall be included in
	 * all copies or substantial portions of the Software.
	 * 
	 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	 * THE SOFTWARE.
	 *
	 * DESCRIPTION
	 */

	public class FourPlayerWiiMouse extends MovieClip {
		var _wiimotes : Array;
		var _wiimotesCount : int = 0;

		public function FourPlayerWiiMouse() {
		}

		public function init() : void {
			// connect all wii-remotes 
			// by connecting the first one 
			_wiimotes[0].connect();
			// event listeners 
			_wiimotes[0].addEventListener(IOErrorEvent.IO_ERROR, socketErr); 
			_wiimotes[1].addEventListener(IOErrorEvent.IO_ERROR, socketErr); 
			_wiimotes[2].addEventListener(IOErrorEvent.IO_ERROR, socketErr);
			_wiimotes[3].addEventListener(IOErrorEvent.IO_ERROR, socketErr);
			// event listeners for the wiimotes to check 
			// if they are running or not; 
			_wiimotes[0].addEventListener(WiimoteEvent.UPDATE, wiiUpdate);
			_wiimotes[1].addEventListener(WiimoteEvent.UPDATE, wiiUpdate);
			_wiimotes[2].addEventListener(WiimoteEvent.UPDATE, wiiUpdate);
			_wiimotes[3].addEventListener(WiimoteEvent.UPDATE, wiiUpdate);
		}

		// adds the wiimote to the connections list if 
		// packets of data were sent to that wiimotes ID
		function wiimotesConnected(a : Array,wiimoteNum : int) {
			if(a[wiimoteNum] != true) {
				a[wiimoteNum] = true; 
				_wiimotesCount++;
			}
			updateConnections(wiimoteNum);
		}

		// updates the connections that we have running

		function updateConnections(wiimoteNum : int) {
			core.tintColor(MovieClip(root)["mcConnection" + wiimoteNum], 0x20DF59, 1);
			txtStatus.text = "Status: " + _wiimotesCount + " wiimotes successfully connected! - Searching...";
			var percent : int = new int(((_wiimotes[wiimoteNum].batteryLevel) * 100));
			MovieClip(root)["txtBattery" + wiimoteNum.toString()].text = Math.round(percent) + "%";
		}

		/////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////

		// wiimotes are sending us packets of data; 
		// recieve them and direct them to the right
		// wiimote.

		function wiiUpdate(e : WiimoteEvent) : void {
 
			// this allows us to check for wiimotes;
			// it will find all the wiimotes (up to 4)
			if(getTimer() < checkTime) {
				var evt = e.target.id;
				wiimotesConnected(_wiimotesConnected, evt);
			}
 
			// once time has expired; we will remove all 
			// events.  if no wiimotes are found then they
			// cannot play the game until its hooked up.
			if(getTimer() > checkTime) {
     
				// remove the listeners that we added
				// because we don't need wiiUpdate anymore
				// cause we already found the connections
				_wiimotes[0].removeEventListener(WiimoteEvent.UPDATE, wiiUpdate);
				_wiimotes[1].removeEventListener(WiimoteEvent.UPDATE, wiiUpdate);
				_wiimotes[2].removeEventListener(WiimoteEvent.UPDATE, wiiUpdate);
				_wiimotes[3].removeEventListener(WiimoteEvent.UPDATE, wiiUpdate);
  
				// they can play because they have more than 2 wiimotes
				// since this a multiplayer only game
				if(_wiimotesCount >= 2) {
					txtStatus.text = "Status: Wiimotes were found; you can play!";
					isPlayable = true; 
					// the play game button will now be enabled
					Mouse.hide(); 
					// hide the mouse;
   
					// control the virtual mouse with the wiimotes
					_wiimotes[0].addEventListener(WiimoteEvent.UPDATE, wiiUpdateVirtual);
					addChild(vm); 
					// add the virtual mouse to the screen
					// start-up vm position
					_virtualMouse.x = stage.width / 2; 
					_virtualMouse.y = stage.height / 2;
   
					for(var c : uint = 0;c < _buttonEvents.length;c++) {
						var eventType : String = _buttonEvents[c];
						_wiimotes[0].addEventListener(eventType, OnButton_RELEASE);
					}
				} 
  
				// if they have less than 2 wiimotes they cannot play
				// because this is a multiplayer game only; and it requires
				// 2 players.
				if(_wiimotesCount < 2) {
					txtStatus.text = "Status: You do not have enough wiimotes connected!";
					isPlayable = false;
				}
			}
		}

		/////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////

		// wii server isnt running

		function socketErr(e : IOErrorEvent) : void {
			txtStatus.text = "Status: Please Initiate WiiServer , and Restart the Game.";
		}

		////////////////////////////////////////
		// WIIMOTE CONTROLLER; THIS ALLOWS PLAYERS
		// TO VIRTUALLY MOVE A MOUSE USING THE WIIMOTE
		// AND ALSO CONTROL MOUSE EVENTS
		// IT WILL ALSO CONSTRAIN TO THE STAGE

		var roll : Number = 0; 
		// roll (x) Virtual Mouse

		var pitch : Number = 0; 

		// pitch (y) Virtual Mouse

		function doTweening() {
			Tweener.addTween(_virtualMouse, {x:_virtualMouse.x + roll, y:_virtualMouse.y + pitch, time:0.1});
		}

		function wiiUpdateVirtual(e : Event) : void {
			roll = _wiimotes[vmController].roll; 
			// get specified wiimote roll
			pitch = _wiimotes[vmController].pitch; 
			// get specified wiimote pitch
			roll *= 15; 
			pitch *= 25; 
			// sensitivity

			if(vm.x > 0 && vm.x < stage.width - vm.width && vm.y + vm.height > 0 && vm.y < stage.height - vm.height) {
				// use tweener to smooth it out even more
				doTweening();
			}
		}

		var mouse : VirtualMouse = new VirtualMouse(stage, vm.x, vm.y);
mouse.ignore(vm);

stage.addEventListener(MouseEvent.MOUSE_MOVE, move);

		function move(event : MouseEvent) : void {
			// if event is of the type IVirtualMouseEvent
			// the event is from the virtual mouse
			if (event is IVirtualMouseEvent) {
				// hide indicator
				vm.x = mouse.x;
				vm.y = mouse.y;
			}
		}

		function doAction(event : ButtonEvent) : void {
			mouse.click();
		}
	}
}
